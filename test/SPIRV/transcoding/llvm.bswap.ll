; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -spirv-text -o %t.txt
; RUN: FileCheck < %t.txt %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-SPIRV-NOT: llvm.bswap

; CHECK-SPIRV: ShiftLeftLogical [[shortType:[0-9]+]] [[tmpShort1:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[shortType]] [[tmpShort2:[0-9]+]]
; CHECK-SPIRV: BitwiseOr [[shortType]] {{[0-9]+}} [[tmpShort1]] [[tmpShort2]]

; CHECK-SPIRV: ShiftLeftLogical [[intType:[0-9]+]] [[tmpInt1:[0-9]+]]
; CHECK-SPIRV: ShiftLeftLogical [[intType]] [[tmpInt2:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[intType]] [[tmpInt3:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[intType]] [[tmpInt4:[0-9]+]]
; CHECK-SPIRV: BitwiseAnd [[intType]] [[tmpInt5:[0-9]+]] [[tmpInt2]]
; CHECK-SPIRV: BitwiseAnd [[intType]] [[tmpInt6:[0-9]+]] [[tmpInt3]]
; CHECK-SPIRV: BitwiseOr [[intType]] [[tmpInt7:[0-9]+]] [[tmpInt1]] [[tmpInt5]]
; CHECK-SPIRV: BitwiseOr [[intType]] [[tmpInt8:[0-9]+]] [[tmpInt6]] [[tmpInt4]]
; CHECK-SPIRV: BitwiseOr [[intType]] {{[0-9]+}} [[tmpInt7]] [[tmpInt8]]

; CHECK-SPIRV: ShiftLeftLogical [[longType:[0-9]+]] [[tmpLong1:[0-9]+]]
; CHECK-SPIRV: ShiftLeftLogical [[longType]] [[tmpLong2:[0-9]+]]
; CHECK-SPIRV: ShiftLeftLogical [[longType]] [[tmpLong3:[0-9]+]]
; CHECK-SPIRV: ShiftLeftLogical [[longType]] [[tmpLong4:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[longType]] [[tmpLong5:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[longType]] [[tmpLong6:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[longType]] [[tmpLong7:[0-9]+]]
; CHECK-SPIRV: ShiftRightLogical [[longType]] [[tmpLong8:[0-9]+]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong9:[0-9]+]] [[tmpLong2]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong10:[0-9]+]] [[tmpLong3]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong11:[0-9]+]] [[tmpLong4]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong12:[0-9]+]] [[tmpLong5]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong13:[0-9]+]] [[tmpLong6]]
; CHECK-SPIRV: BitwiseAnd [[longType]] [[tmpLong14:[0-9]+]] [[tmpLong7]]
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong15:[0-9]+]] [[tmpLong1]] [[tmpLong9]] 
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong16:[0-9]+]] [[tmpLong10]] [[tmpLong11]]
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong17:[0-9]+]] [[tmpLong12]] [[tmpLong13]] 
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong18:[0-9]+]] [[tmpLong14]] [[tmpLong8]] 
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong19:[0-9]+]] [[tmpLong15]] [[tmpLong16]] 
; CHECK-SPIRV: BitwiseOr [[longType]] [[tmpLong20:[0-9]+]] [[tmpLong17]] [[tmpLong18]] 
; CHECK-SPIRV: BitwiseOr [[longType]] {{[0-9]+}} [[tmpLong19]] [[tmpLong20]] 


; CHECK-LLVM-NOT: llvm.bswap

; CHECK-LLVM: [[rShort1:%[0-9]+]] = shl i16 [[argShort:%[0-9a-z]+]], 8
; CHECK-LLVM: [[rShort2:%[0-9]+]] = lshr exact i16 [[argShort]], 8
; CHECK-LLVM: {{%[0-9a-z]+}} = or i16 [[rShort1]], [[rShort2]]

; CHECK-LLVM: [[rInt1:%[0-9]+]] = shl i32 [[argInt:%[0-9a-z]+]], 24
; CHECK-LLVM: [[rInt2:%[0-9]+]] = shl i32 [[argInt]], 8
; CHECK-LLVM: [[rInt3:%[0-9]+]] = lshr exact i32 [[argInt]], 8
; CHECK-LLVM: [[rInt4:%[0-9]+]] = lshr exact i32 [[argInt]], 24
; CHECK-LLVM: [[rInt5:%[0-9]+]] = and i32 [[rInt2]], 16711680
; CHECK-LLVM: [[rInt6:%[0-9]+]] = and i32 [[rInt3]], 65280
; CHECK-LLVM: [[rInt7:%[0-9]+]] = or i32 [[rInt1]], [[rInt5]]
; CHECK-LLVM: [[rInt8:%[0-9]+]] = or i32 [[rInt6]], [[rInt4]]
; CHECK-LLVM: {{%[0-9a-z]+}} = or i32 [[rInt7]], [[rInt8]]

; CHECK-LLVM: [[rLong1:%[0-9]+]] = shl i64 [[argLong:%[0-9a-z]+]], 56
; CHECK-LLVM: [[rLong2:%[0-9]+]] = shl i64 [[argLong]], 40
; CHECK-LLVM: [[rLong3:%[0-9]+]] = shl i64 [[argLong]], 24
; CHECK-LLVM: [[rLong4:%[0-9]+]] = shl i64 [[argLong]], 8
; CHECK-LLVM: [[rLong5:%[0-9]+]] = lshr exact i64 [[argLong]], 8
; CHECK-LLVM: [[rLong6:%[0-9]+]] = lshr exact i64 [[argLong]], 24
; CHECK-LLVM: [[rLong7:%[0-9]+]] = lshr exact i64 [[argLong]], 40
; CHECK-LLVM: [[rLong8:%[0-9]+]] = lshr exact i64 [[argLong]], 56
; CHECK-LLVM: [[rLong9:%[0-9]+]] = and i64 [[rLong2]], 71776119061217280
; CHECK-LLVM: [[rLong10:%[0-9]+]] = and i64 [[rLong3]], 280375465082880
; CHECK-LLVM: [[rLong11:%[0-9]+]] = and i64 [[rLong4]], 1095216660480
; CHECK-LLVM: [[rLong12:%[0-9]+]] = and i64 [[rLong5]], 4278190080
; CHECK-LLVM: [[rLong13:%[0-9]+]] = and i64 [[rLong6]], 16711680
; CHECK-LLVM: [[rLong14:%[0-9]+]] = and i64 [[rLong7]], 65280
; CHECK-LLVM: [[rLong15:%[0-9]+]] = or i64 [[rLong1]], [[rLong9]]
; CHECK-LLVM: [[rLong16:%[0-9]+]] = or i64 [[rLong10]], [[rLong11]]
; CHECK-LLVM: [[rLong17:%[0-9]+]] = or i64 [[rLong12]], [[rLong13]]
; CHECK-LLVM: [[rLong18:%[0-9]+]] = or i64 [[rLong14]], [[rLong8]]
; CHECK-LLVM: [[rLong19:%[0-9]+]] = or i64 [[rLong15]], [[rLong16]]
; CHECK-LLVM: [[rLong20:%[0-9]+]] = or i64 [[rLong17]], [[rLong18]]
; CHECK-LLVM: {{%[0-9a-z]+}} = or i64 [[rLong19]], [[rLong20]]



target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spir-unknown-unknown"

declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)

define i16 @test_bswap_i16(i16 %a) {
  %bswap = call i16 @llvm.bswap.i16(i16 %a)
  ret i16 %bswap
}

define i32 @test_bswap_i32(i32 %a) {
  %bswap = call i32 @llvm.bswap.i32(i32 %a)
  ret i32 %bswap
}

define i64 @test_bswap_i64(i64 %a) {
  %bswap = call i64 @llvm.bswap.i64(i64 %a)
  ret i64 %bswap
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!7}
!opencl.ocl.version = !{!7}
!opencl.used.extensions = !{!8}
!opencl.used.optional.core.features = !{!8}
!opencl.compiler.options = !{!8}
!llvm.ident = !{!9}

!7 = !{i32 1, i32 2}
!8 = !{}
!9 = !{!"clang version 3.6.1 (https://github.com/KhronosGroup/SPIR d7e44c3b27581e54ca0e522987d1ade2bd29b70d) (https://github.com/KhronosGroup/SPIRV-LLVM.git d42743684ea8338358504e44ef8363b9dc675c66)"}
