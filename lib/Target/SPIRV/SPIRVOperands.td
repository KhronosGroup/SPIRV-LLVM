//===---------- SPIRVOperands.td - SPIRV Operands -----*-tablegen-*--------===//
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

class SPIRVDestOperand <RegisterClass rc> : RegisterOperand <rc>;

class SPIRVSrcOperand <RegisterClass rc> : RegisterOperand <rc> {
  let OperandNamespace = "SPIRV";
  let OperandType = "OPERAND_REG_IMM";
}

def SPIRVDest1Operand : SPIRVDestOperand<GPR1>;
def SPIRVDest8Operand : SPIRVDestOperand<GPR8>;
def SPIRVDest16Operand : SPIRVDestOperand<GPR16>;
def SPIRVDest32Operand : SPIRVDestOperand<GPR32>;
def SPIRVDest64Operand : SPIRVDestOperand<GPR64>;

def SPIRVSrc1Operand : SPIRVSrcOperand<GPR1>;
def SPIRVSrc8Operand : SPIRVSrcOperand<GPR8>;
def SPIRVSrc16Operand : SPIRVSrcOperand<GPR16>;
def SPIRVSrc32Operand : SPIRVSrcOperand<GPR32>;
def SPIRVSrc64Operand : SPIRVSrcOperand<GPR64>;

class getRegOpForVT<ValueType VT> {
  RegisterOperand ret = !if(!eq(VT.Size, 32), SPIRVSrc32Operand,
                        !if(!eq(VT.Size, 64), SPIRVSrc64Operand,
                        !if(!eq(VT.Size, 16), SPIRVSrc16Operand,
                        !if(!eq(VT.Size, 8),  SPIRVSrc8Operand,
                                              SPIRVSrc1Operand))));
}

class getDestRegOpForVT<ValueType VT> {
  RegisterOperand ret = !if(!eq(VT.Size, 32), SPIRVDest32Operand,
                        !if(!eq(VT.Size, 64), SPIRVDest64Operand,
                        !if(!eq(VT.Size, 16), SPIRVDest16Operand,
                        !if(!eq(VT.Size, 8),  SPIRVDest8Operand,
                                              SPIRVDest1Operand))));
}

class SPIRVOperand<SPIRVType ty, string pm> : RegisterOperand<ty.SrcRC, pm> {
  field SPIRVType BT = ty;
  field ValueType VT = ty.VT;
  let PrintMethod = pm;

  let OperandNamespace = "SPIRV";
  let OperandType = "OPERAND_REG_IMM";
}

def UntypedOp : SPIRVOperand<UntypedTy, "">;
def I32Op : SPIRVOperand<I32Ty, "printI32">;
