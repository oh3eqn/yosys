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

reg [0:0] \sig_../cnt1.aig_clk ;
\../cnt1.aig  \uut_../cnt1.aig (
	.clk(\sig_../cnt1.aig_clk )
);

task \../cnt1.aig_reset ;
begin
	\sig_../cnt1.aig_clk  <= #2 0;
	#100;
	#100; \sig_../cnt1.aig_clk  <= 1;
	#100; \sig_../cnt1.aig_clk  <= 0;
	#0;
	#100; \sig_../cnt1.aig_clk  <= 1;
	#100; \sig_../cnt1.aig_clk  <= 0;
	#0;
end
endtask

task \../cnt1.aig_update_data ;
begin
	#0;
end
endtask

task \../cnt1.aig_update_clock ;
begin
	xorshift128;
	{ \sig_../cnt1.aig_clk  } = { \sig_../cnt1.aig_clk  } ^ (1'b1 << (xorshift128_w % 2));
end
endtask

task \../cnt1.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { 1'bx }, { \sig_../cnt1.aig_clk  }, { 1'bx }, $time, i);
end
endtask

task \../cnt1.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../cnt1.aig_clk ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "#", " ", "A", " ", "#"});
end
endtask

task \../cnt1.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../cnt1.aig  ====");
	\../cnt1.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../cnt1.aig_print_header ;
		#100; \../cnt1.aig_update_data ;
		#100; \../cnt1.aig_update_clock ;
		#100; \../cnt1.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../cnt1.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
