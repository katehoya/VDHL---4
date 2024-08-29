`include "HOintf.sv"
`include "server.sv"
`include "BaseStation1.sv"
`include "BaseStation2.sv"
`include "BaseStation3.sv"
`include "MD_DMUX.sv"
`include "mobiledevice.sv"
`timescale 1ns/1ns

module TOP_tb;
   logic clk;
   logic reset;
   HOintf HO(clk, reset);
   server SV(.SV(HO));
   BaseStation1 BS1(.BS1(HO));
   BaseStation2 BS2(.BS2(HO));
   BaseStation3 BS3(.BS3(HO));
   MD_DMUX DM(.dm(HO));
   mobiledevice MD(.md(HO));


   always #5 clk = ~clk;

   always @(posedge clk && HO.SV_data && HO.final_data) begin
      assert(HO.SV_data == HO.final_data)begin
	 $display ("GOOD");
      end
      else begin
	 $display ("BAD");
      end
   end
   
   property SV_data_final_data;
      @(posedge clk) disable iff (reset) (HO.SV_data |-> ##4 HO.SV_data == HO.final_data);
   endproperty

   assert property (SV_data_final_data) $display("CORRECT"); else $display("NOT CORRECT");

   initial
     begin
	clk=0;
	reset = 1;
	HO.BS1_DM_respond = 1;
	HO.BS2_DM_respond = 0;
	HO.BS3_DM_respond = 0;
	HO.BS1_BS2_target = 0;
	HO.BS1_BS3_target = 0;
	HO.BS2_BS1_target = 0;
	HO.BS2_BS3_target = 0;
	HO.BS3_BS1_target = 0;
	HO.BS3_BS2_target = 0;
	HO.signalquality1 = 8'd0;
	HO.signalquality2 = 8'd0;
	HO.signalquality3 = 8'd0;
	HO.SV_data = 4'd0;

	#10
	  reset = 0;

	#10
	  HO.BS2_BS1_target = 1; // BS1 source 설정

	#10
	  HO.signalquality1 = 8'd70;
	  HO.signalquality2 = 8'd30;
          HO.signalquality3 = 8'd20;

	#10
	  HO.BS1_DM_respond = 1;
       


	#100
	  HO.SV_data = 4'd2;

	#10
	  HO.SV_data = 4'd5;

	#10
	  HO.SV_data = 4'd7;

	#50
	  HO.signalquality1 = 8'd30;
	  HO.signalquality2 = 8'd90;
          HO.signalquality3 = 8'd30;

	#100
	  HO.SV_data = 4'd2;

	#10
	  HO.SV_data = 4'd3;
	#10
	  HO.SV_data = 4'd3;

       	#50
	  HO.signalquality1 = 8'd60;
	  HO.signalquality2 = 8'd30;
          HO.signalquality3 = 8'd30;

	#150
	  HO.SV_data = 4'd2;




	

	#500
	  $finish();
     end // initial begin
endmodule // TOP_tb
