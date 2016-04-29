; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -spirv-text -o %t.txt
; RUN: FileCheck < %t.txt %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-LLVM:      call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 0)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 1)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 2)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 3)

; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 0)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 1)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 2)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 3)

; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 0)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 1)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 2)
; CHECK-LLVM-NEXT: call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 3)

; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope1:[0-9]+]] [[MemSema1:[0-9]+]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope1]] [[MemSema2:[0-9]+]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope1]] [[MemSema3:[0-9]+]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope1]] [[MemSema4:[0-9]+]]

; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope2:[0-9]+]] [[MemSema1]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope2]] [[MemSema2]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope2]] [[MemSema3]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope2]] [[MemSema4]]

; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope3:[0-9]+]] [[MemSema1]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope3]] [[MemSema2]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope3]] [[MemSema3]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope3]] [[MemSema4]]

; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope4:[0-9]+]] [[MemSema1]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope4]] [[MemSema2]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope4]] [[MemSema3]]
; CHECK-SPIRV-DAG: 3 MemoryBarrier [[Scope4]] [[MemSema4]]

; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[Scope1]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[Scope2]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[Scope3]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[Scope4]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema1]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema2]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema3]] {{[0-9]+}}
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema4]] {{[0-9]+}}

; ModuleID = 'OpMemoryBarrier.ll'
target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-unknown"

; Function Attrs: nounwind
define spir_kernel void @test() #0 {
entry:
  call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 0) ; global mem fence + memory_scope_work_item
  call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 1) ; global mem fence + memory_scope_work_group
  call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 2) ; global mem fence + memory_scope__devices
  call spir_func void @_Z22atomic_work_item_fencejii(i32 2, i32 3, i32 3) ; global mem fence + memory_scope_all_svm_devices

  call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 0) ; local mem fence + memory_scope_work_item
  call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 1) ; local mem fence + memory_scope_work_group
  call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 2) ; local mem fence + memory_scope__devices
  call spir_func void @_Z22atomic_work_item_fencejii(i32 1, i32 3, i32 3) ; local mem fence + memory_scope_all_svm_devices

  call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 0) ; image mem fence + memory_scope_work_item
  call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 1) ; image mem fence + memory_scope_work_group
  call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 2) ; image mem fence + memory_scope__devices
  call spir_func void @_Z22atomic_work_item_fencejii(i32 4, i32 3, i32 3) ; image mem fence + memory_scope_all_svm_devices
  ret void
}

declare spir_func void @_Z22atomic_work_item_fencejii(i32, i32, i32) #1

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!opencl.kernels = !{!0}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!6}
!opencl.ocl.version = !{!7}
!opencl.used.extensions = !{!8}
!opencl.used.optional.core.features = !{!8}
!opencl.compiler.options = !{!8}
!llvm.ident = !{!9}

!0 = !{void ()* @test, !1, !2, !3, !4, !5}
!1 = !{!"kernel_arg_addr_space"}
!2 = !{!"kernel_arg_access_qual"}
!3 = !{!"kernel_arg_type"}
!4 = !{!"kernel_arg_base_type"}
!5 = !{!"kernel_arg_type_qual"}
!6 = !{i32 1, i32 2}
!7 = !{i32 2, i32 0}
!8 = !{}
!9 = !{!"clang version 3.6.2 "}
