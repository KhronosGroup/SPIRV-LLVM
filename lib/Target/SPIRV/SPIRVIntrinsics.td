//===--- SPIRVIntrinsics.td - Defines SPIRV Intrinscs ----*- tablegen -*---===//
//
// This file defines all of the spirv-specific intrinsics
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

class GCCName<string opName, string pfxName = "__spirv_"#opName>
 : GCCBuiltin<pfxName>;

class SPIRVIntrinsic<string bltinName,
                     list<LLVMType> ret_types,
                     list<LLVMType> param_types = [],
                     list<IntrinsicProperty> properties = []>
  : Intrinsic<ret_types, param_types, properties>
  , GCCName<bltinName> {
  let TargetPrefix = "SPIRV";
  let isTarget = 1;
}

class tylist<list<LLVMType> tylst> { field list<LLVMType> lst = tylst; }
class tylist1<LLVMType Ty> : tylist<[Ty]>;
class tylist2<LLVMType Ty> : tylist<[Ty, Ty]>;
class tylist3<LLVMType Ty> : tylist<[Ty, Ty, Ty]>;
class tylist4<LLVMType Ty> : tylist<[Ty, Ty, Ty, Ty]>;

let TargetPrefix = "SPIRV", isTarget = 1 in {

class UnaryIntIntrNoMem : Intrinsic<[llvm_anyint_ty],
  [LLVMMatchType<0>], [IntrNoMem]>;

class UnaryFloatIntrNoMem : Intrinsic<[llvm_anyfloat_ty],
  [LLVMMatchType<0>], [IntrNoMem]>;

class BinaryIntIntrNoMem : Intrinsic<[llvm_anyint_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>], [IntrNoMem]>;

class BinaryFloatIntrNoMem : Intrinsic<[llvm_anyfloat_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>], [IntrNoMem]>;

class TernaryIntIntrNoMem : Intrinsic<[llvm_anyint_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>, LLVMMatchType<0>], [IntrNoMem]>;

class TernaryFloatIntrNoMem : Intrinsic<[llvm_anyfloat_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>, LLVMMatchType<0>], [IntrNoMem]>;

class UnaryIntFloatIntrNoMem : Intrinsic<[llvm_anyint_ty],
  [llvm_anyfloat_ty], [IntrNoMem]>;

class UnaryFloatIntIntrNoMem : Intrinsic<[llvm_anyfloat_ty],
  [llvm_anyint_ty], [IntrNoMem]>;

def int_SPIRV_copysign_f16 : GCCBuiltin<"__spirv_copysign_f16">, BinaryFloatIntrNoMem;
def int_SPIRV_copysign_f32 : GCCBuiltin<"__spirv_copysign_f32">, BinaryFloatIntrNoMem;
def int_SPIRV_copysign_f64 : GCCBuiltin<"__spirv_copysign_f64">, BinaryFloatIntrNoMem;
}
