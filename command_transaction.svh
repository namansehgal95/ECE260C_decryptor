class command_transaction extends uvm_transaction;
   `uvm_object_utils(command_transaction)
   rand bit [4:0] taps;
   rand bit [4:0] start;
   rand bit [3:0] pre_len;
   rand bit [7:0] data_len;
   string original_padded_data;

   string original_data ;
   rand byte preamble;
   byte encrypted_data[0:63];

   constraint taps_range { taps inside {5'h1E, 5'h1D, 5'h1B, 5'h12, 5'h14, 5'h17}; }
   constraint start_range { start != 0 ;}
   constraint preamble_len_range { pre_len <= 4'd12 ; pre_len >=4'd7;}
   constraint data_length_range { data_len <= 52 ; data_len >= 16}

      
   function void do_copy(uvm_object rhs);
      command_transaction copied_transaction_h;

      if(rhs == null) 
        `uvm_fatal("COMMAND TRANSACTION", "Tried to copy from a null pointer")

      if(!$cast(copied_transaction_h,rhs))
        `uvm_fatal("COMMAND TRANSACTION", "Tried to copy wrong type.")
      
      super.do_copy(rhs); // copy all parent class data

      taps                 = copied_transaction_h.taps;
      start                = copied_transaction_h.start;
      pre_len              = copied_transaction_h.pre_len;
      original_data        = copied_transaction_h.original_data;
      original_padded_data = copied_transaction_h.original_padded_data;
      preamble             = copied_transaction_h.preamble;
      encrypted_data       = copied_transaction_h.encrypted_data
   endfunction : do_copy

   function command_transaction clone_me();
      command_transaction clone;
      uvm_object tmp;

      tmp = this.clone();
      $cast(clone, tmp);
      return clone;
   endfunction : clone_me
   

   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      command_transaction compared_transaction_h;
      bit   same;
      
      if (rhs==null) `uvm_fatal("RANDOM TRANSACTION", 
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(compared_transaction_h,rhs))
        same = 0;
      else
        same = super.do_compare(rhs, comparer) && 
               (compared_transaction_h.taps == taps) &&
               (compared_transaction_h.start == start) &&
               (compared_transaction_h.pre_len == pre_len) &&
               (compared_transaction_h.preamble == preamble) &&
               (compared_transaction_h.original_data == original_data)&&
               (compared_transaction_h.encrypted_data == encrypted_data)&&
               (compared_transaction_h.original_padded_data == original_padded_data);
               
      return same;
   endfunction : do_compare


   function string convert2string();
      string s;
      s = $sformatf("A: %2h  B: %2h op: %s",
                        A, B, op.name());
      return s;
   endfunction : convert2string

   function new (string name = "");
      super.new(name);
   endfunction : new

endclass : command_transaction