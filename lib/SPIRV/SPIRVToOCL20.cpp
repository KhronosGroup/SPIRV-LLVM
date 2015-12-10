//===- SPIRVToOCL20.cpp - Transform SPIR-V builtins to OCL20 builtins-------===//
//
//                     The LLVM/SPIRV Translator
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// Copyright (c) 2014 Advanced Micro Devices, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal with the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimers.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimers in the documentation
// and/or other materials provided with the distribution.
// Neither the names of Advanced Micro Devices, Inc., nor the names of its
// contributors may be used to endorse or promote products derived from this
// Software without specific prior written permission.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH
// THE SOFTWARE.
//
//===----------------------------------------------------------------------===//
//
// This file implements transform SPIR-V builtins to OCL 2.0 builtins.
//
//===----------------------------------------------------------------------===//
#define DEBUG_TYPE "spvtocl20"

#include "SPIRVInternal.h"
#include "OCLUtil.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Pass.h"
#include "llvm/PassSupport.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#include <cstring>

using namespace llvm;
using namespace SPIRV;
using namespace OCLUtil;

namespace SPIRV {

static cl::opt<std::string>
MangledAtomicTypeNamePrefix("spirv-atomic-prefix",
    cl::desc("Mangled atomic type name prefix"), cl::init("U7_Atomic"));

class SPIRVToOCL20: public ModulePass,
  public InstVisitor<SPIRVToOCL20> {
public:
  SPIRVToOCL20():ModulePass(ID), M(nullptr), Ctx(nullptr) {
    initializeSPIRVToOCL20Pass(*PassRegistry::getPassRegistry());
  }
  virtual bool runOnModule(Module &M);
  virtual void visitCallInst(CallInst &CI);

  /// Transform __spirv_Atomic* to atomic_*.
  ///   __spirv_Atomic*(atomic_op, scope, sema, ops, ...) =>
  ///      atomic_*(atomic_op, ops, ..., order(sema), map(scope))
  void visitCallSPIRVAtomicBuiltin(CallInst *CI, Op OC);

  /// Transform __spirv_Group* to {work_group|sub_group}_*.
  ///
  /// Special handling of work_group_broadcast.
  ///   __spirv_GroupBroadcast(a, vec3(x, y, z))
  ///     =>
  ///   work_group_broadcast(a, x, y, z)
  ///
  /// Transform OpenCL group builtin function names from group_
  /// to workgroup_ and sub_group_.
  /// Insert group operation part: reduce_/inclusive_scan_/exclusive_scan_
  /// Transform the operation part:
  ///    fadd/iadd/sadd => add
  ///    fmax/smax => max
  ///    fmin/smin => min
  /// Keep umax/umin unchanged.
  void visitCallSPIRVGroupBuiltin(CallInst *CI, Op OC);

  /// Transform __spirv_MemoryBarrier to atomic_work_item_fence.
  ///   __spirv_MemoryBarrier(scope, sema) =>
  ///       atomic_work_item_fence(flag(sema), order(sema), map(scope))
  void visitCallSPIRVMemoryBarrier(CallInst *CI);

  /// Transform __spirv_{PipeOpName} to OCL pipe builtin functions.
  void visitCallSPIRVPipeBuiltin(CallInst *CI, Op OC);

  /// Transform __spirv_* builtins to OCL 2.0 builtins.
  /// No change with arguments.
  void visitCallSPIRVBuiltin(CallInst *CI, Op OC);

  /// Translate mangled atomic type name: "atomic_" =>
  ///   MangledAtomicTypeNamePrefix
  void translateMangledAtomicTypeName();

  /// Get prefix work_/sub_ for OCL group builtin functions.
  /// Assuming the first argument of \param CI is a constant integer for
  /// workgroup/subgroup scope enums.
  std::string getGroupBuiltinPrefix(CallInst *CI);

  static char ID;
private:
  Module *M;
  LLVMContext *Ctx;
};

char SPIRVToOCL20::ID = 0;

bool
SPIRVToOCL20::runOnModule(Module& Module) {
  M = &Module;
  Ctx = &M->getContext();
  visit(*M);

  translateMangledAtomicTypeName();

  DEBUG(dbgs() << "After SPIRVToOCL20:\n" << *M);

  std::string Err;
  raw_string_ostream ErrorOS(Err);
  if (verifyModule(*M, &ErrorOS)){
    DEBUG(errs() << "Fails to verify module: " << ErrorOS.str());
  }
  return true;
}

void
SPIRVToOCL20::visitCallInst(CallInst& CI) {
  DEBUG(dbgs() << "[visistCallInst] " << CI << '\n');
  auto F = CI.getCalledFunction();
  if (!F)
    return;

  auto MangledName = F->getName();
  std::string DemangledName;
  Op OC = OpNop;
  if (!oclIsBuiltin(MangledName, 20, &DemangledName) ||
      (OC = getSPIRVFuncOC(DemangledName)) == OpNop)
    return;
  DEBUG(dbgs() << "DemangledName = " << DemangledName.c_str() << '\n'
               << "OpCode = " << OC << '\n');

  if (OC == OpMemoryBarrier) {
    visitCallSPIRVMemoryBarrier(&CI);
    return;
  }
  if (isAtomicOpCode(OC)) {
    visitCallSPIRVAtomicBuiltin(&CI, OC);
    return;
  }
  if (isGroupOpCode(OC)) {
    visitCallSPIRVGroupBuiltin(&CI, OC);
    return;
  }
  if (isPipeOpCode(OC)) {
    visitCallSPIRVPipeBuiltin(&CI, OC);
    return;
  }
  if (OCLSPIRVBuiltinMap::rfind(OC))
    visitCallSPIRVBuiltin(&CI, OC);

}

void SPIRVToOCL20::visitCallSPIRVMemoryBarrier(CallInst* CI) {
  AttributeSet Attrs = CI->getCalledFunction()->getAttributes();
  mutateCallInstOCL(M, CI, [=](CallInst *, std::vector<Value *> &Args){
    auto getArg = [=](unsigned I){
      return cast<ConstantInt>(Args[I])->getZExtValue();
    };
    auto MScope = static_cast<Scope>(getArg(0));
    auto Sema = mapSPIRVMemSemanticToOCL(getArg(1));
    Args.resize(3);
    Args[0] = getInt32(M, Sema.first);
    Args[1] = getInt32(M, Sema.second);
    Args[2] = getInt32(M, rmap<OCLScopeKind>(MScope));
    return kOCLBuiltinName::AtomicWorkItemFence;
  }, &Attrs);
}

void SPIRVToOCL20::visitCallSPIRVAtomicBuiltin(CallInst* CI, Op OC) {
  AttributeSet Attrs = CI->getCalledFunction()->getAttributes();
  mutateCallInstOCL(M, CI, [=](CallInst *, std::vector<Value *> &Args){
    auto Ptr = findFirstPtr(Args);
    auto Name = OCLSPIRVBuiltinMap::rmap(OC);
    auto NumOrder = getAtomicBuiltinNumMemoryOrderArgs(Name);
    auto ScopeIdx = Ptr + 1;
    auto OrderIdx = Ptr + 2;
    if (OC == OpAtomicIIncrement ||
        OC == OpAtomicIDecrement) {
      Args.erase(Args.begin() + OrderIdx, Args.begin() + ScopeIdx + 1);
    } else {
      Args[ScopeIdx] = mapUInt(M, cast<ConstantInt>(Args[ScopeIdx]),
          [](unsigned I){
        return rmap<OCLScopeKind>(static_cast<Scope>(I));
      });
      for (size_t I = 0; I < NumOrder; ++I)
        Args[OrderIdx + I] = mapUInt(M, cast<ConstantInt>(Args[OrderIdx + I]),
            [](unsigned Ord) {
        return mapSPIRVMemOrderToOCL(Ord);
      });
      std::swap(Args[ScopeIdx], Args.back());
    }
    return Name;
  }, &Attrs);
}

void SPIRVToOCL20::visitCallSPIRVBuiltin(CallInst* CI, Op OC) {
  AttributeSet Attrs = CI->getCalledFunction()->getAttributes();
  mutateCallInstOCL(M, CI, [=](CallInst *, std::vector<Value *> &Args){
    return OCLSPIRVBuiltinMap::rmap(OC);
  }, &Attrs);
}

void SPIRVToOCL20::visitCallSPIRVGroupBuiltin(CallInst* CI, Op OC) {
  auto DemangledName = OCLSPIRVBuiltinMap::rmap(OC);
  assert(DemangledName.find(kSPIRVName::GroupPrefix) == 0);

  std::string Prefix = getGroupBuiltinPrefix(CI);

  bool HasGroupOperation = hasGroupOperation(OC);
  if (!HasGroupOperation) {
    DemangledName = Prefix + DemangledName;
  } else {
    auto GO = getArgAs<spv::GroupOperation>(CI, 1);
    StringRef Op = DemangledName;
    Op = Op.drop_front(strlen(kSPIRVName::GroupPrefix));
    bool Unsigned = Op.front() == 'u';
    if (!Unsigned)
      Op = Op.drop_front(1);
    DemangledName = Prefix + kSPIRVName::GroupPrefix +
        SPIRSPIRVGroupOperationMap::rmap(GO) + '_' + Op.str();
  }
  AttributeSet Attrs = CI->getCalledFunction()->getAttributes();
  mutateCallInstOCL(M, CI, [=](CallInst *, std::vector<Value *> &Args){
    Args.erase(Args.begin(), Args.begin() + (HasGroupOperation ? 2 : 1));
    if (OC == OpGroupBroadcast)
      expandVector(CI, Args, 1);
    return DemangledName;
  }, &Attrs);
}

void SPIRVToOCL20::visitCallSPIRVPipeBuiltin(CallInst* CI, Op OC) {
  switch(OC) {
  case OpReservedReadPipe:
    OC = OpReadPipe;
    break;
  case OpReservedWritePipe:
    OC = OpWritePipe;
    break;
  default:
    // Do nothing.
    break;
  }
  auto DemangledName = OCLSPIRVBuiltinMap::rmap(OC);

  bool HasScope = DemangledName.find(kSPIRVName::GroupPrefix) == 0;
  if (HasScope)
    DemangledName = getGroupBuiltinPrefix(CI) + DemangledName;

  AttributeSet Attrs = CI->getCalledFunction()->getAttributes();
  mutateCallInstOCL(M, CI, [=](CallInst *, std::vector<Value *> &Args){
    if (HasScope)
      Args.erase(Args.begin(), Args.begin() + 1);

    if (!(OC == OpReadPipe ||
          OC == OpWritePipe ||
          OC == OpReservedReadPipe ||
          OC == OpReservedWritePipe))
      return DemangledName;

    auto &P = Args[Args.size() - 3];
    auto T = P->getType();
    assert(isa<PointerType>(T));
    auto ET = T->getPointerElementType();
    if (!ET->isIntegerTy(8) ||
        T->getPointerAddressSpace() != SPIRAS_Generic) {
      auto NewTy = PointerType::getInt8PtrTy(*Ctx, SPIRAS_Generic);
      P = CastInst::CreatePointerBitCastOrAddrSpaceCast(P, NewTy, "", CI);
    }
    return DemangledName;
  }, &Attrs);
}

void SPIRVToOCL20::translateMangledAtomicTypeName() {
  for (auto &I:M->functions()) {
    if (!I.hasName())
      continue;
    std::string MangledName = I.getName();
    std::string DemangledName;
    if (!oclIsBuiltin(MangledName, 20, &DemangledName) ||
        DemangledName.find(kOCLBuiltinName::AtomPrefix) != 0)
      continue;
    auto Loc = MangledName.find(kOCLBuiltinName::AtomPrefix);
    Loc = MangledName.find(kMangledName::AtomicPrefixInternal, Loc);
    MangledName.replace(Loc, strlen(kMangledName::AtomicPrefixInternal),
        MangledAtomicTypeNamePrefix);
    I.setName(MangledName);
  }
}

std::string
SPIRVToOCL20::getGroupBuiltinPrefix(CallInst* CI) {
  std::string Prefix;
  auto ES = getArgAsScope(CI, 0);
  switch(ES) {
  case ScopeWorkgroup:
    Prefix = kOCLBuiltinName::WorkPrefix;
    break;
  case ScopeSubgroup:
    Prefix = kOCLBuiltinName::SubPrefix;
    break;
  default:
    llvm_unreachable("Invalid execution scope");
  }
  return Prefix;
}

}

INITIALIZE_PASS(SPIRVToOCL20, "spvtoocl20",
    "Translate SPIR-V builtins to OCL 2.0 builtins", false, false)

ModulePass *llvm::createSPIRVToOCL20() {
  return new SPIRVToOCL20();
}
