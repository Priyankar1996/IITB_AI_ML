; ModuleID = 'prog.opt.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-unknown-linux-gnu"

@.str = private constant [19 x i8] c"system_output_pipe\00"
@.str1 = private constant [18 x i8] c"system_input_pipe\00"

define void @concat(i16 zeroext %input1_dim0, i16 zeroext %input1_dim1, i16 zeroext %input1_dim2, i16 zeroext %input2_dim0, i16 zeroext %input2_dim1, i16 zeroext %input2_dim2, i16 zeroext %out_dim0, i16 zeroext %out_dim1, i16 zeroext %out_dim2, i8 zeroext %index0, i8 zeroext %index1, i8 zeroext %index2) nounwind {
entry:
  %conv = zext i16 %out_dim0 to i32
  %conv2 = zext i16 %out_dim1 to i32
  %conv4 = zext i16 %out_dim2 to i32
  %mul = mul nsw i32 %conv2, %conv
  %mul5 = mul nsw i32 %mul, %conv4
  %shr23 = lshr i16 %input1_dim2, 3
  %shr1324 = lshr i16 %input2_dim2, 3
  %call = tail call zeroext i8 @concat_core(i16 zeroext %shr23, i16 zeroext %shr1324, i32 %mul5, i8 zeroext %index0, i8 zeroext %index1, i8 zeroext %index2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call) nounwind
  ret void
}

declare zeroext i8 @concat_core(i16 zeroext, i16 zeroext, i32, i8 zeroext, i8 zeroext, i8 zeroext)

declare void @write_uint8(i8*, i8 zeroext)

define void @zeropad(i16 zeroext %input_dim0, i16 zeroext %input_dim1, i16 zeroext %input_dim2, i16 zeroext %out_dim0, i16 zeroext %out_dim1, i16 zeroext %out_dim2, i8 zeroext %index1, i8 zeroext %index2) nounwind {
entry:
  %call = tail call zeroext i8 @zeropad_same(i16 zeroext %input_dim0, i16 zeroext %input_dim1, i16 zeroext %input_dim2, i16 zeroext %out_dim0, i16 zeroext %out_dim1, i16 zeroext %out_dim2, i8 zeroext %index1, i8 zeroext %index2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call) nounwind
  ret void
}

declare zeroext i8 @zeropad_same(i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext)

define void @convTranspose(i16 zeroext %inp_dim0, i16 zeroext %inp_dim1, i16 zeroext %inp_dim2, i16 zeroext %ker_dim1, i16 zeroext %ker_dim2, i16 zeroext %stride0, i16 zeroext %padding, i16 zeroext %out_dim0, i16 zeroext %out_dim1, i16 zeroext %out_dim2, i8 zeroext %index1, i8 zeroext %index2) nounwind {
entry:
  %call = tail call zeroext i8 @ct_core(i16 zeroext %inp_dim0, i16 zeroext %inp_dim1, i16 zeroext %inp_dim2, i16 zeroext %ker_dim1, i16 zeroext %ker_dim2, i16 zeroext %out_dim0, i16 zeroext %out_dim1, i16 zeroext %out_dim2, i16 zeroext %stride0, i16 zeroext %padding, i8 zeroext %index1, i8 zeroext %index2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call) nounwind
  ret void
}

declare zeroext i8 @ct_core(i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext)

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

define void @readFromSystemPipe(i8 zeroext %index) nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv = zext i8 %call to i32
  %shl = shl i32 %conv, 8
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv2 = zext i8 %call1 to i32
  %add = or i32 %shl, %conv2
  %shl4 = shl i32 %add, 8
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv6 = zext i8 %call5 to i32
  %add7 = or i32 %shl4, %conv6
  %cmp60 = icmp eq i32 %add7, 0
  br i1 %cmp60, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.preheader
  %0 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %call12 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv13 = zext i8 %call12 to i64
  %shl15 = shl i64 %conv13, 8
  %call16 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv18 = zext i8 %call16 to i64
  %add19 = or i64 %shl15, %conv18
  %shl21 = shl i64 %add19, 8
  %call22 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv24 = zext i8 %call22 to i64
  %add25 = or i64 %shl21, %conv24
  %shl27 = shl i64 %add25, 8
  %call28 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv30 = zext i8 %call28 to i64
  %add31 = or i64 %shl27, %conv30
  %shl33 = shl i64 %add31, 8
  %call34 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv36 = zext i8 %call34 to i64
  %add37 = or i64 %shl33, %conv36
  %shl39 = shl i64 %add37, 8
  %call40 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv42 = zext i8 %call40 to i64
  %add43 = or i64 %shl39, %conv42
  %shl45 = shl i64 %add43, 8
  %call46 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
  %conv48 = zext i8 %call46 to i64
  %add49 = or i64 %shl45, %conv48
  %shl51 = shl i64 %add49, 8
  %call52 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0)) nounwind
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
  %exitcond1 = icmp eq i8 %inc, 19
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
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv44) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv38) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv32) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv26) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv20) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv14) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv) nounwind
  %inc = add i32 %0, 1
  %exitcond1 = icmp eq i32 %inc, 18816
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare i64 @readModule1(i32)

define void @systemTOP() nounwind {
entry:
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i, %entry
  %0 = phi i8 [ 0, %entry ], [ %inc.i, %for.body.i ]
  tail call void @readFromSystemPipe(i8 zeroext %0) nounwind
  %inc.i = add i8 %0, 1
  %exitcond1 = icmp eq i8 %inc.i, 19
  br i1 %exitcond1, label %fill_input.exit, label %for.body.i

fill_input.exit:                                  ; preds = %for.body.i
  %call = tail call i32 (...)* @timer() nounwind
  %call.i = tail call zeroext i8 @zeropad_same(i16 zeroext 224, i16 zeroext 224, i16 zeroext 3, i16 zeroext 226, i16 zeroext 226, i16 zeroext 3, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i) nounwind
  tail call void @convolutionSmall(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 0, i8 zeroext 0, i16 zeroext 226, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i64 = tail call zeroext i8 @zeropad_same(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 226, i16 zeroext 226, i16 zeroext 64, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i64) nounwind
  tail call void @convolution3D_3(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 1, i8 zeroext 2, i16 zeroext 226, i16 zeroext 0, i8 zeroext 1) nounwind
  br label %while.body.i

while.body.i:                                     ; preds = %while.body.i, %fill_input.exit
  %1 = phi i32 [ 0, %fill_input.exit ], [ %add79.i, %while.body.i ]
  %row18.1.i = phi i16 [ 0, %fill_input.exit ], [ %inc76.row18.1.i, %while.body.i ]
  %col.1.i = phi i16 [ 0, %fill_input.exit ], [ %col.2.i, %while.body.i ]
  %chl.0.i = phi i16 [ 0, %fill_input.exit ], [ %chl.1.i, %while.body.i ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv31.i = zext i16 %chl.0.i to i32
  %conv35.i = zext i16 %col.1.i to i32
  %conv39.i = zext i16 %row18.1.i to i32
  %mul40.i = mul nsw i32 %conv39.i, 224
  %add41.i = add nsw i32 %conv35.i, %mul40.i
  %shl.i = shl i32 %add41.i, 4
  %add43.i = add nsw i32 %shl.i, %conv31.i
  %add50.i = add i32 %add43.i, 8
  %add54.i = add i32 %add43.i, 1792
  %add57.i = add i32 %add43.i, 1800
  %call.i65 = tail call zeroext i8 @maxPool4(i32 %1, i32 %add43.i, i32 %add50.i, i32 %add54.i, i32 %add57.i, i8 zeroext 2, i8 zeroext 0) nounwind
  %inc.i66 = add i16 %chl.0.i, 1
  %cmp.i = icmp eq i16 %inc.i66, 8
  %inc67.i = zext i1 %cmp.i to i16
  %inc67.col.1.i = add i16 %inc67.i, %col.1.i
  %chl.1.i = select i1 %cmp.i, i16 0, i16 %inc.i66
  %cmp72.i = icmp eq i16 %inc67.col.1.i, 112
  %inc76.i = zext i1 %cmp72.i to i16
  %inc76.row18.1.i = add i16 %inc76.i, %row18.1.i
  %col.2.i = select i1 %cmp72.i, i16 0, i16 %inc67.col.1.i
  %add79.i = add i32 %1, 1
  %cmp84.i = icmp eq i16 %inc76.row18.1.i, 112
  br i1 %cmp84.i, label %maxPool3D.exit, label %while.body.i

maxPool3D.exit:                                   ; preds = %while.body.i
  %inc76.row18.1.i.lcssa = phi i16 [ %inc76.row18.1.i, %while.body.i ]
  %conv89.i = trunc i16 %inc76.row18.1.i.lcssa to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv89.i) nounwind
  %call.i67 = tail call zeroext i8 @zeropad_same(i16 zeroext 112, i16 zeroext 112, i16 zeroext 64, i16 zeroext 114, i16 zeroext 114, i16 zeroext 64, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i67) nounwind
  tail call void @convolution3D_3(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 2, i8 zeroext 0, i16 zeroext 114, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i68 = tail call zeroext i8 @zeropad_same(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 114, i16 zeroext 114, i16 zeroext 128, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i68) nounwind
  tail call void @convolution3D_3(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 3, i8 zeroext 3, i16 zeroext 114, i16 zeroext 0, i8 zeroext 1) nounwind
  br label %while.body.i94

while.body.i94:                                   ; preds = %while.body.i94, %maxPool3D.exit
  %2 = phi i32 [ 0, %maxPool3D.exit ], [ %add79.i92, %while.body.i94 ]
  %row18.1.i69 = phi i16 [ 0, %maxPool3D.exit ], [ %inc76.row18.1.i90, %while.body.i94 ]
  %col.1.i70 = phi i16 [ 0, %maxPool3D.exit ], [ %col.2.i91, %while.body.i94 ]
  %chl.0.i71 = phi i16 [ 0, %maxPool3D.exit ], [ %chl.1.i87, %while.body.i94 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv31.i72 = zext i16 %chl.0.i71 to i32
  %conv35.i73 = zext i16 %col.1.i70 to i32
  %conv39.i74 = zext i16 %row18.1.i69 to i32
  %mul40.i75 = mul nsw i32 %conv39.i74, 112
  %add41.i76 = add nsw i32 %conv35.i73, %mul40.i75
  %shl.i77 = shl i32 %add41.i76, 5
  %add43.i78 = add nsw i32 %shl.i77, %conv31.i72
  %add50.i79 = add i32 %add43.i78, 16
  %add54.i80 = add i32 %add43.i78, 1792
  %add57.i81 = add i32 %add43.i78, 1808
  %call.i82 = tail call zeroext i8 @maxPool4(i32 %2, i32 %add43.i78, i32 %add50.i79, i32 %add54.i80, i32 %add57.i81, i8 zeroext 3, i8 zeroext 0) nounwind
  %inc.i83 = add i16 %chl.0.i71, 1
  %cmp.i84 = icmp eq i16 %inc.i83, 16
  %inc67.i85 = zext i1 %cmp.i84 to i16
  %inc67.col.1.i86 = add i16 %inc67.i85, %col.1.i70
  %chl.1.i87 = select i1 %cmp.i84, i16 0, i16 %inc.i83
  %cmp72.i88 = icmp eq i16 %inc67.col.1.i86, 56
  %inc76.i89 = zext i1 %cmp72.i88 to i16
  %inc76.row18.1.i90 = add i16 %inc76.i89, %row18.1.i69
  %col.2.i91 = select i1 %cmp72.i88, i16 0, i16 %inc67.col.1.i86
  %add79.i92 = add i32 %2, 1
  %cmp84.i93 = icmp eq i16 %inc76.row18.1.i90, 56
  br i1 %cmp84.i93, label %maxPool3D.exit96, label %while.body.i94

maxPool3D.exit96:                                 ; preds = %while.body.i94
  %inc76.row18.1.i90.lcssa = phi i16 [ %inc76.row18.1.i90, %while.body.i94 ]
  %conv = sext i32 %call to i64
  %conv89.i95 = trunc i16 %inc76.row18.1.i90.lcssa to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv89.i95) nounwind
  %call.i97 = tail call zeroext i8 @zeropad_same(i16 zeroext 56, i16 zeroext 56, i16 zeroext 112, i16 zeroext 58, i16 zeroext 58, i16 zeroext 112, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i97) nounwind
  tail call void @convolution3D_3(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 4, i8 zeroext 0, i16 zeroext 58, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i98 = tail call zeroext i8 @zeropad_same(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 58, i16 zeroext 58, i16 zeroext 256, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i98) nounwind
  tail call void @convolution3D_3(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 5, i8 zeroext 4, i16 zeroext 58, i16 zeroext 0, i8 zeroext 1) nounwind
  br label %while.body.i124

while.body.i124:                                  ; preds = %while.body.i124, %maxPool3D.exit96
  %3 = phi i32 [ 0, %maxPool3D.exit96 ], [ %add79.i122, %while.body.i124 ]
  %row18.1.i99 = phi i16 [ 0, %maxPool3D.exit96 ], [ %inc76.row18.1.i120, %while.body.i124 ]
  %col.1.i100 = phi i16 [ 0, %maxPool3D.exit96 ], [ %col.2.i121, %while.body.i124 ]
  %chl.0.i101 = phi i16 [ 0, %maxPool3D.exit96 ], [ %chl.1.i117, %while.body.i124 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv31.i102 = zext i16 %chl.0.i101 to i32
  %conv35.i103 = zext i16 %col.1.i100 to i32
  %conv39.i104 = zext i16 %row18.1.i99 to i32
  %mul40.i105 = mul nsw i32 %conv39.i104, 56
  %add41.i106 = add nsw i32 %conv35.i103, %mul40.i105
  %shl.i107 = shl i32 %add41.i106, 6
  %add43.i108 = add nsw i32 %shl.i107, %conv31.i102
  %add50.i109 = add i32 %add43.i108, 32
  %add54.i110 = add i32 %add43.i108, 1792
  %add57.i111 = add i32 %add43.i108, 1824
  %call.i112 = tail call zeroext i8 @maxPool4(i32 %3, i32 %add43.i108, i32 %add50.i109, i32 %add54.i110, i32 %add57.i111, i8 zeroext 4, i8 zeroext 0) nounwind
  %inc.i113 = add i16 %chl.0.i101, 1
  %cmp.i114 = icmp eq i16 %inc.i113, 32
  %inc67.i115 = zext i1 %cmp.i114 to i16
  %inc67.col.1.i116 = add i16 %inc67.i115, %col.1.i100
  %chl.1.i117 = select i1 %cmp.i114, i16 0, i16 %inc.i113
  %cmp72.i118 = icmp eq i16 %inc67.col.1.i116, 28
  %inc76.i119 = zext i1 %cmp72.i118 to i16
  %inc76.row18.1.i120 = add i16 %inc76.i119, %row18.1.i99
  %col.2.i121 = select i1 %cmp72.i118, i16 0, i16 %inc67.col.1.i116
  %add79.i122 = add i32 %3, 1
  %cmp84.i123 = icmp eq i16 %inc76.row18.1.i120, 28
  br i1 %cmp84.i123, label %maxPool3D.exit126, label %while.body.i124

maxPool3D.exit126:                                ; preds = %while.body.i124
  %inc76.row18.1.i120.lcssa = phi i16 [ %inc76.row18.1.i120, %while.body.i124 ]
  %conv89.i125 = trunc i16 %inc76.row18.1.i120.lcssa to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %conv89.i125) nounwind
  %call.i127 = tail call zeroext i8 @zeropad_same(i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 30, i16 zeroext 30, i16 zeroext 512, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i127) nounwind
  tail call void @convolution3D_3(i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 6, i8 zeroext 0, i16 zeroext 30, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i128 = tail call zeroext i8 @zeropad_same(i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 30, i16 zeroext 30, i16 zeroext 512, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i128) nounwind
  tail call void @convolution3D_3(i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 7, i8 zeroext 0, i16 zeroext 30, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i129 = tail call zeroext i8 @ct_core(i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 2, i16 zeroext 2, i16 zeroext 57, i16 zeroext 57, i16 zeroext 512, i16 zeroext 2, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i129) nounwind
  tail call void @convolution3D_3(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 512, i16 zeroext 2, i16 zeroext 2, i8 zeroext 1, i8 zeroext 8, i8 zeroext 0, i16 zeroext 57, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i130 = tail call zeroext i8 @concat_core(i16 zeroext 32, i16 zeroext 32, i32 1605632, i8 zeroext 4, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i130) nounwind
  %call.i131 = tail call zeroext i8 @zeropad_same(i16 zeroext 56, i16 zeroext 56, i16 zeroext 512, i16 zeroext 58, i16 zeroext 58, i16 zeroext 512, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i131) nounwind
  tail call void @convolution3D_3(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 9, i8 zeroext 1, i16 zeroext 58, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i132 = tail call zeroext i8 @zeropad_same(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 58, i16 zeroext 58, i16 zeroext 256, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i132) nounwind
  tail call void @convolution3D_3(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 10, i8 zeroext 1, i16 zeroext 58, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i133 = tail call zeroext i8 @ct_core(i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 2, i16 zeroext 2, i16 zeroext 113, i16 zeroext 113, i16 zeroext 256, i16 zeroext 2, i16 zeroext 0, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i133) nounwind
  tail call void @convolution3D_3(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 256, i16 zeroext 2, i16 zeroext 2, i8 zeroext 0, i8 zeroext 11, i8 zeroext 1, i16 zeroext 113, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i134 = tail call zeroext i8 @concat_core(i16 zeroext 16, i16 zeroext 16, i32 3211264, i8 zeroext 3, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i134) nounwind
  %call.i135 = tail call zeroext i8 @zeropad_same(i16 zeroext 112, i16 zeroext 112, i16 zeroext 256, i16 zeroext 114, i16 zeroext 114, i16 zeroext 256, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i135) nounwind
  tail call void @convolution3D_3(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 12, i8 zeroext 0, i16 zeroext 114, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i136 = tail call zeroext i8 @zeropad_same(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 114, i16 zeroext 114, i16 zeroext 128, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i136) nounwind
  tail call void @convolution3D_3(i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 1, i8 zeroext 13, i8 zeroext 0, i16 zeroext 114, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i137 = tail call zeroext i8 @ct_core(i16 zeroext 112, i16 zeroext 112, i16 zeroext 256, i16 zeroext 2, i16 zeroext 2, i16 zeroext 225, i16 zeroext 225, i16 zeroext 256, i16 zeroext 2, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i137) nounwind
  tail call void @convolution3D_3(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 128, i16 zeroext 2, i16 zeroext 2, i8 zeroext 1, i8 zeroext 14, i8 zeroext 0, i16 zeroext 225, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i138 = tail call zeroext i8 @concat_core(i16 zeroext 8, i16 zeroext 8, i32 6422528, i8 zeroext 2, i8 zeroext 0, i8 zeroext 1) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i138) nounwind
  %call.i139 = tail call zeroext i8 @zeropad_same(i16 zeroext 224, i16 zeroext 224, i16 zeroext 128, i16 zeroext 226, i16 zeroext 226, i16 zeroext 128, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i139) nounwind
  tail call void @convolution3D_3(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 15, i8 zeroext 1, i16 zeroext 226, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i140 = tail call zeroext i8 @zeropad_same(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 226, i16 zeroext 226, i16 zeroext 64, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i140) nounwind
  tail call void @convolution3D_3(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 16, i8 zeroext 1, i16 zeroext 226, i16 zeroext 0, i8 zeroext 1) nounwind
  %call.i141 = tail call zeroext i8 @zeropad_same(i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 226, i16 zeroext 226, i16 zeroext 64, i8 zeroext 1, i8 zeroext 0) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext %call.i141) nounwind
  tail call void @convolutionSmall(i16 zeroext 224, i16 zeroext 224, i16 zeroext 3, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i8 zeroext 0, i8 zeroext 17, i8 zeroext 1, i16 zeroext 226, i16 zeroext 0, i8 zeroext 2) nounwind
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

declare void @convolutionSmall(i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext, i8 zeroext, i16 zeroext, i16 zeroext, i8 zeroext)

declare void @convolution3D_3(i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i16 zeroext, i8 zeroext, i8 zeroext, i8 zeroext, i16 zeroext, i16 zeroext, i8 zeroext)
