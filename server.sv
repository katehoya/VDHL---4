module server(HOintf.SV SV);
   
   always_ff @(posedge SV.clk)
     begin
	if(SV.reset)
	  begin
	     SV.SV_BS1_data<=4'bx;
	     SV.SV_BS2_data<=4'bx;
	     SV.SV_BS3_data<=4'bx;// reset
	  end
	else
	  begin
	       begin//mme가 bs1로 보내라 하면
		  if (SV.BS1_SV_target==2'd0 || SV.BS2_SV_target==2'd0 || SV.BS3_SV_target==2'd0)
		    begin
		       SV.SV_BS1_data <= SV.SV_data;
		       SV.SV_BS2_data <= 4'bx;
		       SV.SV_BS3_data <= 4'bx;//bs1로 데이터 전송
		    end
		  else if (SV.BS1_SV_target==2'd1 || SV.BS2_SV_target==2'd1 || SV.BS3_SV_target==2'd1)
		    begin
		       SV.SV_BS1_data <= 4'bx;
		       SV.SV_BS2_data <= SV.SV_data;
		       SV.SV_BS3_data <= 4'bx;//bs2로 데이터 전송
		    end
 		  else if (SV.BS1_SV_target==2'd2 || SV.BS2_SV_target==2'd2 || SV.BS3_SV_target==2'd2)
		    begin
		       SV.SV_BS1_data <= 4'bx;
		       SV.SV_BS2_data <= 4'bx;
		       SV.SV_BS3_data <= SV.SV_data;//bs3로 데이터 전송
		       
		    end		
	       end	    
	  end // always_ff @ (posedge intf.clk)
	end
endmodule // server
