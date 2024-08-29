interface HOintf(input logic clk, reset);
   // 서버에서 사용
   logic [3:0]SV_data;//[15:0] SV_data; // tb -> sv -> BS -> MD 데이터
   logic	 [1:0] BS1_SV_target;
   logic [1:0] 	BS2_SV_target;
   logic [1:0] 	BS3_SV_target;
   
   logic [3:0] SV_BS1_data;
   logic [3:0] SV_BS2_data;
   logic [3:0] SV_BS3_data;
	      
   //BS 1,2,3
   logic [1:0] 	BS2_BS1_target; // 다른 BS에서 받은 핸드오버 리퀘스트
   logic [1:0] 	BS3_BS1_target;
   logic [1:0] 	BS3_BS2_target;
   logic [1:0] 	BS1_BS2_target; // BS에 보낼 타겟 정보
   logic [1:0] 	BS1_BS3_target; // BS에 보낼 타겟 정보
   logic [1:0] 	BS2_BS3_target;     


   // MD_DMUX에서 사용
   logic [3:0] BS1_DM_data; // BS1에서 받아옴
   logic [3:0] BS2_DM_data; // BS2에서 받아옴
   logic [3:0] BS3_DM_data; // BS3에서 받아옴
   logic [1:0]  MD_DM_target;  // MD에서 받아옴
   logic [7:0]  MD_DM_sq1;
   logic [7:0] 	MD_DM_sq2;
   logic [7:0] 	MD_DM_sq3;  // MD에서 받아옴
   logic 	BS1_DM_respond;//BS1이랑 먹스 연결
   logic 	BS2_DM_respond; //BS2랑 먹스 연결
   logic 	BS3_DM_respond; //BS3랑 먹스 연결
   logic 	BS1_DM_request;//mobile_send_request1,  // BS1에서 받아옴
   logic 	BS2_DM_request;//mobile_send_request2, // BS2에서 받아옴
   logic 	BS3_DM_request;//mobile_send_request3, // BS3에서 받아옴
   logic [3:0] DM_MD_data; // MD로 보내줌s
   logic 	compare_enable;
   
   logic [7:0] 	DM_BS1_sq; // BS1에게 보내줌
   logic [7:0] 	DM_BS2_sq; // BS2에게 보내줌
   logic [7:0] 	DM_BS3_sq; // BS3에게 보내줌
   logic [1:0] 	DM_BS1_target; //  BS1에게 보내줌
   logic [1:0] 	DM_BS2_target; //  BS2에게 보내줌
   logic [1:0] 	DM_BS3_target; //  BS3에게 보내줌
   
   // MD에서 사용
   logic [7:0] 	signalquality1;
   logic [7:0] 	signalquality2;
   logic [7:0] 	signalquality3; // 인터페이스에서 받는 signal quality
   
   logic [3:0] 	final_data; // 모바일에서 받는 최종 데이터


   modport SV (
	       input  clk, reset, SV_data, BS1_SV_target, BS2_SV_target, BS3_SV_target,
	       output SV_BS1_data, SV_BS2_data, SV_BS3_data);


   modport BS1 (
		input  clk, reset, SV_BS1_data, DM_BS1_sq, DM_BS1_target, BS2_BS1_target, BS3_BS1_target,
		output BS1_DM_request, BS1_DM_data, BS1_DM_respond, BS1_BS2_target, BS1_BS3_target, BS1_SV_target);


   modport BS2 (
		input  clk, reset, SV_BS2_data, DM_BS2_sq, DM_BS2_target, BS1_BS2_target, BS3_BS2_target, 
		output BS2_DM_request, BS2_DM_data, BS2_DM_respond, BS2_BS1_target, BS2_BS3_target, BS2_SV_target);


   modport BS3 (
		input  clk, reset, SV_BS3_data, DM_BS3_sq, DM_BS3_target, BS1_BS3_target, BS2_BS3_target, 
		output BS3_DM_request, BS3_DM_data, BS3_DM_respond, BS3_BS1_target, BS3_BS2_target, BS3_SV_target);


   modport DM (
	       input  clk, reset, BS1_DM_data, BS2_DM_data, BS3_DM_data, MD_DM_target, MD_DM_sq1, MD_DM_sq2, MD_DM_sq3, BS1_DM_respond, BS2_DM_respond, BS3_DM_respond, BS1_DM_request, 
   		      BS2_DM_request, BS3_DM_request,
	       output DM_MD_data, compare_enable, DM_BS1_sq, DM_BS2_sq, DM_BS3_sq, DM_BS1_target, DM_BS2_target, DM_BS3_target );


   modport MD (
	       input  clk, reset, DM_MD_data, signalquality1, signalquality2, signalquality3, compare_enable,
	       output final_data, MD_DM_target,MD_DM_sq1, MD_DM_sq2, MD_DM_sq3);
     
     endinterface : HOintf
