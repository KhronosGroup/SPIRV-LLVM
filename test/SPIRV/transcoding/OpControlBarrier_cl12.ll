; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -spirv-text -o %t.txt
; RUN: FileCheck < %t.txt %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-LLVM: call spir_func void @_Z7barrierj(i32 2)
; CHECK-LLVM-NEXT: call spir_func void @_Z7barrierj(i32 1)
; CHECK-LLVM-NEXT: call spir_func void @_Z7barrierj(i32 4)
; CHECK-LLVM-NEXT: call spir_func void @_Z7barrierj(i32 3)
; CHECK-LLVM-NEXT: call spir_func void @_Z7barrierj(i32 5)
; CHECK-LLVM-NEXT: call spir_func void @_Z7barrierj(i32 7)

; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema1:[0-9]+]] 512
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema2:[0-9]+]] 256
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema3:[0-9]+]] 2048
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema4:[0-9]+]] 768
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema5:[0-9]+]] 2304
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema6:[0-9]+]] 2816
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[ScopeWorkGroup:[0-9]+]] 2

; CHECK-SPIRV: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema1]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema2]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema3]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema4]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema5]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema6]]


; ModuleID = 'barrier-cl12.cl'
target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; Function Attrs: nounwind
define spir_kernel void @test() #0 {
entry:
  call spir_func void @_Z7barrierj(i32 2) ; global mem fence
  call spir_func void @_Z7barrierj(i32 1) ; local mem fence
  call spir_func void @_Z7barrierj(i32 4) ; image mem fence

  call spir_func void @_Z7barrierj(i32 3) ; global | local
  call spir_func void @_Z7barrierj(i32 5) ; local | image
  call spir_func void @_Z7barrierj(i32 7) ; global | local | image

  ret void
}

declare spir_func void @_Z7barrierj(i32) #1

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!opencl.kernels = !{!0}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!6}
!opencl.ocl.version = !{!7}
!opencl.used.extensions = !{!8}
!opencl.used.optional.core.features = !{!8}
!opencl.compiler.options = !{!8}

!0 = !{void ()* @test, !1, !2, !3, !4, !5}
!1 = !{!"kernel_arg_addr_space"}
!2 = !{!"kernel_arg_access_qual"}
!3 = !{!"kernel_arg_type"}
!4 = !{!"kernel_arg_base_type"}
!5 = !{!"kernel_arg_type_qual"}
!6 = !{i32 1, i32 2}
!7 = !{i32 1, i32 2}
!8 = !{}
