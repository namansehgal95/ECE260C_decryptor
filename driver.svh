class driver extends uvm_component;
   `uvm_component_utils(driver)

   virtual decrypt_bfm bfm;

   uvm_get_port #(command_transaction) command_port;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual decrypt_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")
      command_port = new("command_port",this);
   endfunction : build_phase


   function void compute_encrypt_data(command_transaction command);
      bit [4:0] LFSR_states[0:63];
      byte msg_padded[0:63];
      LFSR_states[0] = command.start;
      all_chr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
      all_chr_len = all_chr.len;

      for (int ii=0;ii<63;ii++) begin :lfsr_loop
			LFSR_states[ii+1] = (LFSR_states[ii]<<1)+(^(LFSR_states[ii]&command.taps));
		end	  :lfsr_loop

      for(int i = 0; i<command.data_len ; i++)
         command.original_data[i] = all_chr[$urandom_range(0,100) % all_chr_len];  

      for(int j=0; j<64; j++) 			   // pre-fill message_padded with ASCII ~ characters
			command.original_padded_data[j] = command.preamble;      
         msg_padded[j] = command.preamble;   

		for(int l=0; l<command.data_len; l++)  		   // overwrite up to 60 of these spaces w/ message itself
			command.original_padded_data[command.pre_len+l] = command.original_data[l];
         msg_padded[command.pre_len+l] = byte'(command.original_data[l]);

      for (int i=0; i<64; i++) begin		   // testbench will change on falling clocks
			command.encrypted_data[i]  = msg_padded[i] ^ LFSR_states[i];  //{1'b0,LFSR[6:0]};	   // encrypt 7 LSBs
		end

   endfunction : compute_encrypt_data

   task run_phase(uvm_phase phase);
      bit     done;
      command_transaction    command;
      forever begin : command_loop
         command_port.get(command);
         compute_encrypt_data(command)
         bfm.start_decrypt(command.encrypted_data, command.decrypted_data);
      end : command_loop
   endtask : run_phase
   
   
endclass : driver
