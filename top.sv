module top;
   import uvm_pkg::*;
   import decrypt_pkg::*;
`include "decrypt_macros.svh"
`include "uvm_macros.svh"
   
decrypt_bfm bfm();

decryption_wrapper DUT (
 	.clk           	(bfm.clk), 
	.init          	(bfm.init),
	.preamble      	(bfm.preamble),
	.pre_len       	(bfm.pre_len),
	.encrypted_data	(bfm.data_in_tb),
	.decrypted_data	(bfm.data_out_tb),	
   	.done        	(bfm.done),
	.reset			(bfm.reset)
 );

initial begin
   uvm_config_db #(virtual decrypt_bfm)::set(null, "*", "bfm", bfm);
   run_test();
end

endmodule : top

     
   