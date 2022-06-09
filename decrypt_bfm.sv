
interface decrypt_bfm;
   import decrypt_pkg::*;

   bit [4:0]   taps, start;
   bit [3:0]   pre_len;
   bit         clk, init,reset;
   bit [7:0]   preamble;
   byte  data_in_tb[0:63];
   byte  data_out_tb[0:63];
   wire done;


   task init_decrypt();
      init = 1;
      reset = 1;
      @(negedge clk);
      @(negedge clk);
      reset = 1'b0;

      @(negedge clk);
      @(negedge clk);
      init = 1'b0;

   endtask : reset_alu

   task start_decrypt(input byte encrypted_data [0:63], output byte decrypted_data [0:63]);

      data_in_tb = encrypted_data
      do
         @(negedge clk);
      while (done == 0);
      decrypted_data = data_out_tb;   

   endtask : start_decrypt
   
   command_monitor command_monitor_h;

   always @(posedge clk) begin : op_monitor
      command_transaction command;
      command_monitor_h.write_to_monitor(data_in_tb, pre_len, preamble,taps,start);
   end : op_monitor

   always @(negedge reset_n) begin : rst_monitor
      command_transaction command;
      if (command_monitor_h != null) //guard against VCS time 0 negedge
        command_monitor_h.write_to_monitor($random,0,0,0,0);
   end : rst_monitor
   
   result_monitor  result_monitor_h;

   initial begin : result_monitor_thread
      forever begin : result_monitor
         @(posedge clk) ;
         if (done) 
           result_monitor_h.write_to_monitor(data_out_tb);
      end : result_monitor
   end : result_monitor_thread
   

   initial begin
      clk = 0;
      forever begin
         #10;
         clk = ~clk;
      end
   end

endinterface: decrypt_bfm
