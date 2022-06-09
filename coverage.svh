/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class coverage extends uvm_subscriber #(command_transaction);
   `uvm_component_utils(coverage)

   bit [4:0] taps;
   bit [4:0] start;
   bit [3:0] pre_len;
   bit [7:0] data_len;
  
   covergroup op_cov;

      coverpoint op_set {
         bins taps_values[] = {[]};
      }

   endgroup


   function new (string name, uvm_component parent);
      super.new(name, parent);
      op_cov = new();
      zeros_or_ones_on_ops = new();
   endfunction : new



   function void write(command_transaction t);
         taps = t.taps;
         start = t.start;
         pre_len = t.pre_len;
         data_len = t.data_len;
         op_cov.sample();
   endfunction : write

endclass : coverage






