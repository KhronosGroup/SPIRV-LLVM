//===-- SPIRVTargetMachine.cpp - Define TargetMachine for the SPIRV -------===//
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
// This file defines the SPIRV specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/SPIRVMCAsmInfo.h"
#include "SPIRVTargetMachine.h"
#include "SPIRV.h"

#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

extern "C" void LLVMInitializeSPIRVTarget() {
  RegisterTargetMachine<SPIRVTargetMachine> X(TheSPIRVTarget32);
  RegisterTargetMachine<SPIRVTargetMachine> Y(TheSPIRVTarget64);
}


SPIRVTargetMachine::SPIRVTargetMachine(const Target &T,
                                       StringRef TT,
                                       StringRef CPU,
                                       StringRef FS,
                                       const TargetOptions &Options,
                                       Reloc::Model RM,
                                       CodeModel::Model CM,
                                       CodeGenOpt::Level OL) :
  LLVMTargetMachine(T, TT, CPU, FS,Options, RM, CM,OL),
  Subtarget(TT, CPU, FS, *this),
  TLOF(new TargetLoweringObjectFileELF()){
  initAsmInfo();
  setAsmVerbosityDefault(true);
  setRequiresStructuredCFG(false);
}

TargetPassConfig *
SPIRVTargetMachine::createPassConfig(PassManagerBase &PM){
  return new SPIRVPassConfig(this, PM);
}

bool
SPIRVPassConfig::addInstSelector() {
  auto &TM = getTM<SPIRVTargetMachine>();
  addPass(createSPIRVISelDag(TM, TM.getOptLevel()));
  return false;
}
