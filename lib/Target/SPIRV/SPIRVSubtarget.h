//===-- SPIRVSubtarget.h - Define Subtarget for SPIRV ----------*- C++ -*--===//
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
// This file declares the SPIRV specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SPIRV_SPIRVSUBTARGET_H
#define LLVM_LIB_TARGET_SPIRV_SPIRVSUBTARGET_H

#include "SPIRVFrameLowering.h"
#include "SPIRVISelLowering.h"
#include "SPIRVInstrInfo.h"
#include "SPIRVSubtarget.h"
#include "llvm/ADT/Triple.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/MC/MCInstrItineraries.h"
#include "llvm/Target/TargetSelectionDAGInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "SPIRVGenSubtarget.inc"

namespace llvm {
class SPIRVTargetMachine;

class SPIRVSubtarget : public SPIRVGenSubtargetInfo {
public:
  SPIRVSubtarget(const std::string &TT, const std::string &CPU,
                 const std::string &FS, const SPIRVTargetMachine &TM);

  const Triple &getTargetTriple() const { return TargetTriple; }
  const DataLayout *getDataLayout() const override { return &DL; }
  const SPIRVTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
  const SPIRVInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const SPIRVFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }
  const TargetSelectionDAGInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }
  const SPIRVRegisterInfo *getRegisterInfo() const override {
    return &getInstrInfo()->getRegisterInfo();
  }
private:
  const SPIRVTargetMachine &TM;
  Triple TargetTriple;
  const DataLayout DL;
  TargetSelectionDAGInfo TSInfo;
  SPIRVInstrInfo InstrInfo;
  SPIRVTargetLowering TLInfo;
  SPIRVFrameLowering FrameLowering;
};
} // End llvm namespace

#endif  // LLVM_LIB_TARGET_SPIRV_SPIRVSUBTARGET_H
