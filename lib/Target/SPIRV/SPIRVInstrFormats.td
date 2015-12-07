//===------ SPIRVInstrFormats.td ---------------------------*- tablegen -*-===//
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

class SPIRVInst<dag outs, dag ins,
                string asmstr,
                list<dag> pattern,
                bits<16> WC = 0,
                bits<16> Op = 0,
                bit appendSemicolon = 1>
  : Instruction {
  field bits<16> WordCount;
  field bits<16> OpCode;
  field SPIRVProfile PFL;
  let Namespace = "SPIRV";
  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = !if(appendSemicolon, !strconcat(asmstr, ";"), asmstr);
  let Pattern = pattern;
  let UseNamedOperandTable = 1;
  let WordCount = WC;
  let OpCode = Op;
}

class SPIRVInstBasic<bits<16> WC, bits<16> Op, SPIRVProfile P,
                     dag outs, dag ins, string asmstr> :
  SPIRVInst<outs, ins, asmstr, [], WC, Op> {
  let hasSideEffects = 0;
  let PFL = P;
}

class SPIRVInstBasic_2Op<string opName, bits<16> Op, SPIRVProfile P> :
  SPIRVInstBasic<5, Op, P,
                 (outs P.DestRC:$dest),
                 (ins P.Src0RC:$src0, P.Src1RC:$src1),
  "5 "#opName#" $P.DestRC $dest $src0 $src1"
>;