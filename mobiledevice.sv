module mobiledevice (HOintf.MD md);

    always @(posedge md.clk)
      begin
        if (md.reset==1)
	  begin
             md.MD_DM_target <= 2'd3;
             md.MD_DM_sq1 <= 8'd0;
	     md.MD_DM_sq2 <= 8'd0;
	     md.MD_DM_sq3 <= 8'd0;
	     md.final_data <=4'd0;
          end else
	    begin
               md.final_data <= md.DM_MD_data;
	       md.MD_DM_sq1 <= md.signalquality1;
	       md.MD_DM_sq2 <= md.signalquality2;
	       md.MD_DM_sq3 <= md.signalquality3;

	       
               if (md.compare_enable)
		 begin
                    if (md.signalquality1 >= md.signalquality2 && md.signalquality1 >= md.signalquality3)
		      begin
			 md.MD_DM_target <= 2'd0;
                      end else if (md.signalquality2 >= md.signalquality1 && md.signalquality2 >= md.signalquality3)
			begin
			   md.MD_DM_target <= 2'd1;
			end else
			  begin
			     md.MD_DM_target <= 2'd2;
			  end
		 end // if (md.compare_enable)
	    end // else: !if(md.reset==1)
      end // always @ (posedge md.clk)
endmodule // mobiledevice
