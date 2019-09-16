module box (I, O);
  input  wire I;
  output wire O;

  // Parameters
  (* ATTR_INTEGER = 5 *)
  parameter PARAM_A = 10;
  (* ATTR_STRING = "this is a string" *)
  parameter PARAM_B = 20;
//  (* ATTR_REAL = 2.718 *)
//  parameter PARAM_C = 30;

  // Localparams
  (* ATTR_INTEGER = 10 *)
  localparam LOCALPARAM_A = 50;
  (* ATTR_STRING = "this is another string" *)
  localparam LOCALPARAM_B = 60;
//  (* ATTR_REAL = 5.678 *)
//  localparam LOCAKPARAM_C = 70;

  assign O = I;

endmodule
