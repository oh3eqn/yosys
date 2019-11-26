`ifndef outfile
	`define outfile "/dev/stdout"
`endif
module testbench;

integer i;
integer file;

reg [31:0] xorshift128_x = 123456789;
reg [31:0] xorshift128_y = 362436069;
reg [31:0] xorshift128_z = 521288629;
reg [31:0] xorshift128_w = 1559746897; // <-- seed value
reg [31:0] xorshift128_t;

task xorshift128;
begin
	xorshift128_t = xorshift128_x ^ (xorshift128_x << 11);
	xorshift128_x = xorshift128_y;
	xorshift128_y = xorshift128_z;
	xorshift128_z = xorshift128_w;
	xorshift128_w = xorshift128_w ^ (xorshift128_w >> 19) ^ xorshift128_t ^ (xorshift128_t >> 8);
end
endtask

wire [0:0] \sig_../or.aig_n3_inv ;
reg [0:0] \sig_../or.aig_n2 ;
reg [0:0] \sig_../or.aig_n1 ;
\../or.aig  \uut_../or.aig (
	.n3_inv(\sig_../or.aig_n3_inv ),
	.n2(\sig_../or.aig_n2 ),
	.n1(\sig_../or.aig_n1 )
);

task \../or.aig_reset ;
begin
	\sig_../or.aig_n1  <= #2 0;
	\sig_../or.aig_n2  <= #4 0;
	#100;
	\sig_../or.aig_n1  <= #2 ~0;
	\sig_../or.aig_n2  <= #4 ~0;
	#100;
	#0;
end
endtask

task \../or.aig_update_data ;
begin
	xorshift128;
	\sig_../or.aig_n1  <= #2 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	xorshift128;
	\sig_../or.aig_n2  <= #4 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	#100;
end
endtask

task \../or.aig_update_clock ;
begin
end
endtask

task \../or.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { \sig_../or.aig_n1 , \sig_../or.aig_n2  }, { 1'bx }, { \sig_../or.aig_n3_inv  }, $time, i);
end
endtask

task \../or.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../or.aig_n1 ");
	$fdisplay(file, "#OUT#   B   \sig_../or.aig_n2 ");
	$fdisplay(file, "#OUT#   C   \sig_../or.aig_n3_inv ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "A", "B", " ", "#", " ", "C"});
end
endtask

task \../or.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../or.aig  ====");
	\../or.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../or.aig_print_header ;
		#100; \../or.aig_update_data ;
		#100; \../or.aig_update_clock ;
		#100; \../or.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../or.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
