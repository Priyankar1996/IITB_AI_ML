; ModuleID = 'prog.opt.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-unknown-linux-gnu"

@.str = private constant [19 x i8] c"system_output_pipe\00"
@.str1 = private constant [18 x i8] c"system_input_pipe\00"

define void @maxPool3D(i16 zeroext %cb, i16 zeroext %rb, i16 zeroext %ct, i16 zeroext %chl_out, i8 zeroext %index_in, i8 zeroext %index_out) nounwind {
entry:
  %shr91 = lshr i16 %chl_out, 3
  %mul = mul i16 %shr91, %ct
  %conv23 = zext i16 %shr91 to i32
  %conv25 = zext i16 %mul to i32
  %conv37 = zext i16 %ct to i32
  %mul42 = shl i32 %conv23, 1
  %add = add nsw i32 %conv25, %conv23
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %0 = phi i32 [ 0, %entry ], [ %add79, %while.body ]
  %row18.1 = phi i16 [ 0, %entry ], [ %inc76.row18.1, %while.body ]
  %col.1 = phi i16 [ 0, %entry ], [ %col.2, %while.body ]
  %chl.0 = phi i16 [ 0, %entry ], [ %chl.1, %while.body ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv31 = zext i16 %chl.0 to i32
  %conv35 = zext i16 %col.1 to i32
  %conv39 = zext i16 %row18.1 to i32
  %mul40 = mul nsw i32 %conv39, %conv37
  %add41 = add nsw i32 %conv35, %mul40
  %shl = mul i32 %mul42, %add41
  %add43 = add nsw i32 %shl, %conv31
  %add50 = add i32 %add43, %conv23
  %add54 = add i32 %add43, %conv25
  %add57 = add i32 %add, %add43
  %call = tail call zeroext i8 @maxPool4(i32 %0, i32 %add43, i32 %add50, i32 %add54, i32 %add57, i8 zeroext %index_in, i8 zeroext %index_out) nounwind
  %inc = add i16 %chl.0, 1
  %cmp = icmp eq i16 %inc, %shr91
  %inc67 = zext i1 %cmp to i16
  %inc67.col.1 = add i16 %inc67, %col.1
  %chl.1 = select i1 %cmp, i16 0, i16 %inc
  %cmp72 = icmp eq i16 %inc67.col.1, %cb
  %inc76 = zext i1 %cmp72 to i16
  %inc76.row18.1 = add i16 %inc76, %row18.1
  %col.2 = select i1 %cmp72, i16 0, i16 %inc67.col.1
  %add79 = add i32 %0, 1
  %cmp84 = icmp eq i16 %inc76.row18.1, %rb
  br i1 %cmp84, label %while.end, label %while.body

while.end:                                        ; preds = %while.body
  %inc76.row18.1.lcssa = phi i16 [ %inc76.row18.1, %while.body ]
  %conv89 = trunc i16 %inc76.row18.1.lcssa to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv89) nounwind
  ret void
}

declare void @__loop_pipelining_on__(i32, i32, i32)

declare zeroext i8 @maxPool4(i32, i32, i32, i32, i32, i8 zeroext, i8 zeroext)

declare void @write_uint8(i8*, i8 zeroext)

define void @fill_input() nounwind {
bb.nph:
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %0 = phi i32 [ 0, %bb.nph ], [ %inc, %for.body ]
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv = zext i8 %call to i64
  %shl = shl i64 %conv, 8
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv4 = zext i8 %call2 to i64
  %add = or i64 %shl, %conv4
  %shl6 = shl i64 %add, 8
  %call7 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv9 = zext i8 %call7 to i64
  %add10 = or i64 %shl6, %conv9
  %shl12 = shl i64 %add10, 8
  %call13 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv15 = zext i8 %call13 to i64
  %add16 = or i64 %shl12, %conv15
  %shl18 = shl i64 %add16, 8
  %call19 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv21 = zext i8 %call19 to i64
  %add22 = or i64 %shl18, %conv21
  %shl24 = shl i64 %add22, 8
  %call25 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv27 = zext i8 %call25 to i64
  %add28 = or i64 %shl24, %conv27
  %shl30 = shl i64 %add28, 8
  %call31 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv33 = zext i8 %call31 to i64
  %add34 = or i64 %shl30, %conv33
  %shl36 = shl i64 %add34, 8
  %call37 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv39 = zext i8 %call37 to i64
  %add40 = or i64 %shl36, %conv39
  tail call void @writeModule1(i32 %0, i64 %add40) nounwind
  %inc = add i32 %0, 1
  %exitcond1 = icmp eq i32 %inc, 200704
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare zeroext i8 @read_uint8(i8*)

declare void @writeModule1(i32, i64)

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
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv44) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv38) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv32) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv26) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv20) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv14) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv) nounwind
  %inc = add i32 %0, 1
  %exitcond1 = icmp eq i32 %inc, 50176
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare i64 @readModule1(i32)

define void @systemTOP() nounwind {
entry:
  tail call void @fill_input()
  %call = tail call i32 (...)* @timer() nounwind
  br label %while.body.i

while.body.i:                                     ; preds = %while.body.i, %entry
  %0 = phi i32 [ 0, %entry ], [ %add79.i, %while.body.i ]
  %row18.1.i = phi i16 [ 0, %entry ], [ %inc76.row18.1.i, %while.body.i ]
  %col.1.i = phi i16 [ 0, %entry ], [ %col.2.i, %while.body.i ]
  %chl.0.i = phi i16 [ 0, %entry ], [ %chl.1.i, %while.body.i ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv31.i = zext i16 %chl.0.i to i32
  %conv35.i = zext i16 %col.1.i to i32
  %conv39.i = zext i16 %row18.1.i to i32
  %mul40.i = mul nsw i32 %conv39.i, 112
  %add41.i = add nsw i32 %conv35.i, %mul40.i
  %shl.i = shl i32 %add41.i, 5
  %add43.i = add nsw i32 %shl.i, %conv31.i
  %add50.i = add i32 %add43.i, 16
  %add54.i = add i32 %add43.i, 1792
  %add57.i = add i32 %add43.i, 1808
  %call.i = tail call zeroext i8 @maxPool4(i32 %0, i32 %add43.i, i32 %add50.i, i32 %add54.i, i32 %add57.i, i8 zeroext 1, i8 zeroext 0) nounwind
  %inc.i = add i16 %chl.0.i, 1
  %cmp.i = icmp eq i16 %inc.i, 16
  %inc67.i = zext i1 %cmp.i to i16
  %inc67.col.1.i = add i16 %inc67.i, %col.1.i
  %chl.1.i = select i1 %cmp.i, i16 0, i16 %inc.i
  %cmp72.i = icmp eq i16 %inc67.col.1.i, 56
  %inc76.i = zext i1 %cmp72.i to i16
  %inc76.row18.1.i = add i16 %inc76.i, %row18.1.i
  %col.2.i = select i1 %cmp72.i, i16 0, i16 %inc67.col.1.i
  %add79.i = add i32 %0, 1
  %cmp84.i = icmp eq i16 %inc76.row18.1.i, 56
  br i1 %cmp84.i, label %maxPool3D.exit, label %while.body.i

maxPool3D.exit:                                   ; preds = %while.body.i
  %inc76.row18.1.i.lcssa = phi i16 [ %inc76.row18.1.i, %while.body.i ]
  %conv = sext i32 %call to i64
  %conv89.i = trunc i16 %inc76.row18.1.i.lcssa to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv89.i) nounwind
  %call1 = tail call i32 (...)* @timer() nounwind
  %conv2 = sext i32 %call1 to i64
  %sub = sub i64 %conv2, %conv
  %conv6 = trunc i64 %sub to i8
  %shr = lshr i64 %sub, 8
  %conv10 = trunc i64 %shr to i8
  %shr13 = lshr i64 %sub, 16
  %conv16 = trunc i64 %shr13 to i8
  %shr19 = lshr i64 %sub, 24
  %conv22 = trunc i64 %shr19 to i8
  %shr25 = lshr i64 %sub, 32
  %conv28 = trunc i64 %shr25 to i8
  %shr31 = lshr i64 %sub, 40
  %conv34 = trunc i64 %shr31 to i8
  %shr37 = lshr i64 %sub, 48
  %conv40 = trunc i64 %shr37 to i8
  %shr43 = lshr i64 %sub, 56
  %conv46 = trunc i64 %shr43 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv46) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv40) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv34) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv28) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv22) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv16) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv10) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv6) nounwind
  tail call void @sendOutput()
  ret void
}

declare i32 @timer(...)
