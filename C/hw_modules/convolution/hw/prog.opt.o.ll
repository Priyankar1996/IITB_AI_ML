; ModuleID = 'prog.opt.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-unknown-linux-gnu"

%struct.__SizedTensor_16K = type { [16384 x i64] }
%struct.__TensorDescriptor = type { i32, i32, i32, [64 x i32] }

@.str = private constant [16 x i8] c"conv_input_pipe\00"
@desc_T = common global %struct.__TensorDescriptor zeroinitializer, align 4
@stride = common global i8 0, align 1
@desc_K = common global %struct.__TensorDescriptor zeroinitializer, align 4
@T = common global %struct.__SizedTensor_16K zeroinitializer, align 4
@K = common global %struct.__SizedTensor_16K zeroinitializer, align 4
@.str1 = private constant [17 x i8] c"conv_output_pipe\00"
@desc_R = common global %struct.__TensorDescriptor zeroinitializer, align 4
@R = common global %struct.__SizedTensor_16K zeroinitializer, align 4
@.str2 = private constant [15 x i8] c"core1_req_pipe\00"
@.str3 = private constant [15 x i8] c"core1_ack_pipe\00"
@.str4 = private constant [15 x i8] c"core2_req_pipe\00"
@.str5 = private constant [15 x i8] c"core2_ack_pipe\00"
@.str6 = private constant [15 x i8] c"core3_req_pipe\00"
@.str7 = private constant [15 x i8] c"core3_ack_pipe\00"
@.str8 = private constant [15 x i8] c"core4_req_pipe\00"
@.str9 = private constant [15 x i8] c"core4_ack_pipe\00"
@.str10 = private constant [15 x i8] c"core5_req_pipe\00"
@.str11 = private constant [15 x i8] c"core5_ack_pipe\00"
@.str12 = private constant [18 x i8] c"elapsed_time_pipe\00"

define void @getInput() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv = zext i8 %call to i32
  store i32 %conv, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 1), align 4
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv2 = zext i8 %call1 to i32
  store i32 %conv2, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 2), align 4
  %cmp173 = icmp eq i8 %call1, 0
  %call5174 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  br i1 %cmp173, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.preheader
  %call5176 = phi i8 [ %call5, %for.body ], [ %call5174, %for.body.preheader ]
  %i.0175 = phi i32 [ %0, %for.body ], [ 0, %for.body.preheader ]
  %tmp2 = add i32 %i.0175, 1
  %arrayidx = getelementptr %struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 %i.0175
  %conv6 = zext i8 %call5176 to i32
  store i32 %conv6, i32* %arrayidx, align 4
  %0 = add nsw i32 %i.0175, 1
  %tmp3 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 2), align 4
  %cmp = icmp ult i32 %tmp2, %tmp3
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  %call5.lcssa1 = phi i8 [ %call5, %for.body ]
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %call5.lcssa = phi i8 [ %call5174, %entry ], [ %call5.lcssa1, %for.end.loopexit ]
  store i8 %call5.lcssa, i8* @stride, align 1
  %call10 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv11 = zext i8 %call10 to i32
  store i32 %conv11, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 1), align 4
  %call12 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv13 = zext i8 %call12 to i32
  store i32 %conv13, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 2), align 4
  %cmp17169 = icmp eq i8 %call12, 0
  br i1 %cmp17169, label %bb.nph167, label %for.body19.preheader

for.body19.preheader:                             ; preds = %for.end
  br label %for.body19

for.body19:                                       ; preds = %for.body19, %for.body19.preheader
  %i.1170 = phi i32 [ %1, %for.body19 ], [ 0, %for.body19.preheader ]
  %tmp4 = add i32 %i.1170, 1
  %arrayidx23 = getelementptr %struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 %i.1170
  %call20 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv21 = zext i8 %call20 to i32
  store i32 %conv21, i32* %arrayidx23, align 4
  %1 = add nsw i32 %i.1170, 1
  %tmp16 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 2), align 4
  %cmp17 = icmp ult i32 %tmp4, %tmp16
  br i1 %cmp17, label %for.body19, label %bb.nph167.loopexit

bb.nph167.loopexit:                               ; preds = %for.body19
  br label %bb.nph167

bb.nph167:                                        ; preds = %bb.nph167.loopexit, %for.end
  %tmp34 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  %tmp35 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp37 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %tmp39 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %tmp30 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp29 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %mul = mul i32 %tmp30, %tmp29
  %tmp31 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %mul32 = mul i32 %mul, %tmp31
  %shr = lshr i32 %mul32, 2
  %add = add i32 %shr, 1
  br label %for.body46

for.body46:                                       ; preds = %for.body46, %bb.nph167
  %i.2166 = phi i32 [ 0, %bb.nph167 ], [ %inc96, %for.body46 ]
  %arrayidx93 = getelementptr %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %i.2166
  %call48 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv49 = zext i8 %call48 to i64
  %shl = shl i64 %conv49, 8
  %call51 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv53 = zext i8 %call51 to i64
  %add54 = or i64 %shl, %conv53
  %shl56 = shl i64 %add54, 8
  %call57 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv59 = zext i8 %call57 to i64
  %add60 = or i64 %shl56, %conv59
  %shl62 = shl i64 %add60, 8
  %call63 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv65 = zext i8 %call63 to i64
  %add66 = or i64 %shl62, %conv65
  %shl68 = shl i64 %add66, 8
  %call69 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv71 = zext i8 %call69 to i64
  %add72 = or i64 %shl68, %conv71
  %shl74 = shl i64 %add72, 8
  %call75 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv77 = zext i8 %call75 to i64
  %add78 = or i64 %shl74, %conv77
  %shl80 = shl i64 %add78, 8
  %call81 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv83 = zext i8 %call81 to i64
  %add84 = or i64 %shl80, %conv83
  %shl86 = shl i64 %add84, 8
  %call87 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv89 = zext i8 %call87 to i64
  %add90 = or i64 %shl86, %conv89
  store i64 %add90, i64* %arrayidx93, align 4
  %inc96 = add nsw i32 %i.2166, 1
  %exitcond = icmp eq i32 %inc96, %add
  br i1 %exitcond, label %bb.nph, label %for.body46

bb.nph:                                           ; preds = %for.body46
  %tmp = mul i32 %tmp35, %tmp34
  %tmp178 = mul i32 %tmp, %tmp37
  %tmp179 = mul i32 %tmp178, %tmp39
  %tmp180 = lshr i32 %tmp179, 2
  %tmp181 = add i32 %tmp180, 1
  br label %for.body105

for.body105:                                      ; preds = %for.body105, %bb.nph
  %i.3162 = phi i32 [ 0, %bb.nph ], [ %inc157, %for.body105 ]
  %arrayidx154 = getelementptr %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %i.3162
  %call108 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv109 = zext i8 %call108 to i64
  %shl111 = shl i64 %conv109, 8
  %call112 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv114 = zext i8 %call112 to i64
  %add115 = or i64 %shl111, %conv114
  %shl117 = shl i64 %add115, 8
  %call118 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv120 = zext i8 %call118 to i64
  %add121 = or i64 %shl117, %conv120
  %shl123 = shl i64 %add121, 8
  %call124 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv126 = zext i8 %call124 to i64
  %add127 = or i64 %shl123, %conv126
  %shl129 = shl i64 %add127, 8
  %call130 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv132 = zext i8 %call130 to i64
  %add133 = or i64 %shl129, %conv132
  %shl135 = shl i64 %add133, 8
  %call136 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv138 = zext i8 %call136 to i64
  %add139 = or i64 %shl135, %conv138
  %shl141 = shl i64 %add139, 8
  %call142 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv144 = zext i8 %call142 to i64
  %add145 = or i64 %shl141, %conv144
  %shl147 = shl i64 %add145, 8
  %call148 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0)) nounwind
  %conv150 = zext i8 %call148 to i64
  %add151 = or i64 %shl147, %conv150
  store i64 %add151, i64* %arrayidx154, align 4
  %inc157 = add nsw i32 %i.3162, 1
  %exitcond5 = icmp eq i32 %inc157, %tmp181
  br i1 %exitcond5, label %for.end158, label %for.body105

for.end158:                                       ; preds = %for.body105
  ret void
}

declare zeroext i8 @read_uint8(i8*)

define void @sendOutput() nounwind {
bb.nph:
  %tmp = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  %conv = trunc i32 %tmp to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv) nounwind
  %tmp1 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %conv2 = trunc i32 %tmp1 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv2) nounwind
  %tmp3 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %conv4 = trunc i32 %tmp3 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv4) nounwind
  %tmp7 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp6 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  %mul = mul i32 %tmp7, %tmp6
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %mul9 = mul i32 %mul, %tmp8
  %shr = lshr i32 %mul9, 2
  %add = add i32 %shr, 1
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %i.083 = phi i32 [ 0, %bb.nph ], [ %inc, %for.body ]
  %arrayidx = getelementptr %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %i.083
  %tmp16 = load i64* %arrayidx, align 4
  %conv19 = trunc i64 %tmp16 to i8
  %shr22 = lshr i64 %tmp16, 8
  %conv25 = trunc i64 %shr22 to i8
  %shr28 = lshr i64 %tmp16, 16
  %conv31 = trunc i64 %shr28 to i8
  %shr34 = lshr i64 %tmp16, 24
  %conv37 = trunc i64 %shr34 to i8
  %shr40 = lshr i64 %tmp16, 32
  %conv43 = trunc i64 %shr40 to i8
  %shr46 = lshr i64 %tmp16, 40
  %conv49 = trunc i64 %shr46 to i8
  %shr52 = lshr i64 %tmp16, 48
  %conv55 = trunc i64 %shr52 to i8
  %shr58 = lshr i64 %tmp16, 56
  %conv61 = trunc i64 %shr58 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv61) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv55) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv49) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv43) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv37) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv31) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv25) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([17 x i8]* @.str1, i32 0, i32 0), i8 zeroext %conv19) nounwind
  %inc = add nsw i32 %i.083, 1
  %exitcond1 = icmp eq i32 %inc, %add
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare void @write_uint8(i8*, i8 zeroext)

define void @convCore1() nounwind {
entry:
  %call = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  %call2 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  %call3 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  %call4 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  %call5 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 0), align 4
  store i32 3, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 2), align 4
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 1), align 4
  %tmp = load i8* @stride, align 1
  %cmp = icmp eq i8 %tmp, 0
  br i1 %cmp, label %if.end53.thread, label %if.then

if.end53.thread:                                  ; preds = %entry
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.end53.if.end123_crit_edge

if.then:                                          ; preds = %entry
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %tmp9 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %sub = sub i32 %tmp8, %tmp9
  %conv12401 = and i32 %sub, 65535
  %conv14403 = zext i8 %tmp to i32
  %cmp15404 = icmp ult i32 %conv12401, %conv14403
  br i1 %cmp15404, label %if.end53.thread596, label %bb.nph407

if.end53.thread596:                               ; preds = %if.then
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.then63

bb.nph407:                                        ; preds = %if.then
  %conv20 = zext i8 %tmp to i16
  br label %while.body

while.body:                                       ; preds = %while.end, %bb.nph407
  %quotient.0406 = phi i16 [ 0, %bb.nph407 ], [ %add, %while.end ]
  %reduced_dividend.0.in405 = phi i32 [ %sub, %bb.nph407 ], [ %sub50, %while.end ]
  %conv23 = lshr i32 %reduced_dividend.0.in405, 1
  %shr385 = and i32 %conv23, 32767
  %cmp31397 = icmp ult i32 %conv14403, %shr385
  br i1 %cmp31397, label %if.then33.preheader, label %while.end

if.then33.preheader:                              ; preds = %while.body
  br label %if.then33

if.then33:                                        ; preds = %if.then33, %if.then33.preheader
  %curr_quotient.0399 = phi i16 [ %shl39, %if.then33 ], [ 1, %if.then33.preheader ]
  %shifted_divisor.0398 = phi i16 [ %shl, %if.then33 ], [ %conv20, %if.then33.preheader ]
  %shl = shl i16 %shifted_divisor.0398, 1
  %shl39 = shl i16 %curr_quotient.0399, 1
  %conv28 = zext i16 %shl to i32
  %cmp31 = icmp ult i32 %conv28, %shr385
  br i1 %cmp31, label %if.then33, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.then33
  %shl39.lcssa = phi i16 [ %shl39, %if.then33 ]
  %shl.lcssa = phi i16 [ %shl, %if.then33 ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %while.body
  %curr_quotient.0.lcssa = phi i16 [ 1, %while.body ], [ %shl39.lcssa, %while.end.loopexit ]
  %shifted_divisor.0.lcssa = phi i16 [ %conv20, %while.body ], [ %shl.lcssa, %while.end.loopexit ]
  %add = add i16 %curr_quotient.0.lcssa, %quotient.0406
  %conv47 = zext i16 %shifted_divisor.0.lcssa to i32
  %conv49 = and i32 %reduced_dividend.0.in405, 65535
  %sub50 = sub nsw i32 %conv49, %conv47
  %fold = sub i32 %reduced_dividend.0.in405, %conv47
  %conv12 = and i32 %fold, 65535
  %cmp15 = icmp ult i32 %conv12, %conv14403
  br i1 %cmp15, label %if.end53, label %while.body

if.end53:                                         ; preds = %while.end
  %add.lcssa = phi i16 [ %add, %while.end ]
  %conv55 = zext i16 %add.lcssa to i32
  %add56 = add nsw i32 %conv55, 1
  store i32 %add56, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br i1 %cmp, label %if.end53.if.end123_crit_edge, label %if.then63

if.end53.if.end123_crit_edge:                     ; preds = %if.end53, %if.end53.thread
  %tmp144.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp152.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  br label %if.end123

if.then63:                                        ; preds = %if.end53, %if.end53.thread596
  %tmp66 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp67 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %sub68 = sub i32 %tmp66, %tmp67
  %conv72416 = and i32 %sub68, 65535
  %conv74418 = zext i8 %tmp to i32
  %cmp75419 = icmp ult i32 %conv72416, %conv74418
  br i1 %cmp75419, label %if.end123, label %bb.nph422

bb.nph422:                                        ; preds = %if.then63
  %conv83 = zext i8 %tmp to i16
  br label %while.body77

while.body77:                                     ; preds = %while.end109, %bb.nph422
  %quotient58.0421 = phi i16 [ 0, %bb.nph422 ], [ %add114, %while.end109 ]
  %reduced_dividend65.0.in420 = phi i32 [ %sub68, %bb.nph422 ], [ %sub120, %while.end109 ]
  %conv87 = lshr i32 %reduced_dividend65.0.in420, 1
  %shr88384 = and i32 %conv87, 32767
  %cmp96410 = icmp ult i32 %conv74418, %shr88384
  br i1 %cmp96410, label %if.then98.preheader, label %while.end109

if.then98.preheader:                              ; preds = %while.body77
  br label %if.then98

if.then98:                                        ; preds = %if.then98, %if.then98.preheader
  %curr_quotient79.0412 = phi i16 [ %shl105, %if.then98 ], [ 1, %if.then98.preheader ]
  %shifted_divisor81.0411 = phi i16 [ %shl101, %if.then98 ], [ %conv83, %if.then98.preheader ]
  %shl101 = shl i16 %shifted_divisor81.0411, 1
  %shl105 = shl i16 %curr_quotient79.0412, 1
  %conv93 = zext i16 %shl101 to i32
  %cmp96 = icmp ult i32 %conv93, %shr88384
  br i1 %cmp96, label %if.then98, label %while.end109.loopexit

while.end109.loopexit:                            ; preds = %if.then98
  %shl105.lcssa = phi i16 [ %shl105, %if.then98 ]
  %shl101.lcssa = phi i16 [ %shl101, %if.then98 ]
  br label %while.end109

while.end109:                                     ; preds = %while.end109.loopexit, %while.body77
  %curr_quotient79.0.lcssa = phi i16 [ 1, %while.body77 ], [ %shl105.lcssa, %while.end109.loopexit ]
  %shifted_divisor81.0.lcssa = phi i16 [ %conv83, %while.body77 ], [ %shl101.lcssa, %while.end109.loopexit ]
  %add114 = add i16 %curr_quotient79.0.lcssa, %quotient58.0421
  %conv117 = zext i16 %shifted_divisor81.0.lcssa to i32
  %conv119 = and i32 %reduced_dividend65.0.in420, 65535
  %sub120 = sub nsw i32 %conv119, %conv117
  %fold467 = sub i32 %reduced_dividend65.0.in420, %conv117
  %conv72 = and i32 %fold467, 65535
  %cmp75 = icmp ult i32 %conv72, %conv74418
  br i1 %cmp75, label %if.end123.loopexit, label %while.body77

if.end123.loopexit:                               ; preds = %while.end109
  %add114.lcssa = phi i16 [ %add114, %while.end109 ]
  br label %if.end123

if.end123:                                        ; preds = %if.end123.loopexit, %if.then63, %if.end53.if.end123_crit_edge
  %tmp152 = phi i32 [ %tmp152.pre, %if.end53.if.end123_crit_edge ], [ %tmp67, %if.then63 ], [ %tmp67, %if.end123.loopexit ]
  %tmp144 = phi i32 [ %tmp144.pre, %if.end53.if.end123_crit_edge ], [ %tmp66, %if.then63 ], [ %tmp66, %if.end123.loopexit ]
  %quotient58.1 = phi i16 [ 0, %if.end53.if.end123_crit_edge ], [ 0, %if.then63 ], [ %add114.lcssa, %if.end123.loopexit ]
  %conv125 = zext i16 %quotient58.1 to i32
  %add126 = add nsw i32 %conv125, 1
  store i32 %add126, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp127 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  store i32 %tmp127, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %tmp146 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %tmp150 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp154 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %conv181 = zext i16 %call to i32
  %conv184459 = zext i16 %call3 to i32
  %add185460 = add nsw i32 %conv184459, 1
  %cmp186461 = icmp ult i32 %conv181, %add185460
  br i1 %cmp186461, label %bb.nph466, label %for.end377

bb.nph466:                                        ; preds = %if.end123
  %conv194 = zext i16 %call1 to i32
  %conv198448 = zext i16 %call4 to i32
  %add199449 = add nsw i32 %conv198448, 1
  %cmp200450 = icmp ult i32 %conv194, %add199449
  %conv209 = zext i16 %call2 to i32
  %conv213437 = zext i16 %call5 to i32
  %add214438 = add nsw i32 %conv213437, 1
  %cmp215439 = icmp ult i32 %conv209, %add214438
  %cmp222424 = icmp sgt i32 %tmp150, 0
  %tmp3 = zext i16 %call5 to i32
  %tmp4 = add i32 %tmp3, 1
  %tmp5 = zext i16 %call2 to i32
  %tmp6 = add i32 %tmp5, 1
  %tmp7 = icmp ugt i32 %tmp4, %tmp6
  %umax = select i1 %tmp7, i32 %tmp4, i32 %tmp6
  %tmp10 = sub i32 %umax, %tmp5
  %tmp13 = mul i32 %tmp150, %tmp5
  %tmp40 = zext i16 %call4 to i32
  %tmp41 = add i32 %tmp40, 1
  %tmp42 = zext i16 %call1 to i32
  %tmp43 = add i32 %tmp42, 1
  %tmp44 = icmp ugt i32 %tmp41, %tmp43
  %umax45 = select i1 %tmp44, i32 %tmp41, i32 %tmp43
  %tmp46 = sub i32 %umax45, %tmp42
  %tmp73 = zext i8 %tmp to i32
  %tmp75 = mul i32 %tmp42, %tmp73
  %tmp84 = zext i16 %call3 to i32
  %tmp85 = add i32 %tmp84, 1
  %tmp86 = zext i16 %call to i32
  %tmp87 = add i32 %tmp86, 1
  %tmp88 = icmp ugt i32 %tmp85, %tmp87
  %umax89 = select i1 %tmp88, i32 %tmp85, i32 %tmp87
  %tmp90 = sub i32 %umax89, %tmp86
  %tmp92 = zext i8 %tmp to i32
  %tmp94 = mul i32 %tmp86, %tmp92
  %tmp98 = zext i16 %quotient58.1 to i32
  %tmp99 = add i32 %tmp98, 1
  %tmp100 = mul i32 %tmp127, %tmp99
  %tmp102 = mul i32 %tmp99, %tmp86
  %tmp103 = zext i16 %call1 to i32
  %tmp104 = add i32 %tmp102, %tmp103
  %tmp105 = mul i32 %tmp127, %tmp104
  %tmp106 = zext i16 %call2 to i32
  %tmp107 = add i32 %tmp105, %tmp106
  %tmp112 = mul i32 %tmp127, 16
  %tmp114 = mul i32 %tmp127, %tmp99
  %tmp115 = mul i32 %tmp114, 16
  %tmp117 = mul i32 %tmp107, 16
  br label %for.body

for.body:                                         ; preds = %for.inc374, %bb.nph466
  %indvar488 = phi i32 [ 0, %bb.nph466 ], [ %indvar.next489, %for.inc374 ]
  %ker_data.4465 = phi i64 [ undef, %bb.nph466 ], [ %ker_data.3.lcssa, %for.inc374 ]
  %img_data.4464 = phi i64 [ undef, %bb.nph466 ], [ %img_data.3.lcssa, %for.inc374 ]
  %count.3463 = phi i32 [ 0, %bb.nph466 ], [ %count.2.lcssa, %for.inc374 ]
  %tmp93 = mul i32 %tmp92, %indvar488
  %tmp95 = add i32 %tmp94, %tmp93
  %tmp101 = mul i32 %tmp100, %indvar488
  %tmp108 = add i32 %tmp107, %tmp101
  %tmp116 = mul i32 %tmp115, %indvar488
  %tmp118 = add i32 %tmp117, %tmp116
  br i1 %cmp200450, label %for.body202.preheader, label %for.inc374

for.body202.preheader:                            ; preds = %for.body
  br label %for.body202

for.body202:                                      ; preds = %for.inc370, %for.body202.preheader
  %indvar484 = phi i32 [ %indvar.next485, %for.inc370 ], [ 0, %for.body202.preheader ]
  %ker_data.3454 = phi i64 [ %ker_data.2.lcssa, %for.inc370 ], [ %ker_data.4465, %for.body202.preheader ]
  %img_data.3453 = phi i64 [ %img_data.2.lcssa, %for.inc370 ], [ %img_data.4464, %for.body202.preheader ]
  %count.2452 = phi i32 [ %count.1.lcssa, %for.inc370 ], [ %count.3463, %for.body202.preheader ]
  %tmp97 = mul i32 %tmp127, %indvar484
  %tmp109 = add i32 %tmp108, %tmp97
  %tmp113 = mul i32 %tmp112, %indvar484
  %tmp119 = add i32 %tmp118, %tmp113
  %tmp74 = mul i32 %tmp73, %indvar484
  %tmp76 = add i32 %tmp75, %tmp74
  br i1 %cmp215439, label %while.cond219.preheader.preheader, label %for.inc370

while.cond219.preheader.preheader:                ; preds = %for.body202
  br label %while.cond219.preheader

while.cond219.preheader:                          ; preds = %while.end336, %while.cond219.preheader.preheader
  %indvar471 = phi i32 [ %indvar.next472, %while.end336 ], [ 0, %while.cond219.preheader.preheader ]
  %ker_data.2443 = phi i64 [ %ker_data.1.lcssa, %while.end336 ], [ %ker_data.3454, %while.cond219.preheader.preheader ]
  %img_data.2442 = phi i64 [ %img_data.1.lcssa, %while.end336 ], [ %img_data.3453, %while.cond219.preheader.preheader ]
  %count.1441 = phi i32 [ %count.0.lcssa, %while.end336 ], [ %count.2452, %while.cond219.preheader.preheader ]
  %add346 = add i32 %tmp109, %indvar471
  %tmp111 = mul i32 %indvar471, 16
  %sub352 = add i32 %tmp119, %tmp111
  %tmp12 = mul i32 %tmp150, %indvar471
  %tmp14 = add i32 %tmp13, %tmp12
  br i1 %cmp222424, label %bb.nph432, label %while.end336

bb.nph432:                                        ; preds = %while.cond219.preheader
  %tmp469 = add i32 %count.1441, 1
  br label %while.body224

while.body224:                                    ; preds = %if.end333, %bb.nph432
  %indvar = phi i32 [ 0, %bb.nph432 ], [ %indvar.next, %if.end333 ]
  %result_temp.0431 = phi i16 [ 0, %bb.nph432 ], [ %conv316, %if.end333 ]
  %ker_data.1430 = phi i64 [ %ker_data.2443, %bb.nph432 ], [ %ker_data.0, %if.end333 ]
  %img_data.1429 = phi i64 [ %img_data.2442, %bb.nph432 ], [ %img_data.0, %if.end333 ]
  %k.0427 = phi i32 [ 0, %bb.nph432 ], [ %k.4, %if.end333 ]
  %j.1426 = phi i32 [ 0, %bb.nph432 ], [ %j.0, %if.end333 ]
  %i.1425 = phi i32 [ 0, %bb.nph432 ], [ %i.0, %if.end333 ]
  %inc335 = add i32 %tmp469, %indvar
  %count.0428 = add i32 %count.1441, %indvar
  %tmp77 = add i32 %tmp76, %j.1426
  %tmp81 = add i32 %tmp95, %i.1425
  %tmp82 = mul i32 %tmp144, %tmp81
  %tmp386 = add i32 %tmp77, %tmp82
  %tmp387 = mul i32 %tmp386, %tmp146
  %add242 = add nsw i32 %tmp387, %k.0427
  %tmp391 = add i32 %tmp14, %i.1425
  %tmp392 = mul i32 %tmp391, %tmp152
  %tmp390 = add i32 %tmp392, %j.1426
  %tmp393 = mul i32 %tmp390, %tmp154
  %add256 = add nsw i32 %tmp393, %k.0427
  %sub275 = and i32 %count.0428, 3
  %cmp276 = icmp eq i32 %sub275, 0
  br i1 %cmp276, label %if.then278, label %if.end286

if.then278:                                       ; preds = %while.body224
  %shr280 = ashr i32 %add242, 2
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %shr280
  %tmp281 = load i64* %arrayidx, align 4
  %shr283 = ashr i32 %add256, 2
  %arrayidx284 = getelementptr inbounds %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %shr283
  %tmp285 = load i64* %arrayidx284, align 4
  br label %if.end286

if.end286:                                        ; preds = %if.then278, %while.body224
  %img_data.0 = phi i64 [ %tmp281, %if.then278 ], [ %img_data.1429, %while.body224 ]
  %ker_data.0 = phi i64 [ %tmp285, %if.then278 ], [ %ker_data.1430, %while.body224 ]
  %sub262 = shl i32 %add242, 4
  %mul292 = and i32 %sub262, 48
  %sh_prom = zext i32 %mul292 to i64
  %shr293 = lshr i64 %img_data.0, %sh_prom
  %conv294 = trunc i64 %shr293 to i32
  %sub269 = shl i32 %add256, 4
  %mul302 = and i32 %sub269, 48
  %sh_prom303 = zext i32 %mul302 to i64
  %shr304 = lshr i64 %ker_data.0, %sh_prom303
  %conv306 = trunc i64 %shr304 to i32
  %sext = shl i32 %conv294, 16
  %conv309 = ashr i32 %sext, 16
  %sext382 = shl i32 %conv306, 16
  %conv311 = ashr i32 %sext382, 16
  %mul312 = mul nsw i32 %conv311, %conv309
  %conv314383 = zext i16 %result_temp.0431 to i32
  %add315 = add nsw i32 %mul312, %conv314383
  %conv316 = trunc i32 %add315 to i16
  %inc = add nsw i32 %k.0427, 1
  %cmp320 = icmp eq i32 %inc, %tmp154
  br i1 %cmp320, label %if.then322, label %if.end333

if.then322:                                       ; preds = %if.end286
  %inc324 = add nsw i32 %j.1426, 1
  %cmp327 = icmp eq i32 %inc324, %tmp152
  %inc331 = zext i1 %cmp327 to i32
  %inc331.i.1 = add i32 %inc331, %i.1425
  br i1 %cmp327, label %if.then329, label %if.end333

if.then329:                                       ; preds = %if.then322
  br label %if.end333

if.end333:                                        ; preds = %if.then329, %if.then322, %if.end286
  %i.0 = phi i32 [ %inc331.i.1, %if.then329 ], [ %inc331.i.1, %if.then322 ], [ %i.1425, %if.end286 ]
  %j.0 = phi i32 [ 0, %if.then329 ], [ %inc324, %if.then322 ], [ %j.1426, %if.end286 ]
  %k.4 = phi i32 [ 0, %if.then329 ], [ 0, %if.then322 ], [ %inc, %if.end286 ]
  %cmp222 = icmp slt i32 %i.0, %tmp150
  %indvar.next = add i32 %indvar, 1
  br i1 %cmp222, label %while.body224, label %while.cond219.while.end336_crit_edge

while.cond219.while.end336_crit_edge:             ; preds = %if.end333
  %conv316.lcssa = phi i16 [ %conv316, %if.end333 ]
  %ker_data.0.lcssa = phi i64 [ %ker_data.0, %if.end333 ]
  %img_data.0.lcssa = phi i64 [ %img_data.0, %if.end333 ]
  %inc335.lcssa = phi i32 [ %inc335, %if.end333 ]
  %phitmp = sext i16 %conv316.lcssa to i64
  br label %while.end336

while.end336:                                     ; preds = %while.cond219.while.end336_crit_edge, %while.cond219.preheader
  %result_temp.0.lcssa = phi i64 [ %phitmp, %while.cond219.while.end336_crit_edge ], [ 0, %while.cond219.preheader ]
  %ker_data.1.lcssa = phi i64 [ %ker_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %ker_data.2443, %while.cond219.preheader ]
  %img_data.1.lcssa = phi i64 [ %img_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %img_data.2442, %while.cond219.preheader ]
  %count.0.lcssa = phi i32 [ %inc335.lcssa, %while.cond219.while.end336_crit_edge ], [ %count.1441, %while.cond219.preheader ]
  %shr355 = ashr i32 %add346, 2
  %arrayidx356 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %shr355
  %tmp357 = load i64* %arrayidx356, align 4
  %mul362 = and i32 %sub352, 48
  %sh_prom363 = zext i32 %mul362 to i64
  %shl364 = shl i64 %result_temp.0.lcssa, %sh_prom363
  %or = or i64 %tmp357, %shl364
  store i64 %or, i64* %arrayidx356, align 4
  %indvar.next472 = add i32 %indvar471, 1
  %exitcond11 = icmp eq i32 %indvar.next472, %tmp10
  br i1 %exitcond11, label %for.inc370.loopexit, label %while.cond219.preheader

for.inc370.loopexit:                              ; preds = %while.end336
  %count.0.lcssa.lcssa = phi i32 [ %count.0.lcssa, %while.end336 ]
  %img_data.1.lcssa.lcssa = phi i64 [ %img_data.1.lcssa, %while.end336 ]
  %ker_data.1.lcssa.lcssa = phi i64 [ %ker_data.1.lcssa, %while.end336 ]
  br label %for.inc370

for.inc370:                                       ; preds = %for.inc370.loopexit, %for.body202
  %ker_data.2.lcssa = phi i64 [ %ker_data.3454, %for.body202 ], [ %ker_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %img_data.2.lcssa = phi i64 [ %img_data.3453, %for.body202 ], [ %img_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %count.1.lcssa = phi i32 [ %count.2452, %for.body202 ], [ %count.0.lcssa.lcssa, %for.inc370.loopexit ]
  %indvar.next485 = add i32 %indvar484, 1
  %exitcond = icmp eq i32 %indvar.next485, %tmp46
  br i1 %exitcond, label %for.inc374.loopexit, label %for.body202

for.inc374.loopexit:                              ; preds = %for.inc370
  %count.1.lcssa.lcssa = phi i32 [ %count.1.lcssa, %for.inc370 ]
  %img_data.2.lcssa.lcssa = phi i64 [ %img_data.2.lcssa, %for.inc370 ]
  %ker_data.2.lcssa.lcssa = phi i64 [ %ker_data.2.lcssa, %for.inc370 ]
  br label %for.inc374

for.inc374:                                       ; preds = %for.inc374.loopexit, %for.body
  %ker_data.3.lcssa = phi i64 [ %ker_data.4465, %for.body ], [ %ker_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %img_data.3.lcssa = phi i64 [ %img_data.4464, %for.body ], [ %img_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %count.2.lcssa = phi i32 [ %count.3463, %for.body ], [ %count.1.lcssa.lcssa, %for.inc374.loopexit ]
  %indvar.next489 = add i32 %indvar488, 1
  %exitcond91 = icmp eq i32 %indvar.next489, %tmp90
  br i1 %exitcond91, label %for.end377.loopexit, label %for.body

for.end377.loopexit:                              ; preds = %for.inc374
  br label %for.end377

for.end377:                                       ; preds = %for.end377.loopexit, %if.end123
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str3, i32 0, i32 0), i16 zeroext 1) nounwind
  ret void
}

declare zeroext i16 @read_uint16(i8*)

declare void @__aa_barrier__(...)

declare void @write_uint16(i8*, i16 zeroext)

define void @convCore2() nounwind {
entry:
  %call = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call2 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call3 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call4 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  %call5 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 0), align 4
  store i32 3, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 2), align 4
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 1), align 4
  %tmp = load i8* @stride, align 1
  %cmp = icmp eq i8 %tmp, 0
  br i1 %cmp, label %if.end53.thread, label %if.then

if.end53.thread:                                  ; preds = %entry
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.end53.if.end123_crit_edge

if.then:                                          ; preds = %entry
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %tmp9 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %sub = sub i32 %tmp8, %tmp9
  %conv12401 = and i32 %sub, 65535
  %conv14403 = zext i8 %tmp to i32
  %cmp15404 = icmp ult i32 %conv12401, %conv14403
  br i1 %cmp15404, label %if.end53.thread596, label %bb.nph407

if.end53.thread596:                               ; preds = %if.then
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.then63

bb.nph407:                                        ; preds = %if.then
  %conv20 = zext i8 %tmp to i16
  br label %while.body

while.body:                                       ; preds = %while.end, %bb.nph407
  %quotient.0406 = phi i16 [ 0, %bb.nph407 ], [ %add, %while.end ]
  %reduced_dividend.0.in405 = phi i32 [ %sub, %bb.nph407 ], [ %sub50, %while.end ]
  %conv23 = lshr i32 %reduced_dividend.0.in405, 1
  %shr385 = and i32 %conv23, 32767
  %cmp31397 = icmp ult i32 %conv14403, %shr385
  br i1 %cmp31397, label %if.then33.preheader, label %while.end

if.then33.preheader:                              ; preds = %while.body
  br label %if.then33

if.then33:                                        ; preds = %if.then33, %if.then33.preheader
  %curr_quotient.0399 = phi i16 [ %shl39, %if.then33 ], [ 1, %if.then33.preheader ]
  %shifted_divisor.0398 = phi i16 [ %shl, %if.then33 ], [ %conv20, %if.then33.preheader ]
  %shl = shl i16 %shifted_divisor.0398, 1
  %shl39 = shl i16 %curr_quotient.0399, 1
  %conv28 = zext i16 %shl to i32
  %cmp31 = icmp ult i32 %conv28, %shr385
  br i1 %cmp31, label %if.then33, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.then33
  %shl39.lcssa = phi i16 [ %shl39, %if.then33 ]
  %shl.lcssa = phi i16 [ %shl, %if.then33 ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %while.body
  %curr_quotient.0.lcssa = phi i16 [ 1, %while.body ], [ %shl39.lcssa, %while.end.loopexit ]
  %shifted_divisor.0.lcssa = phi i16 [ %conv20, %while.body ], [ %shl.lcssa, %while.end.loopexit ]
  %add = add i16 %curr_quotient.0.lcssa, %quotient.0406
  %conv47 = zext i16 %shifted_divisor.0.lcssa to i32
  %conv49 = and i32 %reduced_dividend.0.in405, 65535
  %sub50 = sub nsw i32 %conv49, %conv47
  %fold = sub i32 %reduced_dividend.0.in405, %conv47
  %conv12 = and i32 %fold, 65535
  %cmp15 = icmp ult i32 %conv12, %conv14403
  br i1 %cmp15, label %if.end53, label %while.body

if.end53:                                         ; preds = %while.end
  %add.lcssa = phi i16 [ %add, %while.end ]
  %conv55 = zext i16 %add.lcssa to i32
  %add56 = add nsw i32 %conv55, 1
  store i32 %add56, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br i1 %cmp, label %if.end53.if.end123_crit_edge, label %if.then63

if.end53.if.end123_crit_edge:                     ; preds = %if.end53, %if.end53.thread
  %tmp144.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp152.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  br label %if.end123

if.then63:                                        ; preds = %if.end53, %if.end53.thread596
  %tmp66 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp67 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %sub68 = sub i32 %tmp66, %tmp67
  %conv72416 = and i32 %sub68, 65535
  %conv74418 = zext i8 %tmp to i32
  %cmp75419 = icmp ult i32 %conv72416, %conv74418
  br i1 %cmp75419, label %if.end123, label %bb.nph422

bb.nph422:                                        ; preds = %if.then63
  %conv83 = zext i8 %tmp to i16
  br label %while.body77

while.body77:                                     ; preds = %while.end109, %bb.nph422
  %quotient58.0421 = phi i16 [ 0, %bb.nph422 ], [ %add114, %while.end109 ]
  %reduced_dividend65.0.in420 = phi i32 [ %sub68, %bb.nph422 ], [ %sub120, %while.end109 ]
  %conv87 = lshr i32 %reduced_dividend65.0.in420, 1
  %shr88384 = and i32 %conv87, 32767
  %cmp96410 = icmp ult i32 %conv74418, %shr88384
  br i1 %cmp96410, label %if.then98.preheader, label %while.end109

if.then98.preheader:                              ; preds = %while.body77
  br label %if.then98

if.then98:                                        ; preds = %if.then98, %if.then98.preheader
  %curr_quotient79.0412 = phi i16 [ %shl105, %if.then98 ], [ 1, %if.then98.preheader ]
  %shifted_divisor81.0411 = phi i16 [ %shl101, %if.then98 ], [ %conv83, %if.then98.preheader ]
  %shl101 = shl i16 %shifted_divisor81.0411, 1
  %shl105 = shl i16 %curr_quotient79.0412, 1
  %conv93 = zext i16 %shl101 to i32
  %cmp96 = icmp ult i32 %conv93, %shr88384
  br i1 %cmp96, label %if.then98, label %while.end109.loopexit

while.end109.loopexit:                            ; preds = %if.then98
  %shl105.lcssa = phi i16 [ %shl105, %if.then98 ]
  %shl101.lcssa = phi i16 [ %shl101, %if.then98 ]
  br label %while.end109

while.end109:                                     ; preds = %while.end109.loopexit, %while.body77
  %curr_quotient79.0.lcssa = phi i16 [ 1, %while.body77 ], [ %shl105.lcssa, %while.end109.loopexit ]
  %shifted_divisor81.0.lcssa = phi i16 [ %conv83, %while.body77 ], [ %shl101.lcssa, %while.end109.loopexit ]
  %add114 = add i16 %curr_quotient79.0.lcssa, %quotient58.0421
  %conv117 = zext i16 %shifted_divisor81.0.lcssa to i32
  %conv119 = and i32 %reduced_dividend65.0.in420, 65535
  %sub120 = sub nsw i32 %conv119, %conv117
  %fold467 = sub i32 %reduced_dividend65.0.in420, %conv117
  %conv72 = and i32 %fold467, 65535
  %cmp75 = icmp ult i32 %conv72, %conv74418
  br i1 %cmp75, label %if.end123.loopexit, label %while.body77

if.end123.loopexit:                               ; preds = %while.end109
  %add114.lcssa = phi i16 [ %add114, %while.end109 ]
  br label %if.end123

if.end123:                                        ; preds = %if.end123.loopexit, %if.then63, %if.end53.if.end123_crit_edge
  %tmp152 = phi i32 [ %tmp152.pre, %if.end53.if.end123_crit_edge ], [ %tmp67, %if.then63 ], [ %tmp67, %if.end123.loopexit ]
  %tmp144 = phi i32 [ %tmp144.pre, %if.end53.if.end123_crit_edge ], [ %tmp66, %if.then63 ], [ %tmp66, %if.end123.loopexit ]
  %quotient58.1 = phi i16 [ 0, %if.end53.if.end123_crit_edge ], [ 0, %if.then63 ], [ %add114.lcssa, %if.end123.loopexit ]
  %conv125 = zext i16 %quotient58.1 to i32
  %add126 = add nsw i32 %conv125, 1
  store i32 %add126, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp127 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  store i32 %tmp127, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %tmp146 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %tmp150 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp154 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %conv181 = zext i16 %call to i32
  %conv184459 = zext i16 %call3 to i32
  %add185460 = add nsw i32 %conv184459, 1
  %cmp186461 = icmp ult i32 %conv181, %add185460
  br i1 %cmp186461, label %bb.nph466, label %for.end377

bb.nph466:                                        ; preds = %if.end123
  %conv194 = zext i16 %call1 to i32
  %conv198448 = zext i16 %call4 to i32
  %add199449 = add nsw i32 %conv198448, 1
  %cmp200450 = icmp ult i32 %conv194, %add199449
  %conv209 = zext i16 %call2 to i32
  %conv213437 = zext i16 %call5 to i32
  %add214438 = add nsw i32 %conv213437, 1
  %cmp215439 = icmp ult i32 %conv209, %add214438
  %cmp222424 = icmp sgt i32 %tmp150, 0
  %tmp3 = zext i16 %call5 to i32
  %tmp4 = add i32 %tmp3, 1
  %tmp5 = zext i16 %call2 to i32
  %tmp6 = add i32 %tmp5, 1
  %tmp7 = icmp ugt i32 %tmp4, %tmp6
  %umax = select i1 %tmp7, i32 %tmp4, i32 %tmp6
  %tmp10 = sub i32 %umax, %tmp5
  %tmp13 = mul i32 %tmp150, %tmp5
  %tmp40 = zext i16 %call4 to i32
  %tmp41 = add i32 %tmp40, 1
  %tmp42 = zext i16 %call1 to i32
  %tmp43 = add i32 %tmp42, 1
  %tmp44 = icmp ugt i32 %tmp41, %tmp43
  %umax45 = select i1 %tmp44, i32 %tmp41, i32 %tmp43
  %tmp46 = sub i32 %umax45, %tmp42
  %tmp73 = zext i8 %tmp to i32
  %tmp75 = mul i32 %tmp42, %tmp73
  %tmp84 = zext i16 %call3 to i32
  %tmp85 = add i32 %tmp84, 1
  %tmp86 = zext i16 %call to i32
  %tmp87 = add i32 %tmp86, 1
  %tmp88 = icmp ugt i32 %tmp85, %tmp87
  %umax89 = select i1 %tmp88, i32 %tmp85, i32 %tmp87
  %tmp90 = sub i32 %umax89, %tmp86
  %tmp92 = zext i8 %tmp to i32
  %tmp94 = mul i32 %tmp86, %tmp92
  %tmp98 = zext i16 %quotient58.1 to i32
  %tmp99 = add i32 %tmp98, 1
  %tmp100 = mul i32 %tmp127, %tmp99
  %tmp102 = mul i32 %tmp99, %tmp86
  %tmp103 = zext i16 %call1 to i32
  %tmp104 = add i32 %tmp102, %tmp103
  %tmp105 = mul i32 %tmp127, %tmp104
  %tmp106 = zext i16 %call2 to i32
  %tmp107 = add i32 %tmp105, %tmp106
  %tmp112 = mul i32 %tmp127, 16
  %tmp114 = mul i32 %tmp127, %tmp99
  %tmp115 = mul i32 %tmp114, 16
  %tmp117 = mul i32 %tmp107, 16
  br label %for.body

for.body:                                         ; preds = %for.inc374, %bb.nph466
  %indvar488 = phi i32 [ 0, %bb.nph466 ], [ %indvar.next489, %for.inc374 ]
  %ker_data.4465 = phi i64 [ undef, %bb.nph466 ], [ %ker_data.3.lcssa, %for.inc374 ]
  %img_data.4464 = phi i64 [ undef, %bb.nph466 ], [ %img_data.3.lcssa, %for.inc374 ]
  %count.3463 = phi i32 [ 0, %bb.nph466 ], [ %count.2.lcssa, %for.inc374 ]
  %tmp93 = mul i32 %tmp92, %indvar488
  %tmp95 = add i32 %tmp94, %tmp93
  %tmp101 = mul i32 %tmp100, %indvar488
  %tmp108 = add i32 %tmp107, %tmp101
  %tmp116 = mul i32 %tmp115, %indvar488
  %tmp118 = add i32 %tmp117, %tmp116
  br i1 %cmp200450, label %for.body202.preheader, label %for.inc374

for.body202.preheader:                            ; preds = %for.body
  br label %for.body202

for.body202:                                      ; preds = %for.inc370, %for.body202.preheader
  %indvar484 = phi i32 [ %indvar.next485, %for.inc370 ], [ 0, %for.body202.preheader ]
  %ker_data.3454 = phi i64 [ %ker_data.2.lcssa, %for.inc370 ], [ %ker_data.4465, %for.body202.preheader ]
  %img_data.3453 = phi i64 [ %img_data.2.lcssa, %for.inc370 ], [ %img_data.4464, %for.body202.preheader ]
  %count.2452 = phi i32 [ %count.1.lcssa, %for.inc370 ], [ %count.3463, %for.body202.preheader ]
  %tmp97 = mul i32 %tmp127, %indvar484
  %tmp109 = add i32 %tmp108, %tmp97
  %tmp113 = mul i32 %tmp112, %indvar484
  %tmp119 = add i32 %tmp118, %tmp113
  %tmp74 = mul i32 %tmp73, %indvar484
  %tmp76 = add i32 %tmp75, %tmp74
  br i1 %cmp215439, label %while.cond219.preheader.preheader, label %for.inc370

while.cond219.preheader.preheader:                ; preds = %for.body202
  br label %while.cond219.preheader

while.cond219.preheader:                          ; preds = %while.end336, %while.cond219.preheader.preheader
  %indvar471 = phi i32 [ %indvar.next472, %while.end336 ], [ 0, %while.cond219.preheader.preheader ]
  %ker_data.2443 = phi i64 [ %ker_data.1.lcssa, %while.end336 ], [ %ker_data.3454, %while.cond219.preheader.preheader ]
  %img_data.2442 = phi i64 [ %img_data.1.lcssa, %while.end336 ], [ %img_data.3453, %while.cond219.preheader.preheader ]
  %count.1441 = phi i32 [ %count.0.lcssa, %while.end336 ], [ %count.2452, %while.cond219.preheader.preheader ]
  %add346 = add i32 %tmp109, %indvar471
  %tmp111 = mul i32 %indvar471, 16
  %sub352 = add i32 %tmp119, %tmp111
  %tmp12 = mul i32 %tmp150, %indvar471
  %tmp14 = add i32 %tmp13, %tmp12
  br i1 %cmp222424, label %bb.nph432, label %while.end336

bb.nph432:                                        ; preds = %while.cond219.preheader
  %tmp469 = add i32 %count.1441, 1
  br label %while.body224

while.body224:                                    ; preds = %if.end333, %bb.nph432
  %indvar = phi i32 [ 0, %bb.nph432 ], [ %indvar.next, %if.end333 ]
  %result_temp.0431 = phi i16 [ 0, %bb.nph432 ], [ %conv316, %if.end333 ]
  %ker_data.1430 = phi i64 [ %ker_data.2443, %bb.nph432 ], [ %ker_data.0, %if.end333 ]
  %img_data.1429 = phi i64 [ %img_data.2442, %bb.nph432 ], [ %img_data.0, %if.end333 ]
  %k.0427 = phi i32 [ 0, %bb.nph432 ], [ %k.4, %if.end333 ]
  %j.1426 = phi i32 [ 0, %bb.nph432 ], [ %j.0, %if.end333 ]
  %i.1425 = phi i32 [ 0, %bb.nph432 ], [ %i.0, %if.end333 ]
  %inc335 = add i32 %tmp469, %indvar
  %count.0428 = add i32 %count.1441, %indvar
  %tmp77 = add i32 %tmp76, %j.1426
  %tmp81 = add i32 %tmp95, %i.1425
  %tmp82 = mul i32 %tmp144, %tmp81
  %tmp386 = add i32 %tmp77, %tmp82
  %tmp387 = mul i32 %tmp386, %tmp146
  %add242 = add nsw i32 %tmp387, %k.0427
  %tmp391 = add i32 %tmp14, %i.1425
  %tmp392 = mul i32 %tmp391, %tmp152
  %tmp390 = add i32 %tmp392, %j.1426
  %tmp393 = mul i32 %tmp390, %tmp154
  %add256 = add nsw i32 %tmp393, %k.0427
  %sub275 = and i32 %count.0428, 3
  %cmp276 = icmp eq i32 %sub275, 0
  br i1 %cmp276, label %if.then278, label %if.end286

if.then278:                                       ; preds = %while.body224
  %shr280 = ashr i32 %add242, 2
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %shr280
  %tmp281 = load i64* %arrayidx, align 4
  %shr283 = ashr i32 %add256, 2
  %arrayidx284 = getelementptr inbounds %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %shr283
  %tmp285 = load i64* %arrayidx284, align 4
  br label %if.end286

if.end286:                                        ; preds = %if.then278, %while.body224
  %img_data.0 = phi i64 [ %tmp281, %if.then278 ], [ %img_data.1429, %while.body224 ]
  %ker_data.0 = phi i64 [ %tmp285, %if.then278 ], [ %ker_data.1430, %while.body224 ]
  %sub262 = shl i32 %add242, 4
  %mul292 = and i32 %sub262, 48
  %sh_prom = zext i32 %mul292 to i64
  %shr293 = lshr i64 %img_data.0, %sh_prom
  %conv294 = trunc i64 %shr293 to i32
  %sub269 = shl i32 %add256, 4
  %mul302 = and i32 %sub269, 48
  %sh_prom303 = zext i32 %mul302 to i64
  %shr304 = lshr i64 %ker_data.0, %sh_prom303
  %conv306 = trunc i64 %shr304 to i32
  %sext = shl i32 %conv294, 16
  %conv309 = ashr i32 %sext, 16
  %sext382 = shl i32 %conv306, 16
  %conv311 = ashr i32 %sext382, 16
  %mul312 = mul nsw i32 %conv311, %conv309
  %conv314383 = zext i16 %result_temp.0431 to i32
  %add315 = add nsw i32 %mul312, %conv314383
  %conv316 = trunc i32 %add315 to i16
  %inc = add nsw i32 %k.0427, 1
  %cmp320 = icmp eq i32 %inc, %tmp154
  br i1 %cmp320, label %if.then322, label %if.end333

if.then322:                                       ; preds = %if.end286
  %inc324 = add nsw i32 %j.1426, 1
  %cmp327 = icmp eq i32 %inc324, %tmp152
  %inc331 = zext i1 %cmp327 to i32
  %inc331.i.1 = add i32 %inc331, %i.1425
  br i1 %cmp327, label %if.then329, label %if.end333

if.then329:                                       ; preds = %if.then322
  br label %if.end333

if.end333:                                        ; preds = %if.then329, %if.then322, %if.end286
  %i.0 = phi i32 [ %inc331.i.1, %if.then329 ], [ %inc331.i.1, %if.then322 ], [ %i.1425, %if.end286 ]
  %j.0 = phi i32 [ 0, %if.then329 ], [ %inc324, %if.then322 ], [ %j.1426, %if.end286 ]
  %k.4 = phi i32 [ 0, %if.then329 ], [ 0, %if.then322 ], [ %inc, %if.end286 ]
  %cmp222 = icmp slt i32 %i.0, %tmp150
  %indvar.next = add i32 %indvar, 1
  br i1 %cmp222, label %while.body224, label %while.cond219.while.end336_crit_edge

while.cond219.while.end336_crit_edge:             ; preds = %if.end333
  %conv316.lcssa = phi i16 [ %conv316, %if.end333 ]
  %ker_data.0.lcssa = phi i64 [ %ker_data.0, %if.end333 ]
  %img_data.0.lcssa = phi i64 [ %img_data.0, %if.end333 ]
  %inc335.lcssa = phi i32 [ %inc335, %if.end333 ]
  %phitmp = sext i16 %conv316.lcssa to i64
  br label %while.end336

while.end336:                                     ; preds = %while.cond219.while.end336_crit_edge, %while.cond219.preheader
  %result_temp.0.lcssa = phi i64 [ %phitmp, %while.cond219.while.end336_crit_edge ], [ 0, %while.cond219.preheader ]
  %ker_data.1.lcssa = phi i64 [ %ker_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %ker_data.2443, %while.cond219.preheader ]
  %img_data.1.lcssa = phi i64 [ %img_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %img_data.2442, %while.cond219.preheader ]
  %count.0.lcssa = phi i32 [ %inc335.lcssa, %while.cond219.while.end336_crit_edge ], [ %count.1441, %while.cond219.preheader ]
  %shr355 = ashr i32 %add346, 2
  %arrayidx356 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %shr355
  %tmp357 = load i64* %arrayidx356, align 4
  %mul362 = and i32 %sub352, 48
  %sh_prom363 = zext i32 %mul362 to i64
  %shl364 = shl i64 %result_temp.0.lcssa, %sh_prom363
  %or = or i64 %tmp357, %shl364
  store i64 %or, i64* %arrayidx356, align 4
  %indvar.next472 = add i32 %indvar471, 1
  %exitcond11 = icmp eq i32 %indvar.next472, %tmp10
  br i1 %exitcond11, label %for.inc370.loopexit, label %while.cond219.preheader

for.inc370.loopexit:                              ; preds = %while.end336
  %count.0.lcssa.lcssa = phi i32 [ %count.0.lcssa, %while.end336 ]
  %img_data.1.lcssa.lcssa = phi i64 [ %img_data.1.lcssa, %while.end336 ]
  %ker_data.1.lcssa.lcssa = phi i64 [ %ker_data.1.lcssa, %while.end336 ]
  br label %for.inc370

for.inc370:                                       ; preds = %for.inc370.loopexit, %for.body202
  %ker_data.2.lcssa = phi i64 [ %ker_data.3454, %for.body202 ], [ %ker_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %img_data.2.lcssa = phi i64 [ %img_data.3453, %for.body202 ], [ %img_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %count.1.lcssa = phi i32 [ %count.2452, %for.body202 ], [ %count.0.lcssa.lcssa, %for.inc370.loopexit ]
  %indvar.next485 = add i32 %indvar484, 1
  %exitcond = icmp eq i32 %indvar.next485, %tmp46
  br i1 %exitcond, label %for.inc374.loopexit, label %for.body202

for.inc374.loopexit:                              ; preds = %for.inc370
  %count.1.lcssa.lcssa = phi i32 [ %count.1.lcssa, %for.inc370 ]
  %img_data.2.lcssa.lcssa = phi i64 [ %img_data.2.lcssa, %for.inc370 ]
  %ker_data.2.lcssa.lcssa = phi i64 [ %ker_data.2.lcssa, %for.inc370 ]
  br label %for.inc374

for.inc374:                                       ; preds = %for.inc374.loopexit, %for.body
  %ker_data.3.lcssa = phi i64 [ %ker_data.4465, %for.body ], [ %ker_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %img_data.3.lcssa = phi i64 [ %img_data.4464, %for.body ], [ %img_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %count.2.lcssa = phi i32 [ %count.3463, %for.body ], [ %count.1.lcssa.lcssa, %for.inc374.loopexit ]
  %indvar.next489 = add i32 %indvar488, 1
  %exitcond91 = icmp eq i32 %indvar.next489, %tmp90
  br i1 %exitcond91, label %for.end377.loopexit, label %for.body

for.end377.loopexit:                              ; preds = %for.inc374
  br label %for.end377

for.end377:                                       ; preds = %for.end377.loopexit, %if.end123
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str5, i32 0, i32 0), i16 zeroext 1) nounwind
  ret void
}

define void @convCore3() nounwind {
entry:
  %call = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call2 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call3 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call4 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call5 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 0), align 4
  store i32 3, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 2), align 4
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 1), align 4
  %tmp = load i8* @stride, align 1
  %cmp = icmp eq i8 %tmp, 0
  br i1 %cmp, label %if.end53.thread, label %if.then

if.end53.thread:                                  ; preds = %entry
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.end53.if.end123_crit_edge

if.then:                                          ; preds = %entry
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %tmp9 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %sub = sub i32 %tmp8, %tmp9
  %conv12401 = and i32 %sub, 65535
  %conv14403 = zext i8 %tmp to i32
  %cmp15404 = icmp ult i32 %conv12401, %conv14403
  br i1 %cmp15404, label %if.end53.thread596, label %bb.nph407

if.end53.thread596:                               ; preds = %if.then
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.then63

bb.nph407:                                        ; preds = %if.then
  %conv20 = zext i8 %tmp to i16
  br label %while.body

while.body:                                       ; preds = %while.end, %bb.nph407
  %quotient.0406 = phi i16 [ 0, %bb.nph407 ], [ %add, %while.end ]
  %reduced_dividend.0.in405 = phi i32 [ %sub, %bb.nph407 ], [ %sub50, %while.end ]
  %conv23 = lshr i32 %reduced_dividend.0.in405, 1
  %shr385 = and i32 %conv23, 32767
  %cmp31397 = icmp ult i32 %conv14403, %shr385
  br i1 %cmp31397, label %if.then33.preheader, label %while.end

if.then33.preheader:                              ; preds = %while.body
  br label %if.then33

if.then33:                                        ; preds = %if.then33, %if.then33.preheader
  %curr_quotient.0399 = phi i16 [ %shl39, %if.then33 ], [ 1, %if.then33.preheader ]
  %shifted_divisor.0398 = phi i16 [ %shl, %if.then33 ], [ %conv20, %if.then33.preheader ]
  %shl = shl i16 %shifted_divisor.0398, 1
  %shl39 = shl i16 %curr_quotient.0399, 1
  %conv28 = zext i16 %shl to i32
  %cmp31 = icmp ult i32 %conv28, %shr385
  br i1 %cmp31, label %if.then33, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.then33
  %shl39.lcssa = phi i16 [ %shl39, %if.then33 ]
  %shl.lcssa = phi i16 [ %shl, %if.then33 ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %while.body
  %curr_quotient.0.lcssa = phi i16 [ 1, %while.body ], [ %shl39.lcssa, %while.end.loopexit ]
  %shifted_divisor.0.lcssa = phi i16 [ %conv20, %while.body ], [ %shl.lcssa, %while.end.loopexit ]
  %add = add i16 %curr_quotient.0.lcssa, %quotient.0406
  %conv47 = zext i16 %shifted_divisor.0.lcssa to i32
  %conv49 = and i32 %reduced_dividend.0.in405, 65535
  %sub50 = sub nsw i32 %conv49, %conv47
  %fold = sub i32 %reduced_dividend.0.in405, %conv47
  %conv12 = and i32 %fold, 65535
  %cmp15 = icmp ult i32 %conv12, %conv14403
  br i1 %cmp15, label %if.end53, label %while.body

if.end53:                                         ; preds = %while.end
  %add.lcssa = phi i16 [ %add, %while.end ]
  %conv55 = zext i16 %add.lcssa to i32
  %add56 = add nsw i32 %conv55, 1
  store i32 %add56, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br i1 %cmp, label %if.end53.if.end123_crit_edge, label %if.then63

if.end53.if.end123_crit_edge:                     ; preds = %if.end53, %if.end53.thread
  %tmp144.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp152.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  br label %if.end123

if.then63:                                        ; preds = %if.end53, %if.end53.thread596
  %tmp66 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp67 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %sub68 = sub i32 %tmp66, %tmp67
  %conv72416 = and i32 %sub68, 65535
  %conv74418 = zext i8 %tmp to i32
  %cmp75419 = icmp ult i32 %conv72416, %conv74418
  br i1 %cmp75419, label %if.end123, label %bb.nph422

bb.nph422:                                        ; preds = %if.then63
  %conv83 = zext i8 %tmp to i16
  br label %while.body77

while.body77:                                     ; preds = %while.end109, %bb.nph422
  %quotient58.0421 = phi i16 [ 0, %bb.nph422 ], [ %add114, %while.end109 ]
  %reduced_dividend65.0.in420 = phi i32 [ %sub68, %bb.nph422 ], [ %sub120, %while.end109 ]
  %conv87 = lshr i32 %reduced_dividend65.0.in420, 1
  %shr88384 = and i32 %conv87, 32767
  %cmp96410 = icmp ult i32 %conv74418, %shr88384
  br i1 %cmp96410, label %if.then98.preheader, label %while.end109

if.then98.preheader:                              ; preds = %while.body77
  br label %if.then98

if.then98:                                        ; preds = %if.then98, %if.then98.preheader
  %curr_quotient79.0412 = phi i16 [ %shl105, %if.then98 ], [ 1, %if.then98.preheader ]
  %shifted_divisor81.0411 = phi i16 [ %shl101, %if.then98 ], [ %conv83, %if.then98.preheader ]
  %shl101 = shl i16 %shifted_divisor81.0411, 1
  %shl105 = shl i16 %curr_quotient79.0412, 1
  %conv93 = zext i16 %shl101 to i32
  %cmp96 = icmp ult i32 %conv93, %shr88384
  br i1 %cmp96, label %if.then98, label %while.end109.loopexit

while.end109.loopexit:                            ; preds = %if.then98
  %shl105.lcssa = phi i16 [ %shl105, %if.then98 ]
  %shl101.lcssa = phi i16 [ %shl101, %if.then98 ]
  br label %while.end109

while.end109:                                     ; preds = %while.end109.loopexit, %while.body77
  %curr_quotient79.0.lcssa = phi i16 [ 1, %while.body77 ], [ %shl105.lcssa, %while.end109.loopexit ]
  %shifted_divisor81.0.lcssa = phi i16 [ %conv83, %while.body77 ], [ %shl101.lcssa, %while.end109.loopexit ]
  %add114 = add i16 %curr_quotient79.0.lcssa, %quotient58.0421
  %conv117 = zext i16 %shifted_divisor81.0.lcssa to i32
  %conv119 = and i32 %reduced_dividend65.0.in420, 65535
  %sub120 = sub nsw i32 %conv119, %conv117
  %fold467 = sub i32 %reduced_dividend65.0.in420, %conv117
  %conv72 = and i32 %fold467, 65535
  %cmp75 = icmp ult i32 %conv72, %conv74418
  br i1 %cmp75, label %if.end123.loopexit, label %while.body77

if.end123.loopexit:                               ; preds = %while.end109
  %add114.lcssa = phi i16 [ %add114, %while.end109 ]
  br label %if.end123

if.end123:                                        ; preds = %if.end123.loopexit, %if.then63, %if.end53.if.end123_crit_edge
  %tmp152 = phi i32 [ %tmp152.pre, %if.end53.if.end123_crit_edge ], [ %tmp67, %if.then63 ], [ %tmp67, %if.end123.loopexit ]
  %tmp144 = phi i32 [ %tmp144.pre, %if.end53.if.end123_crit_edge ], [ %tmp66, %if.then63 ], [ %tmp66, %if.end123.loopexit ]
  %quotient58.1 = phi i16 [ 0, %if.end53.if.end123_crit_edge ], [ 0, %if.then63 ], [ %add114.lcssa, %if.end123.loopexit ]
  %conv125 = zext i16 %quotient58.1 to i32
  %add126 = add nsw i32 %conv125, 1
  store i32 %add126, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp127 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  store i32 %tmp127, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %tmp146 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %tmp150 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp154 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %conv181 = zext i16 %call to i32
  %conv184459 = zext i16 %call3 to i32
  %add185460 = add nsw i32 %conv184459, 1
  %cmp186461 = icmp ult i32 %conv181, %add185460
  br i1 %cmp186461, label %bb.nph466, label %for.end377

bb.nph466:                                        ; preds = %if.end123
  %conv194 = zext i16 %call1 to i32
  %conv198448 = zext i16 %call4 to i32
  %add199449 = add nsw i32 %conv198448, 1
  %cmp200450 = icmp ult i32 %conv194, %add199449
  %conv209 = zext i16 %call2 to i32
  %conv213437 = zext i16 %call5 to i32
  %add214438 = add nsw i32 %conv213437, 1
  %cmp215439 = icmp ult i32 %conv209, %add214438
  %cmp222424 = icmp sgt i32 %tmp150, 0
  %tmp3 = zext i16 %call5 to i32
  %tmp4 = add i32 %tmp3, 1
  %tmp5 = zext i16 %call2 to i32
  %tmp6 = add i32 %tmp5, 1
  %tmp7 = icmp ugt i32 %tmp4, %tmp6
  %umax = select i1 %tmp7, i32 %tmp4, i32 %tmp6
  %tmp10 = sub i32 %umax, %tmp5
  %tmp13 = mul i32 %tmp150, %tmp5
  %tmp40 = zext i16 %call4 to i32
  %tmp41 = add i32 %tmp40, 1
  %tmp42 = zext i16 %call1 to i32
  %tmp43 = add i32 %tmp42, 1
  %tmp44 = icmp ugt i32 %tmp41, %tmp43
  %umax45 = select i1 %tmp44, i32 %tmp41, i32 %tmp43
  %tmp46 = sub i32 %umax45, %tmp42
  %tmp73 = zext i8 %tmp to i32
  %tmp75 = mul i32 %tmp42, %tmp73
  %tmp84 = zext i16 %call3 to i32
  %tmp85 = add i32 %tmp84, 1
  %tmp86 = zext i16 %call to i32
  %tmp87 = add i32 %tmp86, 1
  %tmp88 = icmp ugt i32 %tmp85, %tmp87
  %umax89 = select i1 %tmp88, i32 %tmp85, i32 %tmp87
  %tmp90 = sub i32 %umax89, %tmp86
  %tmp92 = zext i8 %tmp to i32
  %tmp94 = mul i32 %tmp86, %tmp92
  %tmp98 = zext i16 %quotient58.1 to i32
  %tmp99 = add i32 %tmp98, 1
  %tmp100 = mul i32 %tmp127, %tmp99
  %tmp102 = mul i32 %tmp99, %tmp86
  %tmp103 = zext i16 %call1 to i32
  %tmp104 = add i32 %tmp102, %tmp103
  %tmp105 = mul i32 %tmp127, %tmp104
  %tmp106 = zext i16 %call2 to i32
  %tmp107 = add i32 %tmp105, %tmp106
  %tmp112 = mul i32 %tmp127, 16
  %tmp114 = mul i32 %tmp127, %tmp99
  %tmp115 = mul i32 %tmp114, 16
  %tmp117 = mul i32 %tmp107, 16
  br label %for.body

for.body:                                         ; preds = %for.inc374, %bb.nph466
  %indvar488 = phi i32 [ 0, %bb.nph466 ], [ %indvar.next489, %for.inc374 ]
  %ker_data.4465 = phi i64 [ undef, %bb.nph466 ], [ %ker_data.3.lcssa, %for.inc374 ]
  %img_data.4464 = phi i64 [ undef, %bb.nph466 ], [ %img_data.3.lcssa, %for.inc374 ]
  %count.3463 = phi i32 [ 0, %bb.nph466 ], [ %count.2.lcssa, %for.inc374 ]
  %tmp93 = mul i32 %tmp92, %indvar488
  %tmp95 = add i32 %tmp94, %tmp93
  %tmp101 = mul i32 %tmp100, %indvar488
  %tmp108 = add i32 %tmp107, %tmp101
  %tmp116 = mul i32 %tmp115, %indvar488
  %tmp118 = add i32 %tmp117, %tmp116
  br i1 %cmp200450, label %for.body202.preheader, label %for.inc374

for.body202.preheader:                            ; preds = %for.body
  br label %for.body202

for.body202:                                      ; preds = %for.inc370, %for.body202.preheader
  %indvar484 = phi i32 [ %indvar.next485, %for.inc370 ], [ 0, %for.body202.preheader ]
  %ker_data.3454 = phi i64 [ %ker_data.2.lcssa, %for.inc370 ], [ %ker_data.4465, %for.body202.preheader ]
  %img_data.3453 = phi i64 [ %img_data.2.lcssa, %for.inc370 ], [ %img_data.4464, %for.body202.preheader ]
  %count.2452 = phi i32 [ %count.1.lcssa, %for.inc370 ], [ %count.3463, %for.body202.preheader ]
  %tmp97 = mul i32 %tmp127, %indvar484
  %tmp109 = add i32 %tmp108, %tmp97
  %tmp113 = mul i32 %tmp112, %indvar484
  %tmp119 = add i32 %tmp118, %tmp113
  %tmp74 = mul i32 %tmp73, %indvar484
  %tmp76 = add i32 %tmp75, %tmp74
  br i1 %cmp215439, label %while.cond219.preheader.preheader, label %for.inc370

while.cond219.preheader.preheader:                ; preds = %for.body202
  br label %while.cond219.preheader

while.cond219.preheader:                          ; preds = %while.end336, %while.cond219.preheader.preheader
  %indvar471 = phi i32 [ %indvar.next472, %while.end336 ], [ 0, %while.cond219.preheader.preheader ]
  %ker_data.2443 = phi i64 [ %ker_data.1.lcssa, %while.end336 ], [ %ker_data.3454, %while.cond219.preheader.preheader ]
  %img_data.2442 = phi i64 [ %img_data.1.lcssa, %while.end336 ], [ %img_data.3453, %while.cond219.preheader.preheader ]
  %count.1441 = phi i32 [ %count.0.lcssa, %while.end336 ], [ %count.2452, %while.cond219.preheader.preheader ]
  %add346 = add i32 %tmp109, %indvar471
  %tmp111 = mul i32 %indvar471, 16
  %sub352 = add i32 %tmp119, %tmp111
  %tmp12 = mul i32 %tmp150, %indvar471
  %tmp14 = add i32 %tmp13, %tmp12
  br i1 %cmp222424, label %bb.nph432, label %while.end336

bb.nph432:                                        ; preds = %while.cond219.preheader
  %tmp469 = add i32 %count.1441, 1
  br label %while.body224

while.body224:                                    ; preds = %if.end333, %bb.nph432
  %indvar = phi i32 [ 0, %bb.nph432 ], [ %indvar.next, %if.end333 ]
  %result_temp.0431 = phi i16 [ 0, %bb.nph432 ], [ %conv316, %if.end333 ]
  %ker_data.1430 = phi i64 [ %ker_data.2443, %bb.nph432 ], [ %ker_data.0, %if.end333 ]
  %img_data.1429 = phi i64 [ %img_data.2442, %bb.nph432 ], [ %img_data.0, %if.end333 ]
  %k.0427 = phi i32 [ 0, %bb.nph432 ], [ %k.4, %if.end333 ]
  %j.1426 = phi i32 [ 0, %bb.nph432 ], [ %j.0, %if.end333 ]
  %i.1425 = phi i32 [ 0, %bb.nph432 ], [ %i.0, %if.end333 ]
  %inc335 = add i32 %tmp469, %indvar
  %count.0428 = add i32 %count.1441, %indvar
  %tmp77 = add i32 %tmp76, %j.1426
  %tmp81 = add i32 %tmp95, %i.1425
  %tmp82 = mul i32 %tmp144, %tmp81
  %tmp386 = add i32 %tmp77, %tmp82
  %tmp387 = mul i32 %tmp386, %tmp146
  %add242 = add nsw i32 %tmp387, %k.0427
  %tmp391 = add i32 %tmp14, %i.1425
  %tmp392 = mul i32 %tmp391, %tmp152
  %tmp390 = add i32 %tmp392, %j.1426
  %tmp393 = mul i32 %tmp390, %tmp154
  %add256 = add nsw i32 %tmp393, %k.0427
  %sub275 = and i32 %count.0428, 3
  %cmp276 = icmp eq i32 %sub275, 0
  br i1 %cmp276, label %if.then278, label %if.end286

if.then278:                                       ; preds = %while.body224
  %shr280 = ashr i32 %add242, 2
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %shr280
  %tmp281 = load i64* %arrayidx, align 4
  %shr283 = ashr i32 %add256, 2
  %arrayidx284 = getelementptr inbounds %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %shr283
  %tmp285 = load i64* %arrayidx284, align 4
  br label %if.end286

if.end286:                                        ; preds = %if.then278, %while.body224
  %img_data.0 = phi i64 [ %tmp281, %if.then278 ], [ %img_data.1429, %while.body224 ]
  %ker_data.0 = phi i64 [ %tmp285, %if.then278 ], [ %ker_data.1430, %while.body224 ]
  %sub262 = shl i32 %add242, 4
  %mul292 = and i32 %sub262, 48
  %sh_prom = zext i32 %mul292 to i64
  %shr293 = lshr i64 %img_data.0, %sh_prom
  %conv294 = trunc i64 %shr293 to i32
  %sub269 = shl i32 %add256, 4
  %mul302 = and i32 %sub269, 48
  %sh_prom303 = zext i32 %mul302 to i64
  %shr304 = lshr i64 %ker_data.0, %sh_prom303
  %conv306 = trunc i64 %shr304 to i32
  %sext = shl i32 %conv294, 16
  %conv309 = ashr i32 %sext, 16
  %sext382 = shl i32 %conv306, 16
  %conv311 = ashr i32 %sext382, 16
  %mul312 = mul nsw i32 %conv311, %conv309
  %conv314383 = zext i16 %result_temp.0431 to i32
  %add315 = add nsw i32 %mul312, %conv314383
  %conv316 = trunc i32 %add315 to i16
  %inc = add nsw i32 %k.0427, 1
  %cmp320 = icmp eq i32 %inc, %tmp154
  br i1 %cmp320, label %if.then322, label %if.end333

if.then322:                                       ; preds = %if.end286
  %inc324 = add nsw i32 %j.1426, 1
  %cmp327 = icmp eq i32 %inc324, %tmp152
  %inc331 = zext i1 %cmp327 to i32
  %inc331.i.1 = add i32 %inc331, %i.1425
  br i1 %cmp327, label %if.then329, label %if.end333

if.then329:                                       ; preds = %if.then322
  br label %if.end333

if.end333:                                        ; preds = %if.then329, %if.then322, %if.end286
  %i.0 = phi i32 [ %inc331.i.1, %if.then329 ], [ %inc331.i.1, %if.then322 ], [ %i.1425, %if.end286 ]
  %j.0 = phi i32 [ 0, %if.then329 ], [ %inc324, %if.then322 ], [ %j.1426, %if.end286 ]
  %k.4 = phi i32 [ 0, %if.then329 ], [ 0, %if.then322 ], [ %inc, %if.end286 ]
  %cmp222 = icmp slt i32 %i.0, %tmp150
  %indvar.next = add i32 %indvar, 1
  br i1 %cmp222, label %while.body224, label %while.cond219.while.end336_crit_edge

while.cond219.while.end336_crit_edge:             ; preds = %if.end333
  %conv316.lcssa = phi i16 [ %conv316, %if.end333 ]
  %ker_data.0.lcssa = phi i64 [ %ker_data.0, %if.end333 ]
  %img_data.0.lcssa = phi i64 [ %img_data.0, %if.end333 ]
  %inc335.lcssa = phi i32 [ %inc335, %if.end333 ]
  %phitmp = sext i16 %conv316.lcssa to i64
  br label %while.end336

while.end336:                                     ; preds = %while.cond219.while.end336_crit_edge, %while.cond219.preheader
  %result_temp.0.lcssa = phi i64 [ %phitmp, %while.cond219.while.end336_crit_edge ], [ 0, %while.cond219.preheader ]
  %ker_data.1.lcssa = phi i64 [ %ker_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %ker_data.2443, %while.cond219.preheader ]
  %img_data.1.lcssa = phi i64 [ %img_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %img_data.2442, %while.cond219.preheader ]
  %count.0.lcssa = phi i32 [ %inc335.lcssa, %while.cond219.while.end336_crit_edge ], [ %count.1441, %while.cond219.preheader ]
  %shr355 = ashr i32 %add346, 2
  %arrayidx356 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %shr355
  %tmp357 = load i64* %arrayidx356, align 4
  %mul362 = and i32 %sub352, 48
  %sh_prom363 = zext i32 %mul362 to i64
  %shl364 = shl i64 %result_temp.0.lcssa, %sh_prom363
  %or = or i64 %tmp357, %shl364
  store i64 %or, i64* %arrayidx356, align 4
  %indvar.next472 = add i32 %indvar471, 1
  %exitcond11 = icmp eq i32 %indvar.next472, %tmp10
  br i1 %exitcond11, label %for.inc370.loopexit, label %while.cond219.preheader

for.inc370.loopexit:                              ; preds = %while.end336
  %count.0.lcssa.lcssa = phi i32 [ %count.0.lcssa, %while.end336 ]
  %img_data.1.lcssa.lcssa = phi i64 [ %img_data.1.lcssa, %while.end336 ]
  %ker_data.1.lcssa.lcssa = phi i64 [ %ker_data.1.lcssa, %while.end336 ]
  br label %for.inc370

for.inc370:                                       ; preds = %for.inc370.loopexit, %for.body202
  %ker_data.2.lcssa = phi i64 [ %ker_data.3454, %for.body202 ], [ %ker_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %img_data.2.lcssa = phi i64 [ %img_data.3453, %for.body202 ], [ %img_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %count.1.lcssa = phi i32 [ %count.2452, %for.body202 ], [ %count.0.lcssa.lcssa, %for.inc370.loopexit ]
  %indvar.next485 = add i32 %indvar484, 1
  %exitcond = icmp eq i32 %indvar.next485, %tmp46
  br i1 %exitcond, label %for.inc374.loopexit, label %for.body202

for.inc374.loopexit:                              ; preds = %for.inc370
  %count.1.lcssa.lcssa = phi i32 [ %count.1.lcssa, %for.inc370 ]
  %img_data.2.lcssa.lcssa = phi i64 [ %img_data.2.lcssa, %for.inc370 ]
  %ker_data.2.lcssa.lcssa = phi i64 [ %ker_data.2.lcssa, %for.inc370 ]
  br label %for.inc374

for.inc374:                                       ; preds = %for.inc374.loopexit, %for.body
  %ker_data.3.lcssa = phi i64 [ %ker_data.4465, %for.body ], [ %ker_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %img_data.3.lcssa = phi i64 [ %img_data.4464, %for.body ], [ %img_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %count.2.lcssa = phi i32 [ %count.3463, %for.body ], [ %count.1.lcssa.lcssa, %for.inc374.loopexit ]
  %indvar.next489 = add i32 %indvar488, 1
  %exitcond91 = icmp eq i32 %indvar.next489, %tmp90
  br i1 %exitcond91, label %for.end377.loopexit, label %for.body

for.end377.loopexit:                              ; preds = %for.inc374
  br label %for.end377

for.end377:                                       ; preds = %for.end377.loopexit, %if.end123
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str7, i32 0, i32 0), i16 zeroext 1) nounwind
  ret void
}

define void @convCore4() nounwind {
entry:
  %call = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  %call2 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  %call3 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  %call4 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  %call5 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 0), align 4
  store i32 3, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 2), align 4
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 1), align 4
  %tmp = load i8* @stride, align 1
  %cmp = icmp eq i8 %tmp, 0
  br i1 %cmp, label %if.end53.thread, label %if.then

if.end53.thread:                                  ; preds = %entry
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.end53.if.end123_crit_edge

if.then:                                          ; preds = %entry
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %tmp9 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %sub = sub i32 %tmp8, %tmp9
  %conv12401 = and i32 %sub, 65535
  %conv14403 = zext i8 %tmp to i32
  %cmp15404 = icmp ult i32 %conv12401, %conv14403
  br i1 %cmp15404, label %if.end53.thread596, label %bb.nph407

if.end53.thread596:                               ; preds = %if.then
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.then63

bb.nph407:                                        ; preds = %if.then
  %conv20 = zext i8 %tmp to i16
  br label %while.body

while.body:                                       ; preds = %while.end, %bb.nph407
  %quotient.0406 = phi i16 [ 0, %bb.nph407 ], [ %add, %while.end ]
  %reduced_dividend.0.in405 = phi i32 [ %sub, %bb.nph407 ], [ %sub50, %while.end ]
  %conv23 = lshr i32 %reduced_dividend.0.in405, 1
  %shr385 = and i32 %conv23, 32767
  %cmp31397 = icmp ult i32 %conv14403, %shr385
  br i1 %cmp31397, label %if.then33.preheader, label %while.end

if.then33.preheader:                              ; preds = %while.body
  br label %if.then33

if.then33:                                        ; preds = %if.then33, %if.then33.preheader
  %curr_quotient.0399 = phi i16 [ %shl39, %if.then33 ], [ 1, %if.then33.preheader ]
  %shifted_divisor.0398 = phi i16 [ %shl, %if.then33 ], [ %conv20, %if.then33.preheader ]
  %shl = shl i16 %shifted_divisor.0398, 1
  %shl39 = shl i16 %curr_quotient.0399, 1
  %conv28 = zext i16 %shl to i32
  %cmp31 = icmp ult i32 %conv28, %shr385
  br i1 %cmp31, label %if.then33, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.then33
  %shl39.lcssa = phi i16 [ %shl39, %if.then33 ]
  %shl.lcssa = phi i16 [ %shl, %if.then33 ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %while.body
  %curr_quotient.0.lcssa = phi i16 [ 1, %while.body ], [ %shl39.lcssa, %while.end.loopexit ]
  %shifted_divisor.0.lcssa = phi i16 [ %conv20, %while.body ], [ %shl.lcssa, %while.end.loopexit ]
  %add = add i16 %curr_quotient.0.lcssa, %quotient.0406
  %conv47 = zext i16 %shifted_divisor.0.lcssa to i32
  %conv49 = and i32 %reduced_dividend.0.in405, 65535
  %sub50 = sub nsw i32 %conv49, %conv47
  %fold = sub i32 %reduced_dividend.0.in405, %conv47
  %conv12 = and i32 %fold, 65535
  %cmp15 = icmp ult i32 %conv12, %conv14403
  br i1 %cmp15, label %if.end53, label %while.body

if.end53:                                         ; preds = %while.end
  %add.lcssa = phi i16 [ %add, %while.end ]
  %conv55 = zext i16 %add.lcssa to i32
  %add56 = add nsw i32 %conv55, 1
  store i32 %add56, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br i1 %cmp, label %if.end53.if.end123_crit_edge, label %if.then63

if.end53.if.end123_crit_edge:                     ; preds = %if.end53, %if.end53.thread
  %tmp144.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp152.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  br label %if.end123

if.then63:                                        ; preds = %if.end53, %if.end53.thread596
  %tmp66 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp67 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %sub68 = sub i32 %tmp66, %tmp67
  %conv72416 = and i32 %sub68, 65535
  %conv74418 = zext i8 %tmp to i32
  %cmp75419 = icmp ult i32 %conv72416, %conv74418
  br i1 %cmp75419, label %if.end123, label %bb.nph422

bb.nph422:                                        ; preds = %if.then63
  %conv83 = zext i8 %tmp to i16
  br label %while.body77

while.body77:                                     ; preds = %while.end109, %bb.nph422
  %quotient58.0421 = phi i16 [ 0, %bb.nph422 ], [ %add114, %while.end109 ]
  %reduced_dividend65.0.in420 = phi i32 [ %sub68, %bb.nph422 ], [ %sub120, %while.end109 ]
  %conv87 = lshr i32 %reduced_dividend65.0.in420, 1
  %shr88384 = and i32 %conv87, 32767
  %cmp96410 = icmp ult i32 %conv74418, %shr88384
  br i1 %cmp96410, label %if.then98.preheader, label %while.end109

if.then98.preheader:                              ; preds = %while.body77
  br label %if.then98

if.then98:                                        ; preds = %if.then98, %if.then98.preheader
  %curr_quotient79.0412 = phi i16 [ %shl105, %if.then98 ], [ 1, %if.then98.preheader ]
  %shifted_divisor81.0411 = phi i16 [ %shl101, %if.then98 ], [ %conv83, %if.then98.preheader ]
  %shl101 = shl i16 %shifted_divisor81.0411, 1
  %shl105 = shl i16 %curr_quotient79.0412, 1
  %conv93 = zext i16 %shl101 to i32
  %cmp96 = icmp ult i32 %conv93, %shr88384
  br i1 %cmp96, label %if.then98, label %while.end109.loopexit

while.end109.loopexit:                            ; preds = %if.then98
  %shl105.lcssa = phi i16 [ %shl105, %if.then98 ]
  %shl101.lcssa = phi i16 [ %shl101, %if.then98 ]
  br label %while.end109

while.end109:                                     ; preds = %while.end109.loopexit, %while.body77
  %curr_quotient79.0.lcssa = phi i16 [ 1, %while.body77 ], [ %shl105.lcssa, %while.end109.loopexit ]
  %shifted_divisor81.0.lcssa = phi i16 [ %conv83, %while.body77 ], [ %shl101.lcssa, %while.end109.loopexit ]
  %add114 = add i16 %curr_quotient79.0.lcssa, %quotient58.0421
  %conv117 = zext i16 %shifted_divisor81.0.lcssa to i32
  %conv119 = and i32 %reduced_dividend65.0.in420, 65535
  %sub120 = sub nsw i32 %conv119, %conv117
  %fold467 = sub i32 %reduced_dividend65.0.in420, %conv117
  %conv72 = and i32 %fold467, 65535
  %cmp75 = icmp ult i32 %conv72, %conv74418
  br i1 %cmp75, label %if.end123.loopexit, label %while.body77

if.end123.loopexit:                               ; preds = %while.end109
  %add114.lcssa = phi i16 [ %add114, %while.end109 ]
  br label %if.end123

if.end123:                                        ; preds = %if.end123.loopexit, %if.then63, %if.end53.if.end123_crit_edge
  %tmp152 = phi i32 [ %tmp152.pre, %if.end53.if.end123_crit_edge ], [ %tmp67, %if.then63 ], [ %tmp67, %if.end123.loopexit ]
  %tmp144 = phi i32 [ %tmp144.pre, %if.end53.if.end123_crit_edge ], [ %tmp66, %if.then63 ], [ %tmp66, %if.end123.loopexit ]
  %quotient58.1 = phi i16 [ 0, %if.end53.if.end123_crit_edge ], [ 0, %if.then63 ], [ %add114.lcssa, %if.end123.loopexit ]
  %conv125 = zext i16 %quotient58.1 to i32
  %add126 = add nsw i32 %conv125, 1
  store i32 %add126, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp127 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  store i32 %tmp127, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %tmp146 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %tmp150 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp154 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %conv181 = zext i16 %call to i32
  %conv184459 = zext i16 %call3 to i32
  %add185460 = add nsw i32 %conv184459, 1
  %cmp186461 = icmp ult i32 %conv181, %add185460
  br i1 %cmp186461, label %bb.nph466, label %for.end377

bb.nph466:                                        ; preds = %if.end123
  %conv194 = zext i16 %call1 to i32
  %conv198448 = zext i16 %call4 to i32
  %add199449 = add nsw i32 %conv198448, 1
  %cmp200450 = icmp ult i32 %conv194, %add199449
  %conv209 = zext i16 %call2 to i32
  %conv213437 = zext i16 %call5 to i32
  %add214438 = add nsw i32 %conv213437, 1
  %cmp215439 = icmp ult i32 %conv209, %add214438
  %cmp222424 = icmp sgt i32 %tmp150, 0
  %tmp3 = zext i16 %call5 to i32
  %tmp4 = add i32 %tmp3, 1
  %tmp5 = zext i16 %call2 to i32
  %tmp6 = add i32 %tmp5, 1
  %tmp7 = icmp ugt i32 %tmp4, %tmp6
  %umax = select i1 %tmp7, i32 %tmp4, i32 %tmp6
  %tmp10 = sub i32 %umax, %tmp5
  %tmp13 = mul i32 %tmp150, %tmp5
  %tmp40 = zext i16 %call4 to i32
  %tmp41 = add i32 %tmp40, 1
  %tmp42 = zext i16 %call1 to i32
  %tmp43 = add i32 %tmp42, 1
  %tmp44 = icmp ugt i32 %tmp41, %tmp43
  %umax45 = select i1 %tmp44, i32 %tmp41, i32 %tmp43
  %tmp46 = sub i32 %umax45, %tmp42
  %tmp73 = zext i8 %tmp to i32
  %tmp75 = mul i32 %tmp42, %tmp73
  %tmp84 = zext i16 %call3 to i32
  %tmp85 = add i32 %tmp84, 1
  %tmp86 = zext i16 %call to i32
  %tmp87 = add i32 %tmp86, 1
  %tmp88 = icmp ugt i32 %tmp85, %tmp87
  %umax89 = select i1 %tmp88, i32 %tmp85, i32 %tmp87
  %tmp90 = sub i32 %umax89, %tmp86
  %tmp92 = zext i8 %tmp to i32
  %tmp94 = mul i32 %tmp86, %tmp92
  %tmp98 = zext i16 %quotient58.1 to i32
  %tmp99 = add i32 %tmp98, 1
  %tmp100 = mul i32 %tmp127, %tmp99
  %tmp102 = mul i32 %tmp99, %tmp86
  %tmp103 = zext i16 %call1 to i32
  %tmp104 = add i32 %tmp102, %tmp103
  %tmp105 = mul i32 %tmp127, %tmp104
  %tmp106 = zext i16 %call2 to i32
  %tmp107 = add i32 %tmp105, %tmp106
  %tmp112 = mul i32 %tmp127, 16
  %tmp114 = mul i32 %tmp127, %tmp99
  %tmp115 = mul i32 %tmp114, 16
  %tmp117 = mul i32 %tmp107, 16
  br label %for.body

for.body:                                         ; preds = %for.inc374, %bb.nph466
  %indvar488 = phi i32 [ 0, %bb.nph466 ], [ %indvar.next489, %for.inc374 ]
  %ker_data.4465 = phi i64 [ undef, %bb.nph466 ], [ %ker_data.3.lcssa, %for.inc374 ]
  %img_data.4464 = phi i64 [ undef, %bb.nph466 ], [ %img_data.3.lcssa, %for.inc374 ]
  %count.3463 = phi i32 [ 0, %bb.nph466 ], [ %count.2.lcssa, %for.inc374 ]
  %tmp93 = mul i32 %tmp92, %indvar488
  %tmp95 = add i32 %tmp94, %tmp93
  %tmp101 = mul i32 %tmp100, %indvar488
  %tmp108 = add i32 %tmp107, %tmp101
  %tmp116 = mul i32 %tmp115, %indvar488
  %tmp118 = add i32 %tmp117, %tmp116
  br i1 %cmp200450, label %for.body202.preheader, label %for.inc374

for.body202.preheader:                            ; preds = %for.body
  br label %for.body202

for.body202:                                      ; preds = %for.inc370, %for.body202.preheader
  %indvar484 = phi i32 [ %indvar.next485, %for.inc370 ], [ 0, %for.body202.preheader ]
  %ker_data.3454 = phi i64 [ %ker_data.2.lcssa, %for.inc370 ], [ %ker_data.4465, %for.body202.preheader ]
  %img_data.3453 = phi i64 [ %img_data.2.lcssa, %for.inc370 ], [ %img_data.4464, %for.body202.preheader ]
  %count.2452 = phi i32 [ %count.1.lcssa, %for.inc370 ], [ %count.3463, %for.body202.preheader ]
  %tmp97 = mul i32 %tmp127, %indvar484
  %tmp109 = add i32 %tmp108, %tmp97
  %tmp113 = mul i32 %tmp112, %indvar484
  %tmp119 = add i32 %tmp118, %tmp113
  %tmp74 = mul i32 %tmp73, %indvar484
  %tmp76 = add i32 %tmp75, %tmp74
  br i1 %cmp215439, label %while.cond219.preheader.preheader, label %for.inc370

while.cond219.preheader.preheader:                ; preds = %for.body202
  br label %while.cond219.preheader

while.cond219.preheader:                          ; preds = %while.end336, %while.cond219.preheader.preheader
  %indvar471 = phi i32 [ %indvar.next472, %while.end336 ], [ 0, %while.cond219.preheader.preheader ]
  %ker_data.2443 = phi i64 [ %ker_data.1.lcssa, %while.end336 ], [ %ker_data.3454, %while.cond219.preheader.preheader ]
  %img_data.2442 = phi i64 [ %img_data.1.lcssa, %while.end336 ], [ %img_data.3453, %while.cond219.preheader.preheader ]
  %count.1441 = phi i32 [ %count.0.lcssa, %while.end336 ], [ %count.2452, %while.cond219.preheader.preheader ]
  %add346 = add i32 %tmp109, %indvar471
  %tmp111 = mul i32 %indvar471, 16
  %sub352 = add i32 %tmp119, %tmp111
  %tmp12 = mul i32 %tmp150, %indvar471
  %tmp14 = add i32 %tmp13, %tmp12
  br i1 %cmp222424, label %bb.nph432, label %while.end336

bb.nph432:                                        ; preds = %while.cond219.preheader
  %tmp469 = add i32 %count.1441, 1
  br label %while.body224

while.body224:                                    ; preds = %if.end333, %bb.nph432
  %indvar = phi i32 [ 0, %bb.nph432 ], [ %indvar.next, %if.end333 ]
  %result_temp.0431 = phi i16 [ 0, %bb.nph432 ], [ %conv316, %if.end333 ]
  %ker_data.1430 = phi i64 [ %ker_data.2443, %bb.nph432 ], [ %ker_data.0, %if.end333 ]
  %img_data.1429 = phi i64 [ %img_data.2442, %bb.nph432 ], [ %img_data.0, %if.end333 ]
  %k.0427 = phi i32 [ 0, %bb.nph432 ], [ %k.4, %if.end333 ]
  %j.1426 = phi i32 [ 0, %bb.nph432 ], [ %j.0, %if.end333 ]
  %i.1425 = phi i32 [ 0, %bb.nph432 ], [ %i.0, %if.end333 ]
  %inc335 = add i32 %tmp469, %indvar
  %count.0428 = add i32 %count.1441, %indvar
  %tmp77 = add i32 %tmp76, %j.1426
  %tmp81 = add i32 %tmp95, %i.1425
  %tmp82 = mul i32 %tmp144, %tmp81
  %tmp386 = add i32 %tmp77, %tmp82
  %tmp387 = mul i32 %tmp386, %tmp146
  %add242 = add nsw i32 %tmp387, %k.0427
  %tmp391 = add i32 %tmp14, %i.1425
  %tmp392 = mul i32 %tmp391, %tmp152
  %tmp390 = add i32 %tmp392, %j.1426
  %tmp393 = mul i32 %tmp390, %tmp154
  %add256 = add nsw i32 %tmp393, %k.0427
  %sub275 = and i32 %count.0428, 3
  %cmp276 = icmp eq i32 %sub275, 0
  br i1 %cmp276, label %if.then278, label %if.end286

if.then278:                                       ; preds = %while.body224
  %shr280 = ashr i32 %add242, 2
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %shr280
  %tmp281 = load i64* %arrayidx, align 4
  %shr283 = ashr i32 %add256, 2
  %arrayidx284 = getelementptr inbounds %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %shr283
  %tmp285 = load i64* %arrayidx284, align 4
  br label %if.end286

if.end286:                                        ; preds = %if.then278, %while.body224
  %img_data.0 = phi i64 [ %tmp281, %if.then278 ], [ %img_data.1429, %while.body224 ]
  %ker_data.0 = phi i64 [ %tmp285, %if.then278 ], [ %ker_data.1430, %while.body224 ]
  %sub262 = shl i32 %add242, 4
  %mul292 = and i32 %sub262, 48
  %sh_prom = zext i32 %mul292 to i64
  %shr293 = lshr i64 %img_data.0, %sh_prom
  %conv294 = trunc i64 %shr293 to i32
  %sub269 = shl i32 %add256, 4
  %mul302 = and i32 %sub269, 48
  %sh_prom303 = zext i32 %mul302 to i64
  %shr304 = lshr i64 %ker_data.0, %sh_prom303
  %conv306 = trunc i64 %shr304 to i32
  %sext = shl i32 %conv294, 16
  %conv309 = ashr i32 %sext, 16
  %sext382 = shl i32 %conv306, 16
  %conv311 = ashr i32 %sext382, 16
  %mul312 = mul nsw i32 %conv311, %conv309
  %conv314383 = zext i16 %result_temp.0431 to i32
  %add315 = add nsw i32 %mul312, %conv314383
  %conv316 = trunc i32 %add315 to i16
  %inc = add nsw i32 %k.0427, 1
  %cmp320 = icmp eq i32 %inc, %tmp154
  br i1 %cmp320, label %if.then322, label %if.end333

if.then322:                                       ; preds = %if.end286
  %inc324 = add nsw i32 %j.1426, 1
  %cmp327 = icmp eq i32 %inc324, %tmp152
  %inc331 = zext i1 %cmp327 to i32
  %inc331.i.1 = add i32 %inc331, %i.1425
  br i1 %cmp327, label %if.then329, label %if.end333

if.then329:                                       ; preds = %if.then322
  br label %if.end333

if.end333:                                        ; preds = %if.then329, %if.then322, %if.end286
  %i.0 = phi i32 [ %inc331.i.1, %if.then329 ], [ %inc331.i.1, %if.then322 ], [ %i.1425, %if.end286 ]
  %j.0 = phi i32 [ 0, %if.then329 ], [ %inc324, %if.then322 ], [ %j.1426, %if.end286 ]
  %k.4 = phi i32 [ 0, %if.then329 ], [ 0, %if.then322 ], [ %inc, %if.end286 ]
  %cmp222 = icmp slt i32 %i.0, %tmp150
  %indvar.next = add i32 %indvar, 1
  br i1 %cmp222, label %while.body224, label %while.cond219.while.end336_crit_edge

while.cond219.while.end336_crit_edge:             ; preds = %if.end333
  %conv316.lcssa = phi i16 [ %conv316, %if.end333 ]
  %ker_data.0.lcssa = phi i64 [ %ker_data.0, %if.end333 ]
  %img_data.0.lcssa = phi i64 [ %img_data.0, %if.end333 ]
  %inc335.lcssa = phi i32 [ %inc335, %if.end333 ]
  %phitmp = sext i16 %conv316.lcssa to i64
  br label %while.end336

while.end336:                                     ; preds = %while.cond219.while.end336_crit_edge, %while.cond219.preheader
  %result_temp.0.lcssa = phi i64 [ %phitmp, %while.cond219.while.end336_crit_edge ], [ 0, %while.cond219.preheader ]
  %ker_data.1.lcssa = phi i64 [ %ker_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %ker_data.2443, %while.cond219.preheader ]
  %img_data.1.lcssa = phi i64 [ %img_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %img_data.2442, %while.cond219.preheader ]
  %count.0.lcssa = phi i32 [ %inc335.lcssa, %while.cond219.while.end336_crit_edge ], [ %count.1441, %while.cond219.preheader ]
  %shr355 = ashr i32 %add346, 2
  %arrayidx356 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %shr355
  %tmp357 = load i64* %arrayidx356, align 4
  %mul362 = and i32 %sub352, 48
  %sh_prom363 = zext i32 %mul362 to i64
  %shl364 = shl i64 %result_temp.0.lcssa, %sh_prom363
  %or = or i64 %tmp357, %shl364
  store i64 %or, i64* %arrayidx356, align 4
  %indvar.next472 = add i32 %indvar471, 1
  %exitcond11 = icmp eq i32 %indvar.next472, %tmp10
  br i1 %exitcond11, label %for.inc370.loopexit, label %while.cond219.preheader

for.inc370.loopexit:                              ; preds = %while.end336
  %count.0.lcssa.lcssa = phi i32 [ %count.0.lcssa, %while.end336 ]
  %img_data.1.lcssa.lcssa = phi i64 [ %img_data.1.lcssa, %while.end336 ]
  %ker_data.1.lcssa.lcssa = phi i64 [ %ker_data.1.lcssa, %while.end336 ]
  br label %for.inc370

for.inc370:                                       ; preds = %for.inc370.loopexit, %for.body202
  %ker_data.2.lcssa = phi i64 [ %ker_data.3454, %for.body202 ], [ %ker_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %img_data.2.lcssa = phi i64 [ %img_data.3453, %for.body202 ], [ %img_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %count.1.lcssa = phi i32 [ %count.2452, %for.body202 ], [ %count.0.lcssa.lcssa, %for.inc370.loopexit ]
  %indvar.next485 = add i32 %indvar484, 1
  %exitcond = icmp eq i32 %indvar.next485, %tmp46
  br i1 %exitcond, label %for.inc374.loopexit, label %for.body202

for.inc374.loopexit:                              ; preds = %for.inc370
  %count.1.lcssa.lcssa = phi i32 [ %count.1.lcssa, %for.inc370 ]
  %img_data.2.lcssa.lcssa = phi i64 [ %img_data.2.lcssa, %for.inc370 ]
  %ker_data.2.lcssa.lcssa = phi i64 [ %ker_data.2.lcssa, %for.inc370 ]
  br label %for.inc374

for.inc374:                                       ; preds = %for.inc374.loopexit, %for.body
  %ker_data.3.lcssa = phi i64 [ %ker_data.4465, %for.body ], [ %ker_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %img_data.3.lcssa = phi i64 [ %img_data.4464, %for.body ], [ %img_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %count.2.lcssa = phi i32 [ %count.3463, %for.body ], [ %count.1.lcssa.lcssa, %for.inc374.loopexit ]
  %indvar.next489 = add i32 %indvar488, 1
  %exitcond91 = icmp eq i32 %indvar.next489, %tmp90
  br i1 %exitcond91, label %for.end377.loopexit, label %for.body

for.end377.loopexit:                              ; preds = %for.inc374
  br label %for.end377

for.end377:                                       ; preds = %for.end377.loopexit, %if.end123
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str9, i32 0, i32 0), i16 zeroext 1) nounwind
  ret void
}

define void @convCore5() nounwind {
entry:
  %call = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  %call2 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  %call3 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  %call4 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  %call5 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  store i32 5, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 0), align 4
  store i32 3, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 2), align 4
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 1), align 4
  %tmp = load i8* @stride, align 1
  %cmp = icmp eq i8 %tmp, 0
  br i1 %cmp, label %if.end53.thread, label %if.then

if.end53.thread:                                  ; preds = %entry
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.end53.if.end123_crit_edge

if.then:                                          ; preds = %entry
  %tmp8 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 0), align 4
  %tmp9 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %sub = sub i32 %tmp8, %tmp9
  %conv12401 = and i32 %sub, 65535
  %conv14403 = zext i8 %tmp to i32
  %cmp15404 = icmp ult i32 %conv12401, %conv14403
  br i1 %cmp15404, label %if.end53.thread596, label %bb.nph407

if.end53.thread596:                               ; preds = %if.then
  store i32 1, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br label %if.then63

bb.nph407:                                        ; preds = %if.then
  %conv20 = zext i8 %tmp to i16
  br label %while.body

while.body:                                       ; preds = %while.end, %bb.nph407
  %quotient.0406 = phi i16 [ 0, %bb.nph407 ], [ %add, %while.end ]
  %reduced_dividend.0.in405 = phi i32 [ %sub, %bb.nph407 ], [ %sub50, %while.end ]
  %conv23 = lshr i32 %reduced_dividend.0.in405, 1
  %shr385 = and i32 %conv23, 32767
  %cmp31397 = icmp ult i32 %conv14403, %shr385
  br i1 %cmp31397, label %if.then33.preheader, label %while.end

if.then33.preheader:                              ; preds = %while.body
  br label %if.then33

if.then33:                                        ; preds = %if.then33, %if.then33.preheader
  %curr_quotient.0399 = phi i16 [ %shl39, %if.then33 ], [ 1, %if.then33.preheader ]
  %shifted_divisor.0398 = phi i16 [ %shl, %if.then33 ], [ %conv20, %if.then33.preheader ]
  %shl = shl i16 %shifted_divisor.0398, 1
  %shl39 = shl i16 %curr_quotient.0399, 1
  %conv28 = zext i16 %shl to i32
  %cmp31 = icmp ult i32 %conv28, %shr385
  br i1 %cmp31, label %if.then33, label %while.end.loopexit

while.end.loopexit:                               ; preds = %if.then33
  %shl39.lcssa = phi i16 [ %shl39, %if.then33 ]
  %shl.lcssa = phi i16 [ %shl, %if.then33 ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %while.body
  %curr_quotient.0.lcssa = phi i16 [ 1, %while.body ], [ %shl39.lcssa, %while.end.loopexit ]
  %shifted_divisor.0.lcssa = phi i16 [ %conv20, %while.body ], [ %shl.lcssa, %while.end.loopexit ]
  %add = add i16 %curr_quotient.0.lcssa, %quotient.0406
  %conv47 = zext i16 %shifted_divisor.0.lcssa to i32
  %conv49 = and i32 %reduced_dividend.0.in405, 65535
  %sub50 = sub nsw i32 %conv49, %conv47
  %fold = sub i32 %reduced_dividend.0.in405, %conv47
  %conv12 = and i32 %fold, 65535
  %cmp15 = icmp ult i32 %conv12, %conv14403
  br i1 %cmp15, label %if.end53, label %while.body

if.end53:                                         ; preds = %while.end
  %add.lcssa = phi i16 [ %add, %while.end ]
  %conv55 = zext i16 %add.lcssa to i32
  %add56 = add nsw i32 %conv55, 1
  store i32 %add56, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 0), align 4
  br i1 %cmp, label %if.end53.if.end123_crit_edge, label %if.then63

if.end53.if.end123_crit_edge:                     ; preds = %if.end53, %if.end53.thread
  %tmp144.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp152.pre = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  br label %if.end123

if.then63:                                        ; preds = %if.end53, %if.end53.thread596
  %tmp66 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 1), align 4
  %tmp67 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 2), align 4
  %sub68 = sub i32 %tmp66, %tmp67
  %conv72416 = and i32 %sub68, 65535
  %conv74418 = zext i8 %tmp to i32
  %cmp75419 = icmp ult i32 %conv72416, %conv74418
  br i1 %cmp75419, label %if.end123, label %bb.nph422

bb.nph422:                                        ; preds = %if.then63
  %conv83 = zext i8 %tmp to i16
  br label %while.body77

while.body77:                                     ; preds = %while.end109, %bb.nph422
  %quotient58.0421 = phi i16 [ 0, %bb.nph422 ], [ %add114, %while.end109 ]
  %reduced_dividend65.0.in420 = phi i32 [ %sub68, %bb.nph422 ], [ %sub120, %while.end109 ]
  %conv87 = lshr i32 %reduced_dividend65.0.in420, 1
  %shr88384 = and i32 %conv87, 32767
  %cmp96410 = icmp ult i32 %conv74418, %shr88384
  br i1 %cmp96410, label %if.then98.preheader, label %while.end109

if.then98.preheader:                              ; preds = %while.body77
  br label %if.then98

if.then98:                                        ; preds = %if.then98, %if.then98.preheader
  %curr_quotient79.0412 = phi i16 [ %shl105, %if.then98 ], [ 1, %if.then98.preheader ]
  %shifted_divisor81.0411 = phi i16 [ %shl101, %if.then98 ], [ %conv83, %if.then98.preheader ]
  %shl101 = shl i16 %shifted_divisor81.0411, 1
  %shl105 = shl i16 %curr_quotient79.0412, 1
  %conv93 = zext i16 %shl101 to i32
  %cmp96 = icmp ult i32 %conv93, %shr88384
  br i1 %cmp96, label %if.then98, label %while.end109.loopexit

while.end109.loopexit:                            ; preds = %if.then98
  %shl105.lcssa = phi i16 [ %shl105, %if.then98 ]
  %shl101.lcssa = phi i16 [ %shl101, %if.then98 ]
  br label %while.end109

while.end109:                                     ; preds = %while.end109.loopexit, %while.body77
  %curr_quotient79.0.lcssa = phi i16 [ 1, %while.body77 ], [ %shl105.lcssa, %while.end109.loopexit ]
  %shifted_divisor81.0.lcssa = phi i16 [ %conv83, %while.body77 ], [ %shl101.lcssa, %while.end109.loopexit ]
  %add114 = add i16 %curr_quotient79.0.lcssa, %quotient58.0421
  %conv117 = zext i16 %shifted_divisor81.0.lcssa to i32
  %conv119 = and i32 %reduced_dividend65.0.in420, 65535
  %sub120 = sub nsw i32 %conv119, %conv117
  %fold467 = sub i32 %reduced_dividend65.0.in420, %conv117
  %conv72 = and i32 %fold467, 65535
  %cmp75 = icmp ult i32 %conv72, %conv74418
  br i1 %cmp75, label %if.end123.loopexit, label %while.body77

if.end123.loopexit:                               ; preds = %while.end109
  %add114.lcssa = phi i16 [ %add114, %while.end109 ]
  br label %if.end123

if.end123:                                        ; preds = %if.end123.loopexit, %if.then63, %if.end53.if.end123_crit_edge
  %tmp152 = phi i32 [ %tmp152.pre, %if.end53.if.end123_crit_edge ], [ %tmp67, %if.then63 ], [ %tmp67, %if.end123.loopexit ]
  %tmp144 = phi i32 [ %tmp144.pre, %if.end53.if.end123_crit_edge ], [ %tmp66, %if.then63 ], [ %tmp66, %if.end123.loopexit ]
  %quotient58.1 = phi i16 [ 0, %if.end53.if.end123_crit_edge ], [ 0, %if.then63 ], [ %add114.lcssa, %if.end123.loopexit ]
  %conv125 = zext i16 %quotient58.1 to i32
  %add126 = add nsw i32 %conv125, 1
  store i32 %add126, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 1), align 4
  %tmp127 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 0), align 4
  store i32 %tmp127, i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_R, i32 0, i32 3, i32 2), align 4
  %tmp146 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_T, i32 0, i32 3, i32 2), align 4
  %tmp150 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 1), align 4
  %tmp154 = load i32* getelementptr inbounds (%struct.__TensorDescriptor* @desc_K, i32 0, i32 3, i32 3), align 4
  %conv181 = zext i16 %call to i32
  %conv184459 = zext i16 %call3 to i32
  %add185460 = add nsw i32 %conv184459, 1
  %cmp186461 = icmp ult i32 %conv181, %add185460
  br i1 %cmp186461, label %bb.nph466, label %for.end377

bb.nph466:                                        ; preds = %if.end123
  %conv194 = zext i16 %call1 to i32
  %conv198448 = zext i16 %call4 to i32
  %add199449 = add nsw i32 %conv198448, 1
  %cmp200450 = icmp ult i32 %conv194, %add199449
  %conv209 = zext i16 %call2 to i32
  %conv213437 = zext i16 %call5 to i32
  %add214438 = add nsw i32 %conv213437, 1
  %cmp215439 = icmp ult i32 %conv209, %add214438
  %cmp222424 = icmp sgt i32 %tmp150, 0
  %tmp3 = zext i16 %call5 to i32
  %tmp4 = add i32 %tmp3, 1
  %tmp5 = zext i16 %call2 to i32
  %tmp6 = add i32 %tmp5, 1
  %tmp7 = icmp ugt i32 %tmp4, %tmp6
  %umax = select i1 %tmp7, i32 %tmp4, i32 %tmp6
  %tmp10 = sub i32 %umax, %tmp5
  %tmp13 = mul i32 %tmp150, %tmp5
  %tmp40 = zext i16 %call4 to i32
  %tmp41 = add i32 %tmp40, 1
  %tmp42 = zext i16 %call1 to i32
  %tmp43 = add i32 %tmp42, 1
  %tmp44 = icmp ugt i32 %tmp41, %tmp43
  %umax45 = select i1 %tmp44, i32 %tmp41, i32 %tmp43
  %tmp46 = sub i32 %umax45, %tmp42
  %tmp73 = zext i8 %tmp to i32
  %tmp75 = mul i32 %tmp42, %tmp73
  %tmp84 = zext i16 %call3 to i32
  %tmp85 = add i32 %tmp84, 1
  %tmp86 = zext i16 %call to i32
  %tmp87 = add i32 %tmp86, 1
  %tmp88 = icmp ugt i32 %tmp85, %tmp87
  %umax89 = select i1 %tmp88, i32 %tmp85, i32 %tmp87
  %tmp90 = sub i32 %umax89, %tmp86
  %tmp92 = zext i8 %tmp to i32
  %tmp94 = mul i32 %tmp86, %tmp92
  %tmp98 = zext i16 %quotient58.1 to i32
  %tmp99 = add i32 %tmp98, 1
  %tmp100 = mul i32 %tmp127, %tmp99
  %tmp102 = mul i32 %tmp99, %tmp86
  %tmp103 = zext i16 %call1 to i32
  %tmp104 = add i32 %tmp102, %tmp103
  %tmp105 = mul i32 %tmp127, %tmp104
  %tmp106 = zext i16 %call2 to i32
  %tmp107 = add i32 %tmp105, %tmp106
  %tmp112 = mul i32 %tmp127, 16
  %tmp114 = mul i32 %tmp127, %tmp99
  %tmp115 = mul i32 %tmp114, 16
  %tmp117 = mul i32 %tmp107, 16
  br label %for.body

for.body:                                         ; preds = %for.inc374, %bb.nph466
  %indvar488 = phi i32 [ 0, %bb.nph466 ], [ %indvar.next489, %for.inc374 ]
  %ker_data.4465 = phi i64 [ undef, %bb.nph466 ], [ %ker_data.3.lcssa, %for.inc374 ]
  %img_data.4464 = phi i64 [ undef, %bb.nph466 ], [ %img_data.3.lcssa, %for.inc374 ]
  %count.3463 = phi i32 [ 0, %bb.nph466 ], [ %count.2.lcssa, %for.inc374 ]
  %tmp93 = mul i32 %tmp92, %indvar488
  %tmp95 = add i32 %tmp94, %tmp93
  %tmp101 = mul i32 %tmp100, %indvar488
  %tmp108 = add i32 %tmp107, %tmp101
  %tmp116 = mul i32 %tmp115, %indvar488
  %tmp118 = add i32 %tmp117, %tmp116
  br i1 %cmp200450, label %for.body202.preheader, label %for.inc374

for.body202.preheader:                            ; preds = %for.body
  br label %for.body202

for.body202:                                      ; preds = %for.inc370, %for.body202.preheader
  %indvar484 = phi i32 [ %indvar.next485, %for.inc370 ], [ 0, %for.body202.preheader ]
  %ker_data.3454 = phi i64 [ %ker_data.2.lcssa, %for.inc370 ], [ %ker_data.4465, %for.body202.preheader ]
  %img_data.3453 = phi i64 [ %img_data.2.lcssa, %for.inc370 ], [ %img_data.4464, %for.body202.preheader ]
  %count.2452 = phi i32 [ %count.1.lcssa, %for.inc370 ], [ %count.3463, %for.body202.preheader ]
  %tmp97 = mul i32 %tmp127, %indvar484
  %tmp109 = add i32 %tmp108, %tmp97
  %tmp113 = mul i32 %tmp112, %indvar484
  %tmp119 = add i32 %tmp118, %tmp113
  %tmp74 = mul i32 %tmp73, %indvar484
  %tmp76 = add i32 %tmp75, %tmp74
  br i1 %cmp215439, label %while.cond219.preheader.preheader, label %for.inc370

while.cond219.preheader.preheader:                ; preds = %for.body202
  br label %while.cond219.preheader

while.cond219.preheader:                          ; preds = %while.end336, %while.cond219.preheader.preheader
  %indvar471 = phi i32 [ %indvar.next472, %while.end336 ], [ 0, %while.cond219.preheader.preheader ]
  %ker_data.2443 = phi i64 [ %ker_data.1.lcssa, %while.end336 ], [ %ker_data.3454, %while.cond219.preheader.preheader ]
  %img_data.2442 = phi i64 [ %img_data.1.lcssa, %while.end336 ], [ %img_data.3453, %while.cond219.preheader.preheader ]
  %count.1441 = phi i32 [ %count.0.lcssa, %while.end336 ], [ %count.2452, %while.cond219.preheader.preheader ]
  %add346 = add i32 %tmp109, %indvar471
  %tmp111 = mul i32 %indvar471, 16
  %sub352 = add i32 %tmp119, %tmp111
  %tmp12 = mul i32 %tmp150, %indvar471
  %tmp14 = add i32 %tmp13, %tmp12
  br i1 %cmp222424, label %bb.nph432, label %while.end336

bb.nph432:                                        ; preds = %while.cond219.preheader
  %tmp469 = add i32 %count.1441, 1
  br label %while.body224

while.body224:                                    ; preds = %if.end333, %bb.nph432
  %indvar = phi i32 [ 0, %bb.nph432 ], [ %indvar.next, %if.end333 ]
  %result_temp.0431 = phi i16 [ 0, %bb.nph432 ], [ %conv316, %if.end333 ]
  %ker_data.1430 = phi i64 [ %ker_data.2443, %bb.nph432 ], [ %ker_data.0, %if.end333 ]
  %img_data.1429 = phi i64 [ %img_data.2442, %bb.nph432 ], [ %img_data.0, %if.end333 ]
  %k.0427 = phi i32 [ 0, %bb.nph432 ], [ %k.4, %if.end333 ]
  %j.1426 = phi i32 [ 0, %bb.nph432 ], [ %j.0, %if.end333 ]
  %i.1425 = phi i32 [ 0, %bb.nph432 ], [ %i.0, %if.end333 ]
  %inc335 = add i32 %tmp469, %indvar
  %count.0428 = add i32 %count.1441, %indvar
  %tmp77 = add i32 %tmp76, %j.1426
  %tmp81 = add i32 %tmp95, %i.1425
  %tmp82 = mul i32 %tmp144, %tmp81
  %tmp386 = add i32 %tmp77, %tmp82
  %tmp387 = mul i32 %tmp386, %tmp146
  %add242 = add nsw i32 %tmp387, %k.0427
  %tmp391 = add i32 %tmp14, %i.1425
  %tmp392 = mul i32 %tmp391, %tmp152
  %tmp390 = add i32 %tmp392, %j.1426
  %tmp393 = mul i32 %tmp390, %tmp154
  %add256 = add nsw i32 %tmp393, %k.0427
  %sub275 = and i32 %count.0428, 3
  %cmp276 = icmp eq i32 %sub275, 0
  br i1 %cmp276, label %if.then278, label %if.end286

if.then278:                                       ; preds = %while.body224
  %shr280 = ashr i32 %add242, 2
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @T, i32 0, i32 0, i32 %shr280
  %tmp281 = load i64* %arrayidx, align 4
  %shr283 = ashr i32 %add256, 2
  %arrayidx284 = getelementptr inbounds %struct.__SizedTensor_16K* @K, i32 0, i32 0, i32 %shr283
  %tmp285 = load i64* %arrayidx284, align 4
  br label %if.end286

if.end286:                                        ; preds = %if.then278, %while.body224
  %img_data.0 = phi i64 [ %tmp281, %if.then278 ], [ %img_data.1429, %while.body224 ]
  %ker_data.0 = phi i64 [ %tmp285, %if.then278 ], [ %ker_data.1430, %while.body224 ]
  %sub262 = shl i32 %add242, 4
  %mul292 = and i32 %sub262, 48
  %sh_prom = zext i32 %mul292 to i64
  %shr293 = lshr i64 %img_data.0, %sh_prom
  %conv294 = trunc i64 %shr293 to i32
  %sub269 = shl i32 %add256, 4
  %mul302 = and i32 %sub269, 48
  %sh_prom303 = zext i32 %mul302 to i64
  %shr304 = lshr i64 %ker_data.0, %sh_prom303
  %conv306 = trunc i64 %shr304 to i32
  %sext = shl i32 %conv294, 16
  %conv309 = ashr i32 %sext, 16
  %sext382 = shl i32 %conv306, 16
  %conv311 = ashr i32 %sext382, 16
  %mul312 = mul nsw i32 %conv311, %conv309
  %conv314383 = zext i16 %result_temp.0431 to i32
  %add315 = add nsw i32 %mul312, %conv314383
  %conv316 = trunc i32 %add315 to i16
  %inc = add nsw i32 %k.0427, 1
  %cmp320 = icmp eq i32 %inc, %tmp154
  br i1 %cmp320, label %if.then322, label %if.end333

if.then322:                                       ; preds = %if.end286
  %inc324 = add nsw i32 %j.1426, 1
  %cmp327 = icmp eq i32 %inc324, %tmp152
  %inc331 = zext i1 %cmp327 to i32
  %inc331.i.1 = add i32 %inc331, %i.1425
  br i1 %cmp327, label %if.then329, label %if.end333

if.then329:                                       ; preds = %if.then322
  br label %if.end333

if.end333:                                        ; preds = %if.then329, %if.then322, %if.end286
  %i.0 = phi i32 [ %inc331.i.1, %if.then329 ], [ %inc331.i.1, %if.then322 ], [ %i.1425, %if.end286 ]
  %j.0 = phi i32 [ 0, %if.then329 ], [ %inc324, %if.then322 ], [ %j.1426, %if.end286 ]
  %k.4 = phi i32 [ 0, %if.then329 ], [ 0, %if.then322 ], [ %inc, %if.end286 ]
  %cmp222 = icmp slt i32 %i.0, %tmp150
  %indvar.next = add i32 %indvar, 1
  br i1 %cmp222, label %while.body224, label %while.cond219.while.end336_crit_edge

while.cond219.while.end336_crit_edge:             ; preds = %if.end333
  %conv316.lcssa = phi i16 [ %conv316, %if.end333 ]
  %ker_data.0.lcssa = phi i64 [ %ker_data.0, %if.end333 ]
  %img_data.0.lcssa = phi i64 [ %img_data.0, %if.end333 ]
  %inc335.lcssa = phi i32 [ %inc335, %if.end333 ]
  %phitmp = sext i16 %conv316.lcssa to i64
  br label %while.end336

while.end336:                                     ; preds = %while.cond219.while.end336_crit_edge, %while.cond219.preheader
  %result_temp.0.lcssa = phi i64 [ %phitmp, %while.cond219.while.end336_crit_edge ], [ 0, %while.cond219.preheader ]
  %ker_data.1.lcssa = phi i64 [ %ker_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %ker_data.2443, %while.cond219.preheader ]
  %img_data.1.lcssa = phi i64 [ %img_data.0.lcssa, %while.cond219.while.end336_crit_edge ], [ %img_data.2442, %while.cond219.preheader ]
  %count.0.lcssa = phi i32 [ %inc335.lcssa, %while.cond219.while.end336_crit_edge ], [ %count.1441, %while.cond219.preheader ]
  %shr355 = ashr i32 %add346, 2
  %arrayidx356 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i32 0, i32 0, i32 %shr355
  %tmp357 = load i64* %arrayidx356, align 4
  %mul362 = and i32 %sub352, 48
  %sh_prom363 = zext i32 %mul362 to i64
  %shl364 = shl i64 %result_temp.0.lcssa, %sh_prom363
  %or = or i64 %tmp357, %shl364
  store i64 %or, i64* %arrayidx356, align 4
  %indvar.next472 = add i32 %indvar471, 1
  %exitcond11 = icmp eq i32 %indvar.next472, %tmp10
  br i1 %exitcond11, label %for.inc370.loopexit, label %while.cond219.preheader

for.inc370.loopexit:                              ; preds = %while.end336
  %count.0.lcssa.lcssa = phi i32 [ %count.0.lcssa, %while.end336 ]
  %img_data.1.lcssa.lcssa = phi i64 [ %img_data.1.lcssa, %while.end336 ]
  %ker_data.1.lcssa.lcssa = phi i64 [ %ker_data.1.lcssa, %while.end336 ]
  br label %for.inc370

for.inc370:                                       ; preds = %for.inc370.loopexit, %for.body202
  %ker_data.2.lcssa = phi i64 [ %ker_data.3454, %for.body202 ], [ %ker_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %img_data.2.lcssa = phi i64 [ %img_data.3453, %for.body202 ], [ %img_data.1.lcssa.lcssa, %for.inc370.loopexit ]
  %count.1.lcssa = phi i32 [ %count.2452, %for.body202 ], [ %count.0.lcssa.lcssa, %for.inc370.loopexit ]
  %indvar.next485 = add i32 %indvar484, 1
  %exitcond = icmp eq i32 %indvar.next485, %tmp46
  br i1 %exitcond, label %for.inc374.loopexit, label %for.body202

for.inc374.loopexit:                              ; preds = %for.inc370
  %count.1.lcssa.lcssa = phi i32 [ %count.1.lcssa, %for.inc370 ]
  %img_data.2.lcssa.lcssa = phi i64 [ %img_data.2.lcssa, %for.inc370 ]
  %ker_data.2.lcssa.lcssa = phi i64 [ %ker_data.2.lcssa, %for.inc370 ]
  br label %for.inc374

for.inc374:                                       ; preds = %for.inc374.loopexit, %for.body
  %ker_data.3.lcssa = phi i64 [ %ker_data.4465, %for.body ], [ %ker_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %img_data.3.lcssa = phi i64 [ %img_data.4464, %for.body ], [ %img_data.2.lcssa.lcssa, %for.inc374.loopexit ]
  %count.2.lcssa = phi i32 [ %count.3463, %for.body ], [ %count.1.lcssa.lcssa, %for.inc374.loopexit ]
  %indvar.next489 = add i32 %indvar488, 1
  %exitcond91 = icmp eq i32 %indvar.next489, %tmp90
  br i1 %exitcond91, label %for.end377.loopexit, label %for.body

for.end377.loopexit:                              ; preds = %for.inc374
  br label %for.end377

for.end377:                                       ; preds = %for.end377.loopexit, %if.end123
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str11, i32 0, i32 0), i16 zeroext 1) nounwind
  ret void
}

define void @conv2D() nounwind {
entry:
  tail call void @getInput()
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call = tail call i32 (...)* @timer() nounwind
  %conv = sext i32 %call to i64
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str2, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 1) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 1) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str4, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 2) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 2) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str6, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 3) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 3) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str8, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 4) nounwind
  tail call void @write_uint16(i8* getelementptr inbounds ([15 x i8]* @.str10, i32 0, i32 0), i16 zeroext 0) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call31 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str3, i32 0, i32 0)) nounwind
  %call34 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str5, i32 0, i32 0)) nounwind
  %call37 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str7, i32 0, i32 0)) nounwind
  %call40 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str9, i32 0, i32 0)) nounwind
  %call43 = tail call zeroext i16 @read_uint16(i8* getelementptr inbounds ([15 x i8]* @.str11, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call46 = tail call i32 (...)* @timer() nounwind
  %conv47 = sext i32 %call46 to i64
  %sub = sub i64 %conv47, %conv
  tail call void @write_uint64(i8* getelementptr inbounds ([18 x i8]* @.str12, i32 0, i32 0), i64 %sub) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @sendOutput()
  ret void
}

declare i32 @timer(...)

declare void @write_uint64(i8*, i64)
