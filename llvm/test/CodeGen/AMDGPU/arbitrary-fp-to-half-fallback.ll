; RUN: llc -mtriple=amdgpu9.50-amd-amdhsa -verify-machineinstrs < %s | FileCheck %s --implicit-check-not='{{v_cvt(_pk)?_f16_(fp8|bf8)}}'

; gfx950 has native OCP FP8-to-f32 conversions, but no FP8-to-f16 conversions.
; The custom v2i8 source action must not select the latter while legalizing
; half results. This also applies when larger vectors split into pairs.

define <2 x half> @from_fp8_v2f16(<2 x i8> %src) {
; CHECK-LABEL: from_fp8_v2f16:
  %res = call <2 x half> @llvm.convert.from.arbitrary.fp.v2f16.v2i8(
      <2 x i8> %src, metadata !"Float8E4M3FN")
  ret <2 x half> %res
}

define <2 x half> @from_bf8_v2f16(<2 x i8> %src) {
; CHECK-LABEL: from_bf8_v2f16:
  %res = call <2 x half> @llvm.convert.from.arbitrary.fp.v2f16.v2i8(
      <2 x i8> %src, metadata !"Float8E5M2")
  ret <2 x half> %res
}

define <3 x half> @from_fp8_v3f16(<3 x i8> %src) {
; CHECK-LABEL: from_fp8_v3f16:
  %res = call <3 x half> @llvm.convert.from.arbitrary.fp.v3f16.v3i8(
      <3 x i8> %src, metadata !"Float8E4M3FN")
  ret <3 x half> %res
}

define <4 x half> @from_bf8_v4f16(<4 x i8> %src) {
; CHECK-LABEL: from_bf8_v4f16:
  %res = call <4 x half> @llvm.convert.from.arbitrary.fp.v4f16.v4i8(
      <4 x i8> %src, metadata !"Float8E5M2")
  ret <4 x half> %res
}

; Native conversion to f32 must remain available.
define <2 x float> @from_fp8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: from_fp8_v2f32:
; CHECK: v_cvt_pk_f32_fp8
  %res = call <2 x float> @llvm.convert.from.arbitrary.fp.v2f32.v2i8(
      <2 x i8> %src, metadata !"Float8E4M3FN")
  ret <2 x float> %res
}

define <2 x float> @from_bf8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: from_bf8_v2f32:
; CHECK: v_cvt_pk_f32_bf8
  %res = call <2 x float> @llvm.convert.from.arbitrary.fp.v2f32.v2i8(
      <2 x i8> %src, metadata !"Float8E5M2")
  ret <2 x float> %res
}

declare <2 x half> @llvm.convert.from.arbitrary.fp.v2f16.v2i8(<2 x i8>, metadata)
declare <3 x half> @llvm.convert.from.arbitrary.fp.v3f16.v3i8(<3 x i8>, metadata)
declare <4 x half> @llvm.convert.from.arbitrary.fp.v4f16.v4i8(<4 x i8>, metadata)
declare <2 x float> @llvm.convert.from.arbitrary.fp.v2f32.v2i8(<2 x i8>, metadata)
