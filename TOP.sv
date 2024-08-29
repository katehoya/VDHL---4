module TOP;
   HOintf HOintf(clk);
   server SV(.SV(HOintf));
   BaseStation1 BS1(.BS1(HOintf));
   BaseStation2 BS2(.BS2(HOintf));
   BaseStation3 BS3(.BS3(HOintf));
   MD_DMUX DM(.dm(HOintf));
   mobiledevice MD(.md(HOintf));
endmodule
