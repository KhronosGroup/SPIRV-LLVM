//= SPIRVFrameLowering.h - Define frame lowering for SPIRV -------*- C++ -*-==//
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
// This class implements SPIRV-specific bits of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#ifndef _SPIRV_FRAME_LOWERING_H_
#define _SPIRV_FRAME_LOWERING_H_

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/Target/TargetFrameLowering.h"

namespace llvm {
  class MCSymbol;
  class SPIRVTargetMachine;

class SPIRVFrameLowering : public TargetFrameLowering {
public:
  explicit SPIRVFrameLowering(StackDirection D,
                              unsigned StackAl,
                              int LAO,
                              unsigned TransAl=1)
    : TargetFrameLowering(D, StackAl, LAO, TransAl) {}

  virtual void
  emitPrologue(MachineFunction &MF) const override {};

  virtual void
  emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override {};

  virtual bool
  hasFP(const MachineFunction &MF) const override { return false; };

  virtual int
  getFrameIndexOffset(const MachineFunction &MF, int FI) const override {
    return MF.getFrameInfo()->getObjectOffset(FI);
  };

  virtual void
  eliminateCallFramePseudoInstr(MachineFunction &MF,
                                MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator MI) const {
    MBB.erase(MI);
  }

}; // SPIRVFrameLowering

} // End llvm namespace

#endif // _SPIRV_FRAME_LOWERING_H_
