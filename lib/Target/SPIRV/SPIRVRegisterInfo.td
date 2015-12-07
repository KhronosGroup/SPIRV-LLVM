//==- SPIRVRegisterInfo.td - Main SPIRV Register Definition -*- tablegen -*-==//
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
//
//===----------------------------------------------------------------------===//
//
// This file describes the SPIRV registers.
//
//===----------------------------------------------------------------------===//

class SPIRVReg<string n, int d> : Register<n> {
  let Namespace = "SPIRV";
  let DwarfNumbers = [d];
}

//1-bit registers
foreach N = 0-9999 in {
  def B#N : SPIRVReg<"$b"#N, !add(0, N)>;
}

//8-bit registers
foreach N = 0-9999 in {
  def C#N : SPIRVReg<"$c"#N, !add(10000, N)>;
}

//16-bit registers
foreach N = 0-9999 in {
  def S#N : SPIRVReg<"$s"#N, !add(20000, N)>;
}

//32-bit registers
foreach N = 0-9999 in {
  def I#N : SPIRVReg<"$i"#N, !add(30000, N)>;
}

//64-bit registers
foreach N = 0-9999 in {
  def L#N : SPIRVReg<"$l"#N, !add(40000, N)>;
}

def GPR1 : RegisterClass<"SPIRV", [i1], 1,
                         (sequence "B%u", 0, 9999)> {
}

def GPR8 : RegisterClass<"SPIRV", [i8], 8,
                         (sequence "C%u", 0, 9999)> {
}

def GPR16 : RegisterClass<"SPIRV", [i16, f16], 16,
                         (sequence "S%u", 0, 9999)> {
}

def GPR32 : RegisterClass<"SPIRV", [i32, f32], 32,
                         (sequence "I%u", 0, 9999)> {
}

def GPR64 : RegisterClass<"SPIRV", [i64, f64], 64,
                         (sequence "L%u", 0, 9999)> {
}

