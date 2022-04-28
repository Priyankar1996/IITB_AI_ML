; ModuleID = 'prog.opt.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.__SizedTensor_16K = type { [16384 x i64] }
%struct.__TensorDescriptor = type { i32, i8, i32, [64 x i32] }

@des_inp = common global %struct.__TensorDescriptor zeroinitializer, align 4
@.str = private constant [19 x i8] c"zeropad_input_pipe\00"
@pad = common global i8 0, align 1
@des_out = common global %struct.__TensorDescriptor zeroinitializer, align 4
@T = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@R = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@.str1 = private constant [20 x i8] c"zeropad_output_pipe\00"
@.str2 = private constant [16 x i8] c"Block0_starting\00"
@.str3 = private constant [16 x i8] c"Block0_complete\00"

define zeroext i16 @testConfigure() nounwind {
entry:
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 0), align 4
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  store i8 %call, i8* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 1), align 4
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv = zext i8 %call1 to i32
  store i32 %conv, i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 2), align 4
  %cmp86 = icmp eq i8 %call1, 0
  %call487 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  br i1 %cmp86, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.preheader
  %indvar96 = phi i64 [ %tmp98, %for.body ], [ 0, %for.body.preheader ]
  %call489 = phi i8 [ %call4, %for.body ], [ %call487, %for.body.preheader ]
  %tmp = add i64 %indvar96, 1
  %inc = trunc i64 %tmp to i32
  %arrayidx = getelementptr %struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 %indvar96
  %conv5 = zext i8 %call489 to i32
  store i32 %conv5, i32* %arrayidx, align 4
  %tmp98 = add i64 %indvar96, 1
  %tmp2 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 2), align 4
  %cmp = icmp ult i32 %inc, %tmp2
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  %call4.lcssa1 = phi i8 [ %call4, %for.body ]
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %call4.lcssa = phi i8 [ %call487, %entry ], [ %call4.lcssa1, %for.end.loopexit ]
  store i8 %call4.lcssa, i8* @pad, align 1
  %call9 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv10 = zext i8 %call9 to i32
  store i32 %conv10, i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 0), align 4
  %call11 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv12 = zext i8 %call11 to i32
  store i32 %conv12, i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 1), align 4
  %call13 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv14 = zext i8 %call13 to i32
  store i32 %conv14, i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 2), align 4
  %tmp16 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 0), align 4
  %tmp17 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 1), align 4
  %tmp18 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 2), align 4
  %mul = mul i32 %tmp17, %tmp16
  %mul19 = mul i32 %mul, %tmp18
  %conv20 = zext i32 %mul19 to i64
  %shr82.mask = and i64 %conv20, 4294967292
  %cmp2583 = icmp eq i64 %shr82.mask, 0
  br i1 %cmp2583, label %for.end78, label %bb.nph

bb.nph:                                           ; preds = %for.end
  %tmp4 = mul i32 %tmp17, %tmp16
  %tmp5 = mul i32 %tmp4, %tmp18
  %tmp6 = zext i32 %tmp5 to i64
  %tmp7 = lshr i64 %tmp6, 2
  %tmp8 = icmp ugt i64 %tmp7, 1
  %umax9 = select i1 %tmp8, i64 %tmp7, i64 1
  br label %for.body27

for.body27:                                       ; preds = %for.body27, %bb.nph
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body27 ]
  %arrayidx74 = getelementptr %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %indvar
  %call29 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv30 = zext i8 %call29 to i64
  %shl = shl i64 %conv30, 8
  %call32 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv34 = zext i8 %call32 to i64
  %add = or i64 %shl, %conv34
  %shl36 = shl i64 %add, 8
  %call37 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv39 = zext i8 %call37 to i64
  %add40 = or i64 %shl36, %conv39
  %shl42 = shl i64 %add40, 8
  %call43 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv45 = zext i8 %call43 to i64
  %add46 = or i64 %shl42, %conv45
  %shl48 = shl i64 %add46, 8
  %call49 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv51 = zext i8 %call49 to i64
  %add52 = or i64 %shl48, %conv51
  %shl54 = shl i64 %add52, 8
  %call55 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv57 = zext i8 %call55 to i64
  %add58 = or i64 %shl54, %conv57
  %shl60 = shl i64 %add58, 8
  %call61 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv63 = zext i8 %call61 to i64
  %add64 = or i64 %shl60, %conv63
  %shl66 = shl i64 %add64, 8
  %call67 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv69 = zext i8 %call67 to i64
  %add70 = or i64 %shl66, %conv69
  store i64 %add70, i64* %arrayidx74, align 8
  %indvar.next = add i64 %indvar, 1
  %exitcond10 = icmp eq i64 %indvar.next, %umax9
  br i1 %exitcond10, label %for.end78.loopexit, label %for.body27

for.end78.loopexit:                               ; preds = %for.body27
  br label %for.end78

for.end78:                                        ; preds = %for.end78.loopexit, %for.end
  %conv80 = trunc i32 %mul19 to i16
  ret i16 %conv80
}

declare zeroext i8 @read_uint8(i8*)

define void @sendOutput() nounwind {
entry:
  %tmp = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 0), align 4
  %tmp1 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 1), align 4
  %tmp2 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 2), align 4
  %mul = mul i32 %tmp1, %tmp
  %mul3 = mul i32 %mul, %tmp2
  %conv = zext i32 %mul3 to i64
  %shr76.mask = and i64 %conv, 4294967292
  %cmp77 = icmp eq i64 %shr76.mask, 0
  br i1 %cmp77, label %for.end, label %bb.nph

bb.nph:                                           ; preds = %entry
  %tmp3 = mul i32 %tmp1, %tmp
  %tmp4 = mul i32 %tmp3, %tmp2
  %tmp5 = zext i32 %tmp4 to i64
  %tmp6 = lshr i64 %tmp5, 2
  %tmp7 = icmp ugt i64 %tmp6, 1
  %umax8 = select i1 %tmp7, i64 %tmp6, i64 1
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %arrayidx = getelementptr %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %indvar
  %tmp11 = load i64* %arrayidx, align 8
  %conv14 = trunc i64 %tmp11 to i8
  %shr17 = lshr i64 %tmp11, 8
  %conv20 = trunc i64 %shr17 to i8
  %shr23 = lshr i64 %tmp11, 16
  %conv26 = trunc i64 %shr23 to i8
  %shr29 = lshr i64 %tmp11, 24
  %conv32 = trunc i64 %shr29 to i8
  %shr35 = lshr i64 %tmp11, 32
  %conv38 = trunc i64 %shr35 to i8
  %shr41 = lshr i64 %tmp11, 40
  %conv44 = trunc i64 %shr41 to i8
  %shr47 = lshr i64 %tmp11, 48
  %conv50 = trunc i64 %shr47 to i8
  %shr53 = lshr i64 %tmp11, 56
  %conv56 = trunc i64 %shr53 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv56) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv50) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv44) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv38) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv32) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv26) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv20) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv14) nounwind
  %indvar.next = add i64 %indvar, 1
  %exitcond9 = icmp eq i64 %indvar.next, %umax8
  br i1 %exitcond9, label %for.end.loopexit, label %for.body

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

declare void @write_uint8(i8*, i8 zeroext)

define void @zeropad3D_A() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str2, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %tmp = load i8* @pad, align 1
  %conv = zext i8 %tmp to i32
  %tmp2 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 2), align 4
  %tmp4 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 1), align 4
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 2), align 4
  %tmp10 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_out, i64 0, i32 3, i64 1), align 4
  %mul19 = mul nsw i32 %tmp10, %tmp8
  %tmp22120 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 0), align 4
  %mul24121 = shl i32 %conv, 1
  %add122 = sub i32 0, %mul24121
  %cmp123 = icmp eq i32 %tmp22120, %add122
  br i1 %cmp123, label %while.end, label %bb.nph

bb.nph:                                           ; preds = %entry
  %sub = add nsw i32 %conv, -1
  br label %while.body

while.body:                                       ; preds = %if.end116, %bb.nph
  %tmp31 = phi i32 [ %tmp22120, %bb.nph ], [ %tmp22, %if.end116 ]
  %i.1126 = phi i32 [ 0, %bb.nph ], [ %i.0, %if.end116 ]
  %k.0125 = phi i32 [ 0, %bb.nph ], [ %k.1, %if.end116 ]
  %j.1124 = phi i32 [ 0, %bb.nph ], [ %j.0, %if.end116 ]
  %cmp28 = icmp sgt i32 %i.1126, %sub
  br i1 %cmp28, label %lor.lhs.false, label %if.then

lor.lhs.false:                                    ; preds = %while.body
  %sub34 = add i32 %sub, %tmp31
  %cmp35.not = icmp ule i32 %i.1126, %sub34
  %cmp41 = icmp sgt i32 %j.1124, %sub
  %or.cond = and i1 %cmp35.not, %cmp41
  br i1 %or.cond, label %lor.lhs.false43, label %if.then

lor.lhs.false43:                                  ; preds = %lor.lhs.false
  %tmp45 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 1), align 4
  %sub48 = add i32 %sub, %tmp45
  %cmp49 = icmp ugt i32 %j.1124, %sub48
  br i1 %cmp49, label %if.then, label %if.else

if.then:                                          ; preds = %lor.lhs.false43, %lor.lhs.false, %while.body
  %mul55 = mul nsw i32 %j.1124, %tmp8
  %mul59 = mul nsw i32 %i.1126, %mul19
  %add56 = add nsw i32 %k.0125, %mul55
  %add60 = add nsw i32 %add56, %mul59
  %shr = ashr i32 %add60, 2
  %idxprom = sext i32 %shr to i64
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom
  store i64 0, i64* %arrayidx, align 8
  br label %if.end

if.else:                                          ; preds = %lor.lhs.false43
  %sub67 = sub nsw i32 %j.1124, %conv
  %sub73 = sub nsw i32 %i.1126, %conv
  %mul74 = mul nsw i32 %tmp4, %sub73
  %tmp118 = add i32 %mul74, %sub67
  %tmp119 = mul i32 %tmp118, %tmp2
  %add75 = add nsw i32 %tmp119, %k.0125
  %mul81 = mul nsw i32 %j.1124, %tmp8
  %mul85 = mul nsw i32 %i.1126, %mul19
  %add82 = add nsw i32 %k.0125, %mul81
  %add86 = add nsw i32 %add82, %mul85
  %shr88 = ashr i32 %add75, 2
  %idxprom89 = sext i32 %shr88 to i64
  %arrayidx90 = getelementptr inbounds %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %idxprom89
  %tmp91 = load i64* %arrayidx90, align 8
  %shr93 = ashr i32 %add86, 2
  %idxprom94 = sext i32 %shr93 to i64
  %arrayidx95 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom94
  store i64 %tmp91, i64* %arrayidx95, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %add97 = add nsw i32 %k.0125, 4
  %cmp100 = icmp slt i32 %add97, %tmp2
  br i1 %cmp100, label %if.end116, label %if.then102

if.then102:                                       ; preds = %if.end
  %inc = add nsw i32 %j.1124, 1
  %tmp105 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 1), align 4
  %add108 = add i32 %tmp105, %mul24121
  %cmp109 = icmp eq i32 %inc, %add108
  %inc114 = zext i1 %cmp109 to i32
  %inc114.i.1 = add i32 %inc114, %i.1126
  br i1 %cmp109, label %if.then111, label %if.end116

if.then111:                                       ; preds = %if.then102
  br label %if.end116

if.end116:                                        ; preds = %if.then111, %if.then102, %if.end
  %j.0 = phi i32 [ 0, %if.then111 ], [ %inc, %if.then102 ], [ %j.1124, %if.end ]
  %k.1 = phi i32 [ 0, %if.then111 ], [ 0, %if.then102 ], [ %add97, %if.end ]
  %i.0 = phi i32 [ %inc114.i.1, %if.then111 ], [ %inc114.i.1, %if.then102 ], [ %i.1126, %if.end ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %tmp22 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @des_inp, i64 0, i32 3, i64 0), align 4
  %add = add i32 %tmp22, %mul24121
  %cmp = icmp ult i32 %i.0, %add
  br i1 %cmp, label %while.body, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.end116
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %entry
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call) nounwind
  ret void
}

declare void @__aa_barrier__(...)

declare void @__loop_pipelining_on__(i32, i32, i32)

define void @zeropad3D() nounwind {
entry:
  %call = tail call zeroext i16 @testConfigure()
  tail call void (...)* @__aa_barrier__() nounwind
  %conv = trunc i16 %call to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str2, i64 0, i64 0), i8 zeroext %conv) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @sendOutput()
  ret void
}
