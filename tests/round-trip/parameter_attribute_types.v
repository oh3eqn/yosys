module box (I, O);
  input  wire I;
  output wire O;

  // Parameters
  (* ATTR_INTEGER = 5 *)
  parameter PARAM_A = 10;
  (* ATTR_STRING = "this is a string" *)
  parameter PARAM_B = 20;

  // Localparams
  (* ATTR_INTEGER = 10 *)
  localparam LOCALPARAM_A = 50;
  (* ATTR_STRING = "this is another string" *)
  localparam LOCALPARAM_B = 60;

  assign O = I;

endmodule
