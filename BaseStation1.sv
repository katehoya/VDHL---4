module BaseStation1(HOintf.BS1 BS1);

   // 내부 변수 및 메모리 정의
   logic [1:0]	  source_or_target1; // source인지 target인지 결정
   logic 	  decide_source1;
   
   assign source_or_target1 = (BS1.BS2_BS1_target || BS1.BS3_BS1_target) ;

   // case 종류(신호 품질 비교)
   typedef enum   logic [3:0] {
			       IDLE, // 초기상태
			       Target_state,
			       Source,
			       CHECK_SQ, // SQ 확인
			       Newtarget_Info_to_BS, // 새로운 타겟 정보 받아서 BS에 보내기
			       Newtarget_Info_to_SV // 새로운 타겟 정보 다른 서버에 주기
			       } state_t;

   
   state_t current_state, next_state;
 
   // 상태가 바뀌는거
   always_ff @(posedge BS1.clk or posedge BS1.reset)
     begin
	if (BS1.reset) // 시작은 리셋
          current_state <= IDLE; // 초기상태
	else
          current_state <= next_state; // 리셋 아닐때 상태 바꿈
     end

     always @(posedge BS1.clk)
       begin
	case (current_state)	  
	  IDLE : begin //초기 결정상태. decide_source에 따라서 아무것도 아닌상태로 있거나 source상태로 가거나
             if(source_or_target1 == 1'b0)
	       begin
		  if(decide_source1 == 1)
		    begin
		       next_state = Source;
		    end
		  else
		    begin
		       next_state = IDLE;
                       BS1.BS1_DM_respond = 0;
		    end
	       end // if (source_or_target = 1'b0)       
             else
	       begin
		  next_state = Target_state;
	       end // else: !if(source_or_target == 1'b0)
	  end // case: IDLE

	  Source : begin
             if (BS1.DM_BS1_sq < 50)
	       begin
		  next_state = CHECK_SQ;
	       end
	     else
	       begin
		  next_state = current_state;
		  BS1.BS1_DM_respond = 1;
		  BS1.BS1_BS2_target = 0;
		  BS1.BS1_BS3_target = 0;
		  BS1.BS1_DM_data <= BS1.SV_BS1_data;
	       end
          end // case: Source

 
	  Target_state : begin
	     BS1.BS1_DM_respond = 1;
	     next_state= Source;
	     decide_source1 = 1;
	  end
	  
          CHECK_SQ : begin
             BS1.BS1_DM_request = 1;        // MD에 request 보내서 더 나은 BS 물어보기
             if(BS1.DM_BS1_target != 0)
	      begin
		 next_state = Newtarget_Info_to_BS;
	      end
          end

	  
	  Newtarget_Info_to_BS : begin

	     
	     if (BS1.DM_BS1_target == 2'd0)
	       begin 
		  BS1.BS1_BS2_target <= 0;
		  BS1.BS1_BS3_target <= 0;
	       end
	     else if (BS1.DM_BS1_target == 2'd1)
	       begin
		  BS1.BS1_BS2_target <= 1;
		  BS1.BS1_BS3_target <= 0;
	       end	
	     else if (BS1.DM_BS1_target == 2'd2)
	       begin
		  BS1.BS1_BS2_target <= 0;
		  BS1.BS1_BS3_target <= 1;
	       end	     
	     else
	       begin
		  BS1.BS1_BS2_target <= 0;
		  BS1.BS1_BS3_target <= 0;
	       end
	     BS1.BS1_DM_request = 0;
	     BS1.BS1_DM_respond = 0; // 소스 연결 끊기
	     
	     next_state = Newtarget_Info_to_SV;
	  end
	  
	  Newtarget_Info_to_SV : begin
	     BS1.BS1_SV_target <= BS1.DM_BS1_target;

	     decide_source1 = 0;
	  
	     next_state = IDLE;
	     end	     
            default : next_state = IDLE;
        endcase
    end
endmodule
