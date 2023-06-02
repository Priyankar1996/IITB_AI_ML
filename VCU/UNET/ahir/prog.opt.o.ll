; ModuleID = 'prog.opt.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-unknown-linux-gnu"

@.str = private constant [18 x i8] c"system_input_pipe\00"
@.str1 = private constant [19 x i8] c"system_output_pipe\00"
@.str2 = private constant [9 x i8] c"time_val\00"
@global_time_val = common global [20 x i64] zeroinitializer, align 8
@.str3 = private constant [18 x i8] c"debug_output_pipe\00"
@.str4 = private constant [17 x i8] c"debug_input_pipe\00"

define void @readFromSystemPipe(i8 zeroext %index) nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv = zext i8 %call to i32
  %shl = shl i32 %conv, 8
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv2 = zext i8 %call1 to i32
  %add = or i32 %shl, %conv2
  %shl4 = shl i32 %add, 8
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv6 = zext i8 %call5 to i32
  %add7 = or i32 %shl4, %conv6
  %cmp60 = icmp eq i32 %add7, 0
  br i1 %cmp60, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.preheader
  %0 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %call12 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv13 = zext i8 %call12 to i64
  %shl15 = shl i64 %conv13, 8
  %call16 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv18 = zext i8 %call16 to i64
  %add19 = or i64 %shl15, %conv18
  %shl21 = shl i64 %add19, 8
  %call22 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv24 = zext i8 %call22 to i64
  %add25 = or i64 %shl21, %conv24
  %shl27 = shl i64 %add25, 8
  %call28 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv30 = zext i8 %call28 to i64
  %add31 = or i64 %shl27, %conv30
  %shl33 = shl i64 %add31, 8
  %call34 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv36 = zext i8 %call34 to i64
  %add37 = or i64 %shl33, %conv36
  %shl39 = shl i64 %add37, 8
  %call40 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv42 = zext i8 %call40 to i64
  %add43 = or i64 %shl39, %conv42
  %shl45 = shl i64 %add43, 8
  %call46 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv48 = zext i8 %call46 to i64
  %add49 = or i64 %shl45, %conv48
  %shl51 = shl i64 %add49, 8
  %call52 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv54 = zext i8 %call52 to i64
  %add55 = or i64 %shl51, %conv54
  tail call void @writeModule1(i8 zeroext %index, i32 %0, i64 %add55) nounwind
  %inc = add i32 %0, 1
  %exitcond1 = icmp eq i32 %inc, %add7
  br i1 %exitcond1, label %for.end.loopexit, label %for.body

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

declare zeroext i8 @read_uint8(i8*)

declare void @writeModule1(i8 zeroext, i32, i64)

define void @fill_input() nounwind {
bb.nph:
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %0 = phi i8 [ 0, %bb.nph ], [ %inc, %for.body ]
  tail call void @readFromSystemPipe(i8 zeroext %0)
  %inc = add i8 %0, 1
  %exitcond1 = icmp eq i8 %inc, 2
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @sendOutput() nounwind {
bb.nph:
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %0 = phi i32 [ 0, %bb.nph ], [ %inc, %for.body ]
  %call = tail call i64 @readModule1(i32 %0) nounwind
  %conv = trunc i64 %call to i8
  %shr = lshr i64 %call, 8
  %conv8 = trunc i64 %shr to i8
  %shr11 = lshr i64 %call, 16
  %conv14 = trunc i64 %shr11 to i8
  %shr17 = lshr i64 %call, 24
  %conv20 = trunc i64 %shr17 to i8
  %shr23 = lshr i64 %call, 32
  %conv26 = trunc i64 %shr23 to i8
  %shr29 = lshr i64 %call, 40
  %conv32 = trunc i64 %shr29 to i8
  %shr35 = lshr i64 %call, 48
  %conv38 = trunc i64 %shr35 to i8
  %shr41 = lshr i64 %call, 56
  %conv44 = trunc i64 %shr41 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv44) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv38) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv32) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv26) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv20) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv14) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv) nounwind
  %inc = add i32 %0, 1
  %exitcond1 = icmp eq i32 %inc, 18816
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare i64 @readModule1(i32)

declare void @write_uint8(i8*, i8 zeroext)

define void @writeTime(i8 zeroext %ind) nounwind {
entry:
  %call = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  %idxprom = zext i8 %ind to i32
  %arrayidx = getelementptr inbounds [20 x i64]* @global_time_val, i32 0, i32 %idxprom
  store i64 %call, i64* %arrayidx, align 4
  ret void
}

declare i64 @read_uint64(i8*)

define i32 @writeTimeBack() nounwind {
bb.nph:
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %i.066 = phi i32 [ 0, %bb.nph ], [ %inc, %for.body ]
  %arrayidx = getelementptr [20 x i64]* @global_time_val, i32 0, i32 %i.066
  %tmp3 = load i64* %arrayidx, align 4
  %conv = trunc i64 %tmp3 to i8
  %shr = lshr i64 %tmp3, 8
  %conv10 = trunc i64 %shr to i8
  %shr13 = lshr i64 %tmp3, 16
  %conv16 = trunc i64 %shr13 to i8
  %shr19 = lshr i64 %tmp3, 24
  %conv22 = trunc i64 %shr19 to i8
  %shr25 = lshr i64 %tmp3, 32
  %conv28 = trunc i64 %shr25 to i8
  %shr31 = lshr i64 %tmp3, 40
  %conv34 = trunc i64 %shr31 to i8
  %shr37 = lshr i64 %tmp3, 48
  %conv40 = trunc i64 %shr37 to i8
  %shr43 = lshr i64 %tmp3, 56
  %conv46 = trunc i64 %shr43 to i8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv46) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv40) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv34) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv28) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv22) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv16) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv10) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0), i8 zeroext %conv) nounwind
  %inc = add nsw i32 %i.066, 1
  %exitcond1 = icmp eq i32 %inc, 19
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret i32 undef
}

declare void @__aa_barrier__(...)

define void @systemTOP() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([17 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 0), align 8
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 0, i8 zeroext 0, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i3 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i3, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 1), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 1, i8 zeroext 2, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i4 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i4, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 2), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 2, i8 zeroext 0, i8 zeroext 2, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i5 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i5, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 3), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 3, i8 zeroext 3, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i6 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i6, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 4), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 0, i8 zeroext 4, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i7 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i7, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 5), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 5, i8 zeroext 4, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i8 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i8, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 6), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 4, i8 zeroext 0, i8 zeroext 6, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i9 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i9, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 7), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 7, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i10 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i10, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 8), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 56, i16 zeroext 56, i16 zeroext 28, i16 zeroext 28, i16 zeroext 256, i16 zeroext 512, i16 zeroext 2, i16 zeroext 2, i8 zeroext 0, i8 zeroext 0, i8 zeroext 8, i8 zeroext 1, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i11 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i11, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 9), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i8 zeroext 4, i8 zeroext -127, i8 zeroext 9, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i12 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i12, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 10), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 0, i8 zeroext 10, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i13 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i13, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 11), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 112, i16 zeroext 112, i16 zeroext 56, i16 zeroext 56, i16 zeroext 128, i16 zeroext 256, i16 zeroext 2, i16 zeroext 2, i8 zeroext 1, i8 zeroext 0, i8 zeroext 11, i8 zeroext 0, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i14 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i14, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 12), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 3, i8 zeroext -128, i8 zeroext 12, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i15 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i15, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 13), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 13, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i16 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i16, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 14), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 112, i16 zeroext 112, i16 zeroext 64, i16 zeroext 128, i16 zeroext 2, i16 zeroext 2, i8 zeroext 0, i8 zeroext 0, i8 zeroext 14, i8 zeroext 1, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i17 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i17, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 15), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 2, i8 zeroext -127, i8 zeroext 15, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i18 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i18, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 16), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 0, i8 zeroext 16, i8 zeroext 1, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i19 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i19, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 17), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @convolutionAll(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 3, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 17, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 2) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call.i20 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str2, i32 0, i32 0)) nounwind
  store i64 %call.i20, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 18), align 8
  tail call void (...)* @__aa_barrier__() nounwind
  %call2 = tail call i32 @writeTimeBack()
  tail call void @sendOutput()
  ret void
}

declare void @convolutionAll(i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext, i8 zeroext, i8 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext)
