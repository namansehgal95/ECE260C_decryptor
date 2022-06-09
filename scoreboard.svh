class scoreboard extends uvm_subscriber #(result_transaction);
   `uvm_component_utils(scoreboard);

   uvm_tlm_analysis_fifo #(command_transaction) cmd_f;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      cmd_f = new ("cmd_f", this);
   endfunction : build_phase

   function result_transaction predict_result(command_transaction cmd);
      result_transaction predicted;
      predicted = new("predicted");
      predicted.decrypted_result = cmd.original_padded_data[command.pre_len:63];
      return predicted;
   endfunction : predict_result
   
   function void write(result_transaction t);
      string data_str;
      command_transaction cmd;
      result_transaction predicted;

      do
        if (!cmd_f.try_get(cmd))
          $fatal(1, "Missing command in self checker");

      predicted = predict_result(cmd);
      decrypt_dut = t.decrypted_result;
      data_str = {                    cmd.convert2string(), 
                  " ==>  Actual "  ,    t.convert2string()[command.pre_len:63], 
                  "/Predicted ",predicted.convert2string()};
                  
                  
      if (!predicted.compare(decrypt_dut[command.pre_len:63]))
        `uvm_error("SELF CHECKER", {"FAIL: ",data_str})
      else
        `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)

   endfunction : write
endclass : scoreboard






