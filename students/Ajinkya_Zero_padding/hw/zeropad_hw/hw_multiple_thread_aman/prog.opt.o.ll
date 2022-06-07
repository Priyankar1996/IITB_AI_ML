; ModuleID = 'prog.opt.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.__SizedTensor_16K = type { [16384 x i64] }
%struct.__TensorDescriptor = type { i32, i32, i32, [64 x i32] }

@R = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@.str = private constant [20 x i8] c"zeropad_output_pipe\00"
@.str1 = private constant [16 x i8] c"Block0_starting\00"
@T = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@.str2 = private constant [16 x i8] c"Block0_complete\00"
@.str3 = private constant [16 x i8] c"Block1_starting\00"
@.str4 = private constant [16 x i8] c"Block1_complete\00"
@.str5 = private constant [16 x i8] c"Block2_starting\00"
@.str6 = private constant [16 x i8] c"Block2_complete\00"
@.str7 = private constant [16 x i8] c"Block3_starting\00"
@.str8 = private constant [16 x i8] c"Block3_complete\00"
@.str9 = private constant [19 x i8] c"zeropad_input_pipe\00"
@.str10 = private constant [18 x i8] c"elapsed_time_pipe\00"
@des_inp = common global %struct.__TensorDescriptor zeroinitializer, align 4
@des_out = common global %struct.__TensorDescriptor zeroinitializer, align 4

define void @sendOutput(i32 %size) nounwind {
entry:
  %shr67 = ashr i32 %size, 2
  %cmp68 = icmp sgt i32 %shr67, 0
  br i1 %cmp68, label %bb.nph, label %for.end

bb.nph:                                           ; preds = %entry
  %tmp1 = zext i32 %shr67 to i64
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %arrayidx = getelementptr %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %indvar
  %tmp4 = load i64* %arrayidx, align 8
  %conv = trunc i64 %tmp4 to i8
  %shr9 = lshr i64 %tmp4, 8
  %conv12 = trunc i64 %shr9 to i8
  %shr15 = lshr i64 %tmp4, 16
  %conv18 = trunc i64 %shr15 to i8
  %shr21 = lshr i64 %tmp4, 24
  %conv24 = trunc i64 %shr21 to i8
  %shr27 = lshr i64 %tmp4, 32
  %conv30 = trunc i64 %shr27 to i8
  %shr33 = lshr i64 %tmp4, 40
  %conv36 = trunc i64 %shr33 to i8
  %shr39 = lshr i64 %tmp4, 48
  %conv42 = trunc i64 %shr39 to i8
  %shr45 = lshr i64 %tmp4, 56
  %conv48 = trunc i64 %shr45 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv48) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv42) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv36) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv30) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv24) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv18) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv12) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([20 x i8]* @.str, i64 0, i64 0), i8 zeroext %conv) nounwind
  %indvar.next = add i64 %indvar, 1
  %exitcond2 = icmp eq i64 %indvar.next, %tmp1
  br i1 %exitcond2, label %for.end.loopexit, label %for.body

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

declare void @write_uint8(i8*, i8 zeroext)

define void @zeropad3D_A() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  %call6 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv27 = zext i8 %call2 to i32
  %conv29 = zext i8 %call1 to i32
  %conv33 = zext i8 %call5 to i32
  %conv35 = zext i8 %call4 to i32
  %mul36 = shl i32 %conv35, 16
  %sext = mul i32 %mul36, %conv33
  %conv90 = ashr i32 %sext, 16
  %conv104 = zext i8 %call6 to i32
  %mul = shl i32 %conv29, 16
  %sext171 = mul i32 %mul, %conv27
  %conv108 = ashr i32 %sext171, 16
  %conv126 = zext i8 %call to i32
  %div127 = lshr i32 %conv126, 1
  %add130 = add nsw i32 %conv104, %div127
  %div145 = lshr i32 %conv29, 1
  %add148 = add nsw i32 %conv104, %div145
  %shl = shl i32 %conv104, 1
  %add58 = add nsw i32 %shl, %div145
  %add73 = add nsw i32 %shl, %div127
  br label %while.body

while.body:                                       ; preds = %if.end166, %entry
  %k.1 = phi i16 [ 0, %entry ], [ %k.0, %if.end166 ]
  %i.2 = phi i16 [ 0, %entry ], [ %i.1, %if.end166 ]
  %j.1 = phi i16 [ 0, %entry ], [ %j.0, %if.end166 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv43 = sext i16 %k.1 to i32
  %add = add nsw i32 %conv43, 4
  %cmp = icmp slt i32 %add, %conv27
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %add49 = add i16 %k.1, 4
  br label %if.end78

if.else:                                          ; preds = %while.body
  %inc = add nsw i16 %j.1, 1
  %conv53 = sext i16 %inc to i32
  %cmp59 = icmp eq i32 %conv53, %add58
  %inc64 = zext i1 %cmp59 to i16
  %inc64.i.2 = add i16 %inc64, %i.2
  %j.2 = select i1 %cmp59, i16 0, i16 %inc
  %conv66 = sext i16 %inc64.i.2 to i32
  %cmp74 = icmp eq i32 %conv66, %add73
  br i1 %cmp74, label %if.then76, label %if.end78

if.then76:                                        ; preds = %if.else
  br label %if.end78

if.end78:                                         ; preds = %if.then76, %if.else, %if.then
  %k.0 = phi i16 [ %add49, %if.then ], [ 0, %if.then76 ], [ 0, %if.else ]
  %i.1 = phi i16 [ %i.2, %if.then ], [ %inc64.i.2, %if.then76 ], [ %inc64.i.2, %if.else ]
  %j.0 = phi i16 [ %j.1, %if.then ], [ %j.2, %if.then76 ], [ %j.2, %if.else ]
  %flag.0 = phi i16 [ 0, %if.then ], [ 1, %if.then76 ], [ 0, %if.else ]
  %conv82170 = zext i16 %k.0 to i32
  %conv86 = sext i16 %j.0 to i32
  %mul87 = mul nsw i32 %conv86, %conv33
  %conv92 = sext i16 %i.1 to i32
  %mul93 = mul nsw i32 %conv92, %conv90
  %add88 = add nsw i32 %mul93, %conv82170
  %add94 = add nsw i32 %add88, %mul87
  %conv95 = trunc i32 %add94 to i16
  %sub = sub nsw i32 %conv86, %conv104
  %mul105 = mul nsw i32 %sub, %conv27
  %sub113 = sub nsw i32 %conv92, %conv104
  %mul114 = mul nsw i32 %sub113, %conv108
  %add106 = add nsw i32 %mul114, %conv82170
  %add115 = add nsw i32 %add106, %mul105
  %cmp121 = icmp slt i32 %conv92, %conv104
  %cmp121.not = xor i1 %cmp121, true
  %cmp131 = icmp slt i32 %conv92, %add130
  %or.cond = and i1 %cmp121.not, %cmp131
  %or.cond.not = xor i1 %or.cond, true
  %cmp138 = icmp slt i32 %conv86, %conv104
  %or.cond175 = or i1 %or.cond.not, %cmp138
  %or.cond175.not = xor i1 %or.cond175, true
  %cmp149 = icmp slt i32 %conv86, %add148
  %or.cond176 = and i1 %or.cond175.not, %cmp149
  br i1 %or.cond176, label %if.else154, label %if.then151

if.then151:                                       ; preds = %if.end78
  %conv153 = sext i16 %conv95 to i32
  %shr = ashr i32 %conv153, 2
  %idxprom = sext i32 %shr to i64
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom
  store i64 0, i64* %arrayidx, align 8
  br label %if.end166

if.else154:                                       ; preds = %if.end78
  %sext173 = shl i32 %add115, 16
  %shr157 = ashr i32 %sext173, 18
  %idxprom158 = sext i32 %shr157 to i64
  %arrayidx159 = getelementptr inbounds %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %idxprom158
  %tmp160 = load i64* %arrayidx159, align 8
  %conv162 = sext i16 %conv95 to i32
  %shr163 = ashr i32 %conv162, 2
  %idxprom164 = sext i32 %shr163 to i64
  %arrayidx165 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom164
  store i64 %tmp160, i64* %arrayidx165, align 8
  br label %if.end166

if.end166:                                        ; preds = %if.else154, %if.then151
  %tobool = icmp eq i16 %flag.0, 0
  br i1 %tobool, label %while.body, label %while.end

while.end:                                        ; preds = %if.end166
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str2, i64 0, i64 0), i8 zeroext 1) nounwind
  ret void
}

declare zeroext i8 @read_uint8(i8*)

declare void @__aa_barrier__(...)

declare void @__loop_pipelining_on__(i32, i32, i32)

define void @zeropad3D_B() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  %call6 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv = zext i8 %call1 to i16
  %div = lshr i16 %conv, 1
  %conv32 = zext i8 %call2 to i32
  %conv34 = zext i8 %call1 to i32
  %conv38 = zext i8 %call5 to i32
  %conv40 = zext i8 %call4 to i32
  %mul41 = shl i32 %conv40, 16
  %sext = mul i32 %mul41, %conv38
  %conv95 = ashr i32 %sext, 16
  %conv109 = zext i8 %call6 to i32
  %mul = shl i32 %conv34, 16
  %sext175 = mul i32 %mul, %conv32
  %conv113 = ashr i32 %sext175, 16
  %conv131 = zext i8 %call to i32
  %div132 = lshr i32 %conv131, 1
  %add135 = add nsw i32 %conv109, %div132
  %add152 = add nsw i32 %conv109, %conv34
  %shl = shl i32 %conv109, 1
  %add63 = add nsw i32 %shl, %conv34
  %add78 = add nsw i32 %shl, %div132
  br label %while.body

while.body:                                       ; preds = %if.end170, %entry
  %k.1 = phi i16 [ 0, %entry ], [ %k.0, %if.end170 ]
  %i.2 = phi i16 [ 0, %entry ], [ %i.1, %if.end170 ]
  %j.1 = phi i16 [ %div, %entry ], [ %j.0, %if.end170 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv48 = sext i16 %k.1 to i32
  %add = add nsw i32 %conv48, 4
  %cmp = icmp slt i32 %add, %conv32
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %add54 = add i16 %k.1, 4
  br label %if.end83

if.else:                                          ; preds = %while.body
  %inc = add nsw i16 %j.1, 1
  %conv58 = sext i16 %inc to i32
  %cmp64 = icmp eq i32 %conv58, %add63
  %inc69 = zext i1 %cmp64 to i16
  %inc69.i.2 = add i16 %inc69, %i.2
  %j.2 = select i1 %cmp64, i16 %div, i16 %inc
  %conv71 = sext i16 %inc69.i.2 to i32
  %cmp79 = icmp eq i32 %conv71, %add78
  br i1 %cmp79, label %if.then81, label %if.end83

if.then81:                                        ; preds = %if.else
  br label %if.end83

if.end83:                                         ; preds = %if.then81, %if.else, %if.then
  %k.0 = phi i16 [ %add54, %if.then ], [ 0, %if.then81 ], [ 0, %if.else ]
  %i.1 = phi i16 [ %i.2, %if.then ], [ %inc69.i.2, %if.then81 ], [ %inc69.i.2, %if.else ]
  %j.0 = phi i16 [ %j.1, %if.then ], [ %j.2, %if.then81 ], [ %j.2, %if.else ]
  %flag.0 = phi i16 [ 0, %if.then ], [ 1, %if.then81 ], [ 0, %if.else ]
  %conv87174 = zext i16 %k.0 to i32
  %conv91 = sext i16 %j.0 to i32
  %mul92 = mul nsw i32 %conv91, %conv38
  %conv97 = sext i16 %i.1 to i32
  %mul98 = mul nsw i32 %conv97, %conv95
  %add93 = add nsw i32 %mul98, %conv87174
  %add99 = add nsw i32 %add93, %mul92
  %conv100 = trunc i32 %add99 to i16
  %sub = sub nsw i32 %conv91, %conv109
  %mul110 = mul nsw i32 %sub, %conv32
  %sub118 = sub nsw i32 %conv97, %conv109
  %mul119 = mul nsw i32 %sub118, %conv113
  %add111 = add nsw i32 %mul119, %conv87174
  %add120 = add nsw i32 %add111, %mul110
  %cmp126 = icmp slt i32 %conv97, %conv109
  %cmp126.not = xor i1 %cmp126, true
  %cmp136 = icmp slt i32 %conv97, %add135
  %or.cond = and i1 %cmp126.not, %cmp136
  %or.cond.not = xor i1 %or.cond, true
  %cmp143 = icmp slt i32 %conv91, %conv109
  %or.cond179 = or i1 %or.cond.not, %cmp143
  %or.cond179.not = xor i1 %or.cond179, true
  %cmp153 = icmp slt i32 %conv91, %add152
  %or.cond180 = and i1 %or.cond179.not, %cmp153
  br i1 %or.cond180, label %if.else158, label %if.then155

if.then155:                                       ; preds = %if.end83
  %conv157 = sext i16 %conv100 to i32
  %shr = ashr i32 %conv157, 2
  %idxprom = sext i32 %shr to i64
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom
  store i64 0, i64* %arrayidx, align 8
  br label %if.end170

if.else158:                                       ; preds = %if.end83
  %sext177 = shl i32 %add120, 16
  %shr161 = ashr i32 %sext177, 18
  %idxprom162 = sext i32 %shr161 to i64
  %arrayidx163 = getelementptr inbounds %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %idxprom162
  %tmp164 = load i64* %arrayidx163, align 8
  %conv166 = sext i16 %conv100 to i32
  %shr167 = ashr i32 %conv166, 2
  %idxprom168 = sext i32 %shr167 to i64
  %arrayidx169 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom168
  store i64 %tmp164, i64* %arrayidx169, align 8
  br label %if.end170

if.end170:                                        ; preds = %if.else158, %if.then155
  %tobool = icmp eq i16 %flag.0, 0
  br i1 %tobool, label %while.body, label %while.end

while.end:                                        ; preds = %if.end170
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str4, i64 0, i64 0), i8 zeroext 1) nounwind
  ret void
}

define void @zeropad3D_C() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  %call6 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv = zext i8 %call to i16
  %div = lshr i16 %conv, 1
  %conv31 = zext i8 %call2 to i32
  %conv33 = zext i8 %call1 to i32
  %conv37 = zext i8 %call5 to i32
  %conv39 = zext i8 %call4 to i32
  %mul40 = shl i32 %conv39, 16
  %sext = mul i32 %mul40, %conv37
  %conv94 = ashr i32 %sext, 16
  %conv108 = zext i8 %call6 to i32
  %mul = shl i32 %conv33, 16
  %sext174 = mul i32 %mul, %conv31
  %conv112 = ashr i32 %sext174, 16
  %conv130 = zext i8 %call to i32
  %add133 = add nsw i32 %conv108, %conv130
  %div148 = lshr i32 %conv33, 1
  %add151 = add nsw i32 %conv108, %div148
  %shl = shl i32 %conv108, 1
  %add63 = add nsw i32 %shl, %div148
  %add77 = add nsw i32 %shl, %conv130
  br label %while.body

while.body:                                       ; preds = %if.end169, %entry
  %k.1 = phi i16 [ 0, %entry ], [ %k.0, %if.end169 ]
  %i.2 = phi i16 [ %div, %entry ], [ %i.1, %if.end169 ]
  %j.1 = phi i16 [ 0, %entry ], [ %j.0, %if.end169 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv47 = sext i16 %k.1 to i32
  %add = add nsw i32 %conv47, 4
  %cmp = icmp slt i32 %add, %conv31
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %add53 = add i16 %k.1, 4
  br label %if.end82

if.else:                                          ; preds = %while.body
  %inc = add nsw i16 %j.1, 1
  %conv57 = sext i16 %inc to i32
  %cmp64 = icmp eq i32 %conv57, %add63
  %inc69 = zext i1 %cmp64 to i16
  %inc69.i.2 = add i16 %inc69, %i.2
  %j.2 = select i1 %cmp64, i16 0, i16 %inc
  %conv71 = sext i16 %inc69.i.2 to i32
  %cmp78 = icmp eq i32 %conv71, %add77
  br i1 %cmp78, label %if.then80, label %if.end82

if.then80:                                        ; preds = %if.else
  br label %if.end82

if.end82:                                         ; preds = %if.then80, %if.else, %if.then
  %k.0 = phi i16 [ %add53, %if.then ], [ 0, %if.then80 ], [ 0, %if.else ]
  %i.1 = phi i16 [ %i.2, %if.then ], [ %inc69.i.2, %if.then80 ], [ %inc69.i.2, %if.else ]
  %j.0 = phi i16 [ %j.1, %if.then ], [ %j.2, %if.then80 ], [ %j.2, %if.else ]
  %flag.0 = phi i16 [ 0, %if.then ], [ 1, %if.then80 ], [ 0, %if.else ]
  %conv86173 = zext i16 %k.0 to i32
  %conv90 = sext i16 %j.0 to i32
  %mul91 = mul nsw i32 %conv90, %conv37
  %conv96 = sext i16 %i.1 to i32
  %mul97 = mul nsw i32 %conv96, %conv94
  %add92 = add nsw i32 %mul97, %conv86173
  %add98 = add nsw i32 %add92, %mul91
  %conv99 = trunc i32 %add98 to i16
  %sub = sub nsw i32 %conv90, %conv108
  %mul109 = mul nsw i32 %sub, %conv31
  %sub117 = sub nsw i32 %conv96, %conv108
  %mul118 = mul nsw i32 %sub117, %conv112
  %add110 = add nsw i32 %mul118, %conv86173
  %add119 = add nsw i32 %add110, %mul109
  %cmp125 = icmp slt i32 %conv96, %conv108
  %cmp125.not = xor i1 %cmp125, true
  %cmp134 = icmp slt i32 %conv96, %add133
  %or.cond = and i1 %cmp125.not, %cmp134
  %or.cond.not = xor i1 %or.cond, true
  %cmp141 = icmp slt i32 %conv90, %conv108
  %or.cond178 = or i1 %or.cond.not, %cmp141
  %or.cond178.not = xor i1 %or.cond178, true
  %cmp152 = icmp slt i32 %conv90, %add151
  %or.cond179 = and i1 %or.cond178.not, %cmp152
  br i1 %or.cond179, label %if.else157, label %if.then154

if.then154:                                       ; preds = %if.end82
  %conv156 = sext i16 %conv99 to i32
  %shr = ashr i32 %conv156, 2
  %idxprom = sext i32 %shr to i64
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom
  store i64 0, i64* %arrayidx, align 8
  br label %if.end169

if.else157:                                       ; preds = %if.end82
  %sext176 = shl i32 %add119, 16
  %shr160 = ashr i32 %sext176, 18
  %idxprom161 = sext i32 %shr160 to i64
  %arrayidx162 = getelementptr inbounds %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %idxprom161
  %tmp163 = load i64* %arrayidx162, align 8
  %conv165 = sext i16 %conv99 to i32
  %shr166 = ashr i32 %conv165, 2
  %idxprom167 = sext i32 %shr166 to i64
  %arrayidx168 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom167
  store i64 %tmp163, i64* %arrayidx168, align 8
  br label %if.end169

if.end169:                                        ; preds = %if.else157, %if.then154
  %tobool = icmp eq i16 %flag.0, 0
  br i1 %tobool, label %while.body, label %while.end

while.end:                                        ; preds = %if.end169
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str6, i64 0, i64 0), i8 zeroext 1) nounwind
  ret void
}

define void @zeropad3D_D() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  %call6 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv = zext i8 %call1 to i16
  %div = lshr i16 %conv, 1
  %conv10 = zext i8 %call to i16
  %div11 = lshr i16 %conv10, 1
  %conv36 = zext i8 %call2 to i32
  %conv38 = zext i8 %call1 to i32
  %conv42 = zext i8 %call5 to i32
  %conv44 = zext i8 %call4 to i32
  %mul45 = shl i32 %conv44, 16
  %sext = mul i32 %mul45, %conv42
  %conv98 = ashr i32 %sext, 16
  %conv112 = zext i8 %call6 to i32
  %mul = shl i32 %conv38, 16
  %sext177 = mul i32 %mul, %conv36
  %conv116 = ashr i32 %sext177, 16
  %conv134 = zext i8 %call to i32
  %add137 = add nsw i32 %conv112, %conv134
  %add154 = add nsw i32 %conv112, %conv38
  %shl = shl i32 %conv112, 1
  %add67 = add nsw i32 %shl, %conv38
  %add81 = add nsw i32 %shl, %conv134
  br label %while.body

while.body:                                       ; preds = %if.end172, %entry
  %k.1 = phi i16 [ 0, %entry ], [ %k.0, %if.end172 ]
  %i.2 = phi i16 [ %div11, %entry ], [ %i.1, %if.end172 ]
  %j.1 = phi i16 [ %div, %entry ], [ %j.0, %if.end172 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv52 = sext i16 %k.1 to i32
  %add = add nsw i32 %conv52, 4
  %cmp = icmp slt i32 %add, %conv36
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %add58 = add i16 %k.1, 4
  br label %if.end86

if.else:                                          ; preds = %while.body
  %inc = add nsw i16 %j.1, 1
  %conv62 = sext i16 %inc to i32
  %cmp68 = icmp eq i32 %conv62, %add67
  %inc73 = zext i1 %cmp68 to i16
  %inc73.i.2 = add i16 %inc73, %i.2
  %j.2 = select i1 %cmp68, i16 %div, i16 %inc
  %conv75 = sext i16 %inc73.i.2 to i32
  %cmp82 = icmp eq i32 %conv75, %add81
  br i1 %cmp82, label %if.then84, label %if.end86

if.then84:                                        ; preds = %if.else
  br label %if.end86

if.end86:                                         ; preds = %if.then84, %if.else, %if.then
  %k.0 = phi i16 [ %add58, %if.then ], [ 0, %if.then84 ], [ 0, %if.else ]
  %i.1 = phi i16 [ %i.2, %if.then ], [ %inc73.i.2, %if.then84 ], [ %inc73.i.2, %if.else ]
  %j.0 = phi i16 [ %j.1, %if.then ], [ %j.2, %if.then84 ], [ %j.2, %if.else ]
  %flag.0 = phi i16 [ 0, %if.then ], [ 1, %if.then84 ], [ 0, %if.else ]
  %conv90176 = zext i16 %k.0 to i32
  %conv94 = sext i16 %j.0 to i32
  %mul95 = mul nsw i32 %conv94, %conv42
  %conv100 = sext i16 %i.1 to i32
  %mul101 = mul nsw i32 %conv100, %conv98
  %add96 = add nsw i32 %mul101, %conv90176
  %add102 = add nsw i32 %add96, %mul95
  %conv103 = trunc i32 %add102 to i16
  %sub = sub nsw i32 %conv94, %conv112
  %mul113 = mul nsw i32 %sub, %conv36
  %sub121 = sub nsw i32 %conv100, %conv112
  %mul122 = mul nsw i32 %sub121, %conv116
  %add114 = add nsw i32 %mul122, %conv90176
  %add123 = add nsw i32 %add114, %mul113
  %cmp129 = icmp slt i32 %conv100, %conv112
  %cmp129.not = xor i1 %cmp129, true
  %cmp138 = icmp slt i32 %conv100, %add137
  %or.cond = and i1 %cmp129.not, %cmp138
  %or.cond.not = xor i1 %or.cond, true
  %cmp145 = icmp slt i32 %conv94, %conv112
  %or.cond181 = or i1 %or.cond.not, %cmp145
  %or.cond181.not = xor i1 %or.cond181, true
  %cmp155 = icmp slt i32 %conv94, %add154
  %or.cond182 = and i1 %or.cond181.not, %cmp155
  br i1 %or.cond182, label %if.else160, label %if.then157

if.then157:                                       ; preds = %if.end86
  %conv159 = sext i16 %conv103 to i32
  %shr = ashr i32 %conv159, 2
  %idxprom = sext i32 %shr to i64
  %arrayidx = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom
  store i64 0, i64* %arrayidx, align 8
  br label %if.end172

if.else160:                                       ; preds = %if.end86
  %sext179 = shl i32 %add123, 16
  %shr163 = ashr i32 %sext179, 18
  %idxprom164 = sext i32 %shr163 to i64
  %arrayidx165 = getelementptr inbounds %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %idxprom164
  %tmp166 = load i64* %arrayidx165, align 8
  %conv168 = sext i16 %conv103 to i32
  %shr169 = ashr i32 %conv168, 2
  %idxprom170 = sext i32 %shr169 to i64
  %arrayidx171 = getelementptr inbounds %struct.__SizedTensor_16K* @R, i64 0, i32 0, i64 %idxprom170
  store i64 %tmp166, i64* %arrayidx171, align 8
  br label %if.end172

if.end172:                                        ; preds = %if.else160, %if.then157
  %tobool = icmp eq i16 %flag.0, 0
  br i1 %tobool, label %while.body, label %while.end

while.end:                                        ; preds = %if.end172
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str8, i64 0, i64 0), i8 zeroext 1) nounwind
  ret void
}

define void @zeropad3D() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call4 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call6 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call7 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %call8 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv = zext i8 %call2 to i64
  %conv10 = zext i8 %call3 to i64
  %conv12 = zext i8 %call4 to i64
  %mul = mul i64 %conv10, %conv
  %mul13 = mul i64 %mul, %conv12
  %shr125.mask = and i64 %mul13, 16777212
  %cmp126 = icmp eq i64 %shr125.mask, 0
  br i1 %cmp126, label %for.end, label %bb.nph

bb.nph:                                           ; preds = %entry
  %tmp = zext i8 %call3 to i64
  %tmp1 = zext i8 %call2 to i64
  %tmp2 = mul i64 %tmp, %tmp1
  %tmp3 = zext i8 %call4 to i64
  %tmp4 = mul i64 %tmp2, %tmp3
  %tmp5 = lshr i64 %tmp4, 2
  %tmp6 = icmp ugt i64 %tmp5, 1
  %umax7 = select i1 %tmp6, i64 %tmp5, i64 1
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %arrayidx = getelementptr %struct.__SizedTensor_16K* @T, i64 0, i32 0, i64 %indvar
  %call20 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv21 = zext i8 %call20 to i64
  %shl = shl i64 %conv21, 8
  %call23 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv25 = zext i8 %call23 to i64
  %add = or i64 %shl, %conv25
  %shl27 = shl i64 %add, 8
  %call28 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv30 = zext i8 %call28 to i64
  %add31 = or i64 %shl27, %conv30
  %shl33 = shl i64 %add31, 8
  %call34 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv36 = zext i8 %call34 to i64
  %add37 = or i64 %shl33, %conv36
  %shl39 = shl i64 %add37, 8
  %call40 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv42 = zext i8 %call40 to i64
  %add43 = or i64 %shl39, %conv42
  %shl45 = shl i64 %add43, 8
  %call46 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv48 = zext i8 %call46 to i64
  %add49 = or i64 %shl45, %conv48
  %shl51 = shl i64 %add49, 8
  %call52 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv54 = zext i8 %call52 to i64
  %add55 = or i64 %shl51, %conv54
  %shl57 = shl i64 %add55, 8
  %call58 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([19 x i8]* @.str9, i64 0, i64 0)) nounwind
  %conv60 = zext i8 %call58 to i64
  %add61 = or i64 %shl57, %conv60
  store i64 %add61, i64* %arrayidx, align 8
  %indvar.next = add i64 %indvar, 1
  %exitcond8 = icmp eq i64 %indvar.next, %umax7
  br i1 %exitcond8, label %for.end.loopexit, label %for.body

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  tail call void (...)* @__aa_barrier__() nounwind
  %call66 = tail call i32 (...)* @timer() nounwind
  %conv67 = sext i32 %call66 to i64
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call3) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call4) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call6) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call7) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8 zeroext %call5) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call3) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call4) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call6) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call7) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0), i8 zeroext %call5) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call3) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call4) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call6) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call7) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str5, i64 0, i64 0), i8 zeroext %call5) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call2) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call3) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call4) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call6) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call7) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call8) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([16 x i8]* @.str7, i64 0, i64 0), i8 zeroext %call5) nounwind
  %call97 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str2, i64 0, i64 0)) nounwind
  %call100 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str4, i64 0, i64 0)) nounwind
  %call103 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str6, i64 0, i64 0)) nounwind
  %call106 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([16 x i8]* @.str8, i64 0, i64 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call109 = tail call i32 (...)* @timer() nounwind
  %conv110 = sext i32 %call109 to i64
  %sub = sub i64 %conv110, %conv67
  tail call void @write_uint64(i8* getelementptr inbounds ([18 x i8]* @.str10, i64 0, i64 0), i64 %sub) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv116 = zext i8 %call6 to i32
  %conv118 = zext i8 %call7 to i32
  %conv121 = zext i8 %call8 to i32
  %mul119 = mul nsw i32 %conv118, %conv116
  %mul122 = mul nsw i32 %mul119, %conv121
  tail call void @sendOutput(i32 %mul122) nounwind
  ret void
}

declare i32 @timer(...)

declare void @write_uint64(i8*, i64)
