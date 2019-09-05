module child_no_params (I, O);
 input wire I;
 output wire O;
 
 assign O = I[0];
endmodule

module child (I, O);
 (* CHILD_ATTR = 1 *)
 parameter CHILD_WIDTH = 1;
 (* CHILD_ATTR2 = 0 *)
 localparam CHILD_LOCALPARAM = CHILD_WIDTH;

 input  wire [CHILD_LOCALPARAM-1:0] I;
 output wire O;

 assign O = I[0];
endmodule

module parent (I, O1, O2);
 (* PARENT_ATTR = "parent_attr" *)
 parameter PARENT_WIDTH = 1;
 parameter PARENT_MODE = "MODE_NAME";
 parameter [7:0] PARENT_STUFF = 0;

 input  wire [PARENT_WIDTH-1:0] I;
 output wire O1;
 output wire O2;

 child #(.CHILD_WIDTH(PARENT_WIDTH)) child_inst1 (I, O1);

 child child_inst2 (I[0], O2);

endmodule
