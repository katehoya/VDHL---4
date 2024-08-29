module MD_DMUX(HOintf.DM dm);
   logic 			   MSR;

   assign MSR = (dm.BS1_DM_request || dm.BS2_DM_request || dm.BS3_DM_request);

   always @(posedge dm.clk)
     begin
	if(dm.reset ==1) begin
	// 기본적으로 server_data를 0으로 초기화
	dm.DM_MD_data <= 4'd0;
	end
	else begin
	   

	if (MSR == 1)
	  begin
	     dm.compare_enable <= MSR;
	  end
	else
	  begin
	     dm.compare_enable <= 0;
	  end
   
	// MD_respond에 따라 server_data 설정
	if (dm.MD_DM_target != 2'd3) 
	  begin
             dm.DM_BS1_target <= dm.MD_DM_target;
             dm.DM_BS2_target <= dm.MD_DM_target;
             dm.DM_BS3_target <= dm.MD_DM_target;
	  end
	else 
	  begin
	     dm.DM_BS1_target <= 2'dx;
	     dm.DM_BS2_target <= 2'dx;
	     dm.DM_BS3_target <= 2'dx;
	  end // else: !if(quality_bs != 2'd3)
   
	if (dm.BS1_DM_respond == 1)
	  begin
             dm.DM_MD_data <= dm.BS1_DM_data;
             dm.DM_BS1_sq <= dm.MD_DM_sq1;
             dm.DM_BS2_sq <= 2'dx;
             dm.DM_BS3_sq <= 2'dx;
	  end else if (dm.BS2_DM_respond == 1'b1)
	    begin
               dm.DM_MD_data <= dm.BS2_DM_data;
               dm.DM_BS1_sq <= 2'dx;
               dm.DM_BS2_sq <= dm.MD_DM_sq2;
               dm.DM_BS3_sq <= 2'dx;
	    end else if (dm.BS3_DM_respond == 1'b1)
	      begin
		 dm.DM_MD_data <= dm.BS3_DM_data;
		 dm.DM_BS1_sq <= 2'dx;
		 dm.DM_BS2_sq <= 2'dx;
		 dm.DM_BS3_sq <= dm.MD_DM_sq3;
	      end
	end // else: !if(dm.reset ==1)
     end // always @ (posedge dm.clk)
   
endmodule
