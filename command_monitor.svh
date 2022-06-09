
class command_monitor extends uvm_component;
   `uvm_component_utils(command_monitor);

   virtual decrypt_bfm bfm;

   uvm_analysis_port #(command_transaction) ap;

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual decrypt_bfm)::get(null, "*","bfm", bfm))
	`uvm_fatal("COMMAND MONITOR", "Failed to get BFM")
      bfm.command_monitor_h = this;
      ap  = new("ap",this);
   endfunction : build_phase

   function void write_to_monitor(byte encrypted_data[0:63], bit [3:0] pre_len, byte preamble, bit [4:0] taps, start);
     command_transaction cmd;
     `uvm_info("COMMAND MONITOR",$sformatf("MONITOR: encrypted data: %2h  preamble_length: %2h  preamble: %s  taps: %2h   start_Seed: %2h",
                encrypted_data, pre_len, preamble,taps,start), UVM_HIGH);
     cmd = new("cmd");
     cmd.encrypted_data = encrypted_data;
     cmd.pre_len = pre_len;
     cmd.preamble = preamble;
     cmd.taps     = taps;
     cmd.start    = start;
     ap.write(cmd);
   endfunction : write_to_monitor
endclass : command_monitor


  