; ModuleID = 'prog.opt.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.__SizedTensor_16K = type { [16384 x i64] }

@.str = private constant [18 x i8] c"Concat_input_pipe\00"
@input_1 = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@input_2 = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@output = common global %struct.__SizedTensor_16K zeroinitializer, align 8
@.str1 = private constant [19 x i8] c"Concat_output_pipe\00"

define void @concat() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv1 = zext i8 %call to i32
  %shl = shl i32 %conv1, 8
  %call2 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv3 = zext i8 %call2 to i32
  %add = or i32 %shl, %conv3
  %call5 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv8 = zext i8 %call5 to i32
  %shl9 = shl i32 %conv8, 8
  %call10 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv11 = zext i8 %call10 to i32
  %add12 = or i32 %shl9, %conv11
  %call14 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv17 = zext i8 %call14 to i32
  %shl18 = shl i32 %conv17, 8
  %call19 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv20 = zext i8 %call19 to i32
  %add21 = or i32 %shl18, %conv20
  %call23 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv26 = zext i8 %call23 to i32
  %shl27 = shl i32 %conv26, 8
  %call28 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv29 = zext i8 %call28 to i32
  %add30 = or i32 %shl27, %conv29
  %call32 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv35 = zext i8 %call32 to i32
  %shl36 = shl i32 %conv35, 8
  %call37 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv38 = zext i8 %call37 to i32
  %add39 = or i32 %shl36, %conv38
  %call41 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv44 = zext i8 %call41 to i32
  %shl45 = shl i32 %conv44, 8
  %call46 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv47 = zext i8 %call46 to i32
  %add48 = or i32 %shl45, %conv47
  %call50 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv53 = zext i8 %call50 to i32
  %shl54 = shl i32 %conv53, 8
  %call55 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv56 = zext i8 %call55 to i32
  %add57 = or i32 %shl54, %conv56
  %call59 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv62 = zext i8 %call59 to i32
  %shl63 = shl i32 %conv62, 8
  %call64 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv65 = zext i8 %call64 to i32
  %add66 = or i32 %shl63, %conv65
  %call68 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv71 = zext i8 %call68 to i32
  %shl72 = shl i32 %conv71, 8
  %call73 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv74 = zext i8 %call73 to i32
  %add75 = or i32 %shl72, %conv74
  %mul = mul nsw i32 %add12, %add
  %mul85 = mul nsw i32 %mul, %add21
  %mul91 = mul nsw i32 %add39, %add30
  %mul94 = mul nsw i32 %mul91, %add48
  %mul100 = mul nsw i32 %add66, %add57
  %mul103 = mul nsw i32 %mul100, %add75
  %mul109 = mul nsw i32 %add21, %add12
  %shr457 = lshr i32 %mul109, 3
  %mul116 = mul nsw i32 %add48, %add39
  %shr117458 = lshr i32 %mul116, 3
  %cmp467 = icmp ugt i32 %mul85, 7
  br i1 %cmp467, label %bb.nph469, label %for.cond171.preheader

for.cond171.preheader.loopexit:                   ; preds = %for.body
  br label %for.cond171.preheader

for.cond171.preheader:                            ; preds = %for.cond171.preheader.loopexit, %entry
  %cmp175463 = icmp ugt i32 %mul94, 7
  br i1 %cmp175463, label %bb.nph465, label %for.end231

bb.nph469:                                        ; preds = %entry
  %tmp492 = mul i32 %add, %add12
  %tmp494 = mul i32 %tmp492, %add21
  %tmp495 = lshr i32 %tmp494, 3
  %tmp496 = icmp ugt i32 %tmp495, 1
  %tmp495.op = add i32 %tmp495, -1
  %0 = zext i32 %tmp495.op to i64
  %.op503 = add i64 %0, 1
  %tmp500 = select i1 %tmp496, i64 %.op503, i64 1
  br label %for.body

for.body:                                         ; preds = %for.body, %bb.nph469
  %indvar489 = phi i64 [ 0, %bb.nph469 ], [ %indvar.next490, %for.body ]
  %arrayidx = getelementptr %struct.__SizedTensor_16K* @input_1, i64 0, i32 0, i64 %indvar489
  %call124 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv125 = zext i8 %call124 to i64
  %shl127 = shl i64 %conv125, 8
  %call128 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv130 = zext i8 %call128 to i64
  %add131 = or i64 %shl127, %conv130
  %shl133 = shl i64 %add131, 8
  %call134 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv136 = zext i8 %call134 to i64
  %add137 = or i64 %shl133, %conv136
  %shl139 = shl i64 %add137, 8
  %call140 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv142 = zext i8 %call140 to i64
  %add143 = or i64 %shl139, %conv142
  %shl145 = shl i64 %add143, 8
  %call146 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv148 = zext i8 %call146 to i64
  %add149 = or i64 %shl145, %conv148
  %shl151 = shl i64 %add149, 8
  %call152 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv154 = zext i8 %call152 to i64
  %add155 = or i64 %shl151, %conv154
  %shl157 = shl i64 %add155, 8
  %call158 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv160 = zext i8 %call158 to i64
  %add161 = or i64 %shl157, %conv160
  %shl163 = shl i64 %add161, 8
  %call164 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv166 = zext i8 %call164 to i64
  %add167 = or i64 %shl163, %conv166
  store i64 %add167, i64* %arrayidx, align 8
  %indvar.next490 = add i64 %indvar489, 1
  %exitcond2 = icmp eq i64 %indvar.next490, %tmp500
  br i1 %exitcond2, label %for.cond171.preheader.loopexit, label %for.body

bb.nph465:                                        ; preds = %for.cond171.preheader
  %tmp479 = mul i32 %add30, %add39
  %tmp481 = mul i32 %tmp479, %add48
  %tmp482 = lshr i32 %tmp481, 3
  %tmp483 = icmp ugt i32 %tmp482, 1
  %tmp482.op = add i32 %tmp482, -1
  %1 = zext i32 %tmp482.op to i64
  %.op502 = add i64 %1, 1
  %tmp487 = select i1 %tmp483, i64 %.op502, i64 1
  br label %for.body177

for.body177:                                      ; preds = %for.body177, %bb.nph465
  %indvar476 = phi i64 [ 0, %bb.nph465 ], [ %indvar.next477, %for.body177 ]
  %arrayidx227 = getelementptr %struct.__SizedTensor_16K* @input_2, i64 0, i32 0, i64 %indvar476
  %call180 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv181 = zext i8 %call180 to i64
  %shl183 = shl i64 %conv181, 8
  %call184 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv186 = zext i8 %call184 to i64
  %add187 = or i64 %shl183, %conv186
  %shl189 = shl i64 %add187, 8
  %call190 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv192 = zext i8 %call190 to i64
  %add193 = or i64 %shl189, %conv192
  %shl195 = shl i64 %add193, 8
  %call196 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv198 = zext i8 %call196 to i64
  %add199 = or i64 %shl195, %conv198
  %shl201 = shl i64 %add199, 8
  %call202 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv204 = zext i8 %call202 to i64
  %add205 = or i64 %shl201, %conv204
  %shl207 = shl i64 %add205, 8
  %call208 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv210 = zext i8 %call208 to i64
  %add211 = or i64 %shl207, %conv210
  %shl213 = shl i64 %add211, 8
  %call214 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv216 = zext i8 %call214 to i64
  %add217 = or i64 %shl213, %conv216
  %shl219 = shl i64 %add217, 8
  %call220 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind
  %conv222 = zext i8 %call220 to i64
  %add223 = or i64 %shl219, %conv222
  store i64 %add223, i64* %arrayidx227, align 8
  %indvar.next477 = add i64 %indvar476, 1
  %exitcond = icmp eq i64 %indvar.next477, %tmp487
  br i1 %exitcond, label %for.end231.loopexit, label %for.body177

for.end231.loopexit:                              ; preds = %for.body177
  br label %for.end231

for.end231:                                       ; preds = %for.end231.loopexit, %for.cond171.preheader
  tail call void (...)* @__aa_barrier__() nounwind
  %call233 = tail call i32 (...)* @timer() nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %conv243 = and i32 %shr457, 65535
  %conv268 = and i32 %shr117458, 65535
  %shr304 = lshr i32 %mul103, 3
  br label %while.body

while.body:                                       ; preds = %if.end300, %for.end231
  %add_out.1 = phi i16 [ 0, %for.end231 ], [ %add_out.2504, %if.end300 ]
  %add_inp1.1 = phi i16 [ 0, %for.end231 ], [ %add_inp1.0, %if.end300 ]
  %add_inp2.1 = phi i16 [ 0, %for.end231 ], [ %add_inp2.0506, %if.end300 ]
  %count_inp1.1 = phi i16 [ 0, %for.end231 ], [ %count_inp1.2, %if.end300 ]
  %count_inp2.1 = phi i16 [ 0, %for.end231 ], [ %count_inp2.2, %if.end300 ]
  tail call void @__loop_pipelining_on__(i32 15, i32 1, i32 1) nounwind
  %conv241 = zext i16 %count_inp1.1 to i32
  %cmp244 = icmp ult i32 %conv241, %conv243
  br i1 %cmp244, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %idxprom247 = zext i16 %add_inp1.1 to i64
  %arrayidx248 = getelementptr inbounds %struct.__SizedTensor_16K* @input_1, i64 0, i32 0, i64 %idxprom247
  %tmp249 = load i64* %arrayidx248, align 8
  %idxprom251 = zext i16 %add_out.1 to i64
  %arrayidx252 = getelementptr inbounds %struct.__SizedTensor_16K* @output, i64 0, i32 0, i64 %idxprom251
  store i64 %tmp249, i64* %arrayidx252, align 8
  %inc254 = add i16 %count_inp1.1, 1
  %inc256 = add i16 %add_inp1.1, 1
  %inc258 = add i16 %add_out.1, 1
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  %add_out.0 = phi i16 [ %inc258, %if.then ], [ %add_out.1, %while.body ]
  %add_inp1.0 = phi i16 [ %inc256, %if.then ], [ %add_inp1.1, %while.body ]
  %count_inp1.0 = phi i16 [ %inc254, %if.then ], [ %count_inp1.1, %while.body ]
  %conv260 = zext i16 %count_inp1.0 to i32
  %cmp263 = icmp eq i32 %conv260, %conv243
  br i1 %cmp263, label %land.lhs.true, label %if.end300

land.lhs.true:                                    ; preds = %if.end
  %conv266 = zext i16 %count_inp2.1 to i32
  %cmp269 = icmp ult i32 %conv266, %conv268
  br i1 %cmp269, label %if.then271, label %land.lhs.true292

if.then271:                                       ; preds = %land.lhs.true
  %idxprom273 = zext i16 %add_inp2.1 to i64
  %arrayidx274 = getelementptr inbounds %struct.__SizedTensor_16K* @input_2, i64 0, i32 0, i64 %idxprom273
  %tmp275 = load i64* %arrayidx274, align 8
  %idxprom277 = zext i16 %add_out.0 to i64
  %arrayidx278 = getelementptr inbounds %struct.__SizedTensor_16K* @output, i64 0, i32 0, i64 %idxprom277
  store i64 %tmp275, i64* %arrayidx278, align 8
  %inc280 = add i16 %count_inp2.1, 1
  %inc282 = add i16 %add_inp2.1, 1
  %inc284 = add i16 %add_out.0, 1
  br label %land.lhs.true292

land.lhs.true292:                                 ; preds = %if.then271, %land.lhs.true
  %add_out.2.ph = phi i16 [ %inc284, %if.then271 ], [ %add_out.0, %land.lhs.true ]
  %add_inp2.0.ph = phi i16 [ %inc282, %if.then271 ], [ %add_inp2.1, %land.lhs.true ]
  %count_inp2.0.ph = phi i16 [ %inc280, %if.then271 ], [ %count_inp2.1, %land.lhs.true ]
  %conv294 = zext i16 %count_inp2.0.ph to i32
  %cmp297 = icmp eq i32 %conv294, %conv268
  br i1 %cmp297, label %if.then299, label %if.end300

if.then299:                                       ; preds = %land.lhs.true292
  br label %if.end300

if.end300:                                        ; preds = %if.then299, %land.lhs.true292, %if.end
  %add_inp2.0506 = phi i16 [ %add_inp2.0.ph, %if.then299 ], [ %add_inp2.0.ph, %land.lhs.true292 ], [ %add_inp2.1, %if.end ]
  %add_out.2504 = phi i16 [ %add_out.2.ph, %if.then299 ], [ %add_out.2.ph, %land.lhs.true292 ], [ %add_out.0, %if.end ]
  %count_inp1.2 = phi i16 [ 0, %if.then299 ], [ %count_inp1.0, %land.lhs.true292 ], [ %count_inp1.0, %if.end ]
  %count_inp2.2 = phi i16 [ 0, %if.then299 ], [ %count_inp2.0.ph, %land.lhs.true292 ], [ %count_inp2.1, %if.end ]
  %conv302 = zext i16 %add_out.2504 to i32
  %cmp305 = icmp eq i32 %conv302, %shr304
  br i1 %cmp305, label %while.end, label %while.body

while.end:                                        ; preds = %if.end300
  %conv234 = sext i32 %call233 to i64
  tail call void (...)* @__aa_barrier__() nounwind
  %call310 = tail call i32 (...)* @timer() nounwind
  %conv311 = sext i32 %call310 to i64
  %sub = sub i64 %conv311, %conv234
  %conv317 = trunc i64 %sub to i8
  %shr320 = lshr i64 %sub, 8
  %conv323 = trunc i64 %shr320 to i8
  %shr326 = lshr i64 %sub, 16
  %conv329 = trunc i64 %shr326 to i8
  %shr332 = lshr i64 %sub, 24
  %conv335 = trunc i64 %shr332 to i8
  %shr338 = lshr i64 %sub, 32
  %conv341 = trunc i64 %shr338 to i8
  %shr344 = lshr i64 %sub, 40
  %conv347 = trunc i64 %shr344 to i8
  %shr350 = lshr i64 %sub, 48
  %conv353 = trunc i64 %shr350 to i8
  %shr356 = lshr i64 %sub, 56
  %conv359 = trunc i64 %shr356 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv359) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv353) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv347) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv341) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv335) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv329) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv323) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv317) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %cmp381460 = icmp ugt i32 %mul103, 7
  br i1 %cmp381460, label %bb.nph, label %for.end456

bb.nph:                                           ; preds = %while.end
  %tmp472 = icmp ugt i32 %shr304, 1
  %tmp471.op = add i32 %shr304, -1
  %2 = zext i32 %tmp471.op to i64
  %.op = add i64 %2, 1
  %tmp475 = select i1 %tmp472, i64 %.op, i64 1
  br label %for.body383

for.body383:                                      ; preds = %for.body383, %bb.nph
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body383 ]
  %arrayidx388 = getelementptr %struct.__SizedTensor_16K* @output, i64 0, i32 0, i64 %indvar
  %tmp389 = load i64* %arrayidx388, align 8
  %conv393 = trunc i64 %tmp389 to i8
  %shr396 = lshr i64 %tmp389, 8
  %conv399 = trunc i64 %shr396 to i8
  %shr402 = lshr i64 %tmp389, 16
  %conv405 = trunc i64 %shr402 to i8
  %shr408 = lshr i64 %tmp389, 24
  %conv411 = trunc i64 %shr408 to i8
  %shr414 = lshr i64 %tmp389, 32
  %conv417 = trunc i64 %shr414 to i8
  %shr420 = lshr i64 %tmp389, 40
  %conv423 = trunc i64 %shr420 to i8
  %shr426 = lshr i64 %tmp389, 48
  %conv429 = trunc i64 %shr426 to i8
  %shr432 = lshr i64 %tmp389, 56
  %conv435 = trunc i64 %shr432 to i8
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv435) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv429) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv423) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv417) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv411) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv405) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv399) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str1, i64 0, i64 0), i8 zeroext %conv393) nounwind
  %indvar.next = add i64 %indvar, 1
  %exitcond1 = icmp eq i64 %indvar.next, %tmp475
  br i1 %exitcond1, label %for.end456.loopexit, label %for.body383

for.end456.loopexit:                              ; preds = %for.body383
  br label %for.end456

for.end456:                                       ; preds = %for.end456.loopexit, %while.end
  ret void
}

declare zeroext i8 @read_uint8(i8*)

declare void @__aa_barrier__(...)

declare i32 @timer(...)

declare void @__loop_pipelining_on__(i32, i32, i32)

declare void @write_uint8(i8*, i8 zeroext)
