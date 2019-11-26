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

reg [0:0] \sig_../notcnt1e.aig_n1 ;
reg [0:0] \sig_../notcnt1e.aig_clk ;
\../notcnt1e.aig  \uut_../notcnt1e.aig (
	.n1(\sig_../notcnt1e.aig_n1 ),
	.clk(\sig_../notcnt1e.aig_clk )
);

task \../notcnt1e.aig_reset ;
begin
	\sig_../notcnt1e.aig_n1  <= #2 0;
	\sig_../notcnt1e.aig_clk  <= #4 0;
	#100;
	#100; \sig_../notcnt1e.aig_clk  <= 1;
	#100; \sig_../notcnt1e.aig_clk  <= 0;
	\sig_../notcnt1e.aig_n1  <= #2 ~0;
	#100;
	#100; \sig_../notcnt1e.aig_clk  <= 1;
	#100; \sig_../notcnt1e.aig_clk  <= 0;
	#0;
end
endtask

task \../notcnt1e.aig_update_data ;
begin
	xorshift128;
	\sig_../notcnt1e.aig_n1  <= #2 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	#100;
end
endtask

task \../notcnt1e.aig_update_clock ;
begin
	xorshift128;
	{ \sig_../notcnt1e.aig_clk  } = { \sig_../notcnt1e.aig_clk  } ^ (1'b1 << (xorshift128_w % 2));
end
endtask

task \../notcnt1e.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { \sig_../notcnt1e.aig_n1  }, { \sig_../notcnt1e.aig_clk  }, { 1'bx }, $time, i);
end
endtask

task \../notcnt1e.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../notcnt1e.aig_n1 ");
	$fdisplay(file, "#OUT#   B   \sig_../notcnt1e.aig_clk ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "A", " ", "B", " ", "#"});
end
endtask

task \../notcnt1e.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../notcnt1e.aig  ====");
	\../notcnt1e.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../notcnt1e.aig_print_header ;
		#100; \../notcnt1e.aig_update_data ;
		#100; \../notcnt1e.aig_update_clock ;
		#100; \../notcnt1e.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../notcnt1e.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
