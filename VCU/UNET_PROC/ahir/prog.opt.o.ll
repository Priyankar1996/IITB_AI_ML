; ModuleID = 'prog.opt.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-unknown-linux-gnu"

@.str = private constant [19 x i8] c"system_output_pipe\00"
@.str1 = private constant [9 x i8] c"time_val\00"
@global_time_val = common global [20 x i64] zeroinitializer, align 4
@.str2 = private constant [18 x i8] c"debug_output_pipe\00"
@.str3 = private constant [23 x i8] c"tester_control_command\00"
@.str4 = private constant [24 x i8] c"tester_control_response\00"
@.str5 = private constant [24 x i8] c"ACCELERATOR_INTERRUPT_8\00"
@.str6 = private constant [17 x i8] c"debug_input_pipe\00"
@.str7 = private constant [18 x i8] c"system_input_pipe\00"

define void @writeTime(i8 zeroext %ind) nounwind {
entry:
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  %idxprom = zext i8 %ind to i32
  %arrayidx = getelementptr inbounds [20 x i64]* @global_time_val, i32 0, i32 %idxprom
  store i64 %call, i64* %arrayidx, align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  ret void
}

declare void @write_uint8(i8*, i8 zeroext)

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
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv46) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv40) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv34) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv28) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv22) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv16) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv10) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i8 zeroext %conv) nounwind
  %inc = add nsw i32 %i.066, 1
  %exitcond1 = icmp eq i32 %inc, 19
  br i1 %exitcond1, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret i32 undef
}

declare void @__aa_barrier__(...)

define i32 @accessAcceleratorRegisters(i8 zeroext %write_bar, i32 %reg_index, i32 %reg_value) nounwind {
entry:
  %conv = zext i8 %write_bar to i64
  %shl = shl i64 %conv, 31
  %conv3 = zext i32 %reg_index to i64
  %or = or i64 %shl, %conv3
  %shl5 = shl i64 %or, 32
  %conv7 = zext i32 %reg_value to i64
  %or8 = or i64 %shl5, %conv7
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8) nounwind
  %call = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  ret i32 %call
}

declare void @write_uint64(i8*, i64)

declare i32 @read_uint32(i8*)

define void @execute_layer() nounwind {
entry:
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 100) nounwind
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 7) nounwind
  %call.i = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 101) nounwind
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([24 x i8]* @.str5, i32 0, i32 0)) nounwind
  %tobool = icmp eq i8 %call1, 0
  br i1 %tobool, label %while.end, label %while.body

while.end:                                        ; preds = %while.body
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 102) nounwind
  br label %while.body2

while.body2:                                      ; preds = %while.body2, %while.end
  %call3 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([24 x i8]* @.str5, i32 0, i32 0)) nounwind
  %tobool4 = icmp eq i8 %call3, 0
  br i1 %tobool4, label %while.body2, label %while.end7

while.end7:                                       ; preds = %while.body2
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 103) nounwind
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 0) nounwind
  %call.i9 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 104) nounwind
  ret void
}

declare zeroext i8 @read_uint8(i8*)

define void @set_convolution_layer(i16 zeroext %rb, i16 zeroext %cb, i16 zeroext %rt, i16 zeroext %ct, i16 zeroext %chl_out, i16 zeroext %chl_in, i16 zeroext %rk, i16 zeroext %ck, i32 %addr_in1, i32 %addr_in2, i32 %addr_k, i8 zeroext %addr_out, i16 zeroext %shift_val, i16 zeroext %pad, i8 zeroext %pool, i8 zeroext %activation) nounwind {
entry:
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 1) nounwind
  %conv = zext i16 %rb to i32
  %shl = shl i32 %conv, 16
  %conv2 = zext i16 %cb to i32
  %add = or i32 %shl, %conv2
  %conv7.i = zext i32 %add to i64
  %or8.i = or i64 %conv7.i, 4294967296
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i) nounwind
  %call.i = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv5 = zext i16 %rt to i32
  %shl6 = shl i32 %conv5, 16
  %conv8 = zext i16 %ct to i32
  %add9 = or i32 %shl6, %conv8
  %conv7.i58 = zext i32 %add9 to i64
  %or8.i59 = or i64 %conv7.i58, 8589934592
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i59) nounwind
  %call.i60 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv13 = zext i16 %chl_out to i32
  %shl14 = shl i32 %conv13, 16
  %conv16 = zext i16 %chl_in to i32
  %add17 = or i32 %shl14, %conv16
  %conv7.i61 = zext i32 %add17 to i64
  %or8.i62 = or i64 %conv7.i61, 12884901888
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i62) nounwind
  %call.i63 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv21 = zext i16 %rk to i32
  %shl22 = shl i32 %conv21, 16
  %conv24 = zext i16 %ck to i32
  %add25 = or i32 %shl22, %conv24
  %conv7.i64 = zext i32 %add25 to i64
  %or8.i65 = or i64 %conv7.i64, 17179869184
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i65) nounwind
  %call.i66 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv29 = zext i16 %shift_val to i32
  %shl30 = shl i32 %conv29, 16
  %conv32 = zext i16 %pad to i32
  %add33 = or i32 %shl30, %conv32
  %conv7.i67 = zext i32 %add33 to i64
  %or8.i68 = or i64 %conv7.i67, 21474836480
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i68) nounwind
  %call.i69 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv38 = zext i8 %pool to i32
  %shl39 = shl i32 %conv38, 8
  %conv41 = zext i8 %activation to i32
  %add42 = or i32 %shl39, %conv41
  %conv7.i70 = zext i32 %add42 to i64
  %or8.i71 = or i64 %conv7.i70, 25769803776
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i71) nounwind
  %call.i72 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv7.i73 = zext i32 %addr_in1 to i64
  %or8.i74 = or i64 %conv7.i73, 30064771072
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i74) nounwind
  %call.i75 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv7.i76 = zext i32 %addr_in2 to i64
  %or8.i77 = or i64 %conv7.i76, 34359738368
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i77) nounwind
  %call.i78 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv7.i79 = zext i8 %addr_out to i64
  %or8.i80 = or i64 %conv7.i79, 38654705664
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i80) nounwind
  %call.i81 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  %conv7.i82 = zext i32 %addr_k to i64
  %or8.i83 = or i64 %conv7.i82, 42949672960
  tail call void @write_uint64(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i64 %or8.i83) nounwind
  %call.i84 = tail call i32 @read_uint32(i8* getelementptr inbounds ([24 x i8]* @.str4, i32 0, i32 0)) nounwind
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext 2) nounwind
  ret void
}

define void @systemTOP() nounwind {
entry:
  %call = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([17 x i8]* @.str6, i32 0, i32 0)) nounwind
  %call1 = tail call zeroext i8 @read_uint8(i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0)) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 1), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i3 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i3, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 2), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i4 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i4, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 3), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i5 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i5, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 4), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i6 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i6, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 5), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 1, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i7 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i7, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 6), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i8 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i8, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 7), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 28, i16 zeroext 512, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i9 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i9, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 8), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 56, i16 zeroext 56, i16 zeroext 28, i16 zeroext 28, i16 zeroext 256, i16 zeroext 512, i16 zeroext 2, i16 zeroext 2, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i10 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i10, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 9), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 512, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i11 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i11, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 10), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 56, i16 zeroext 256, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i12 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i12, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 11), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 112, i16 zeroext 112, i16 zeroext 56, i16 zeroext 56, i16 zeroext 128, i16 zeroext 256, i16 zeroext 2, i16 zeroext 2, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i13 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i13, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 12), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 256, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i14 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i14, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 13), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 112, i16 zeroext 128, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i15 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i15, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 14), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 112, i16 zeroext 112, i16 zeroext 64, i16 zeroext 128, i16 zeroext 2, i16 zeroext 2, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 0, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i16 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i16, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 15), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 128, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i17 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i17, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 16), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 64, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 1)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i18 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i18, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 17), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void @set_convolution_layer(i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 224, i16 zeroext 3, i16 zeroext 64, i16 zeroext 3, i16 zeroext 3, i32 0, i32 0, i32 0, i8 zeroext 0, i16 zeroext 0, i16 zeroext 1, i8 zeroext 0, i8 zeroext 2)
  tail call void @execute_layer()
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -55) nounwind
  %call.i19 = tail call i64 @read_uint64(i8* getelementptr inbounds ([9 x i8]* @.str1, i32 0, i32 0)) nounwind
  store i64 %call.i19, i64* getelementptr inbounds ([20 x i64]* @global_time_val, i32 0, i32 18), align 4
  tail call void @write_uint8(i8* getelementptr inbounds ([19 x i8]* @.str, i32 0, i32 0), i8 zeroext -54) nounwind
  tail call void (...)* @__aa_barrier__() nounwind
  %call2 = tail call i32 @writeTimeBack()
  ret void
}
