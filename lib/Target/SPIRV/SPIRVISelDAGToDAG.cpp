//=- SPIRVISelDAGToDAG.cpp - A DAG pattern matching inst selector for SPIRV -=//
//
//                     The LLVM Compiler Infrastructure
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
//===----------------------------------------------------------------------===//
//
// This file defines a DAG pattern matching instruction selector for SPIRV,
// converting from a legalized dag to a SPIRV dag.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "spirv-isel"
#include "SPIRV.h"
#include "SPIRVInstrInfo.h"
#include "SPIRVRegisterInfo.h"
#include "SPIRVSubtarget.h"
#include "SPIRVTargetMachine.h"
#include "llvm/PassSupport.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "SPIRV.h"

using namespace llvm;

namespace {
class SPIRVDAGToDAGISel : public SelectionDAGISel {
  const SPIRVSubtarget *Subtarget;
  const DataLayout *DL;

public:
  explicit SPIRVDAGToDAGISel(SPIRVTargetMachine &tm, CodeGenOpt::Level OptLevel)
    : SelectionDAGISel(tm, OptLevel),
      Subtarget(&tm.getSubtarget<SPIRVSubtarget>()),
      DL(Subtarget->getDataLayout()) {
      }
  const char *getPassName() const override {
    return "SPIRV DAG->DAG Instruction Selection";
  }

  SDNode *Select(SDNode *) override;

private:
#include "SPIRVGenDAGISel.inc"

};
}

FunctionPass*
llvm::createSPIRVISelDag(SPIRVTargetMachine &TM,
    llvm::CodeGenOpt::Level OptLevel) {
  return new SPIRVDAGToDAGISel(TM, OptLevel);
}

SDNode*
SPIRVDAGToDAGISel::Select(SDNode *Node) {
  assert (Node);
  DEBUG(dbgs() << "Selecting: "; Node->dump(CurDAG); dbgs() << '\n');
  auto Res = SelectCode(Node);
  DEBUG(dbgs() << " => ";
    if (Res == nullptr)
      Node->dump(CurDAG);
    else
      Res->dump(CurDAG);
    dbgs() << '\n');
  return Res;
}
