`ifndef outfile
	`define outfile "/dev/stdout"
`endif
module testbench;

integer i;
integer file;

reg [31:0] xorshift128_x = 123456789;
reg [31:0] xorshift128_y = 362436069;
reg [31:0] xorshift128_z = 521288629;
reg [31:0] xorshift128_w = 1559746896; // <-- seed value
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

reg [0:0] \sig_../notcnt1.aig_clk ;
\../notcnt1.aig  \uut_../notcnt1.aig (
	.clk(\sig_../notcnt1.aig_clk )
);

task \../notcnt1.aig_reset ;
begin
	\sig_../notcnt1.aig_clk  <= #2 0;
	#100;
	#100; \sig_../notcnt1.aig_clk  <= 1;
	#100; \sig_../notcnt1.aig_clk  <= 0;
	#0;
	#100; \sig_../notcnt1.aig_clk  <= 1;
	#100; \sig_../notcnt1.aig_clk  <= 0;
	#0;
end
endtask

task \../notcnt1.aig_update_data ;
begin
	#0;
end
endtask

task \../notcnt1.aig_update_clock ;
begin
	xorshift128;
	{ \sig_../notcnt1.aig_clk  } = { \sig_../notcnt1.aig_clk  } ^ (1'b1 << (xorshift128_w % 2));
end
endtask

task \../notcnt1.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { 1'bx }, { \sig_../notcnt1.aig_clk  }, { 1'bx }, $time, i);
end
endtask

task \../notcnt1.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../notcnt1.aig_clk ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "#", " ", "A", " ", "#"});
end
endtask

task \../notcnt1.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../notcnt1.aig  ====");
	\../notcnt1.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../notcnt1.aig_print_header ;
		#100; \../notcnt1.aig_update_data ;
		#100; \../notcnt1.aig_update_clock ;
		#100; \../notcnt1.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../notcnt1.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
