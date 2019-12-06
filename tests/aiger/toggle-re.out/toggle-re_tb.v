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

reg [0:0] \sig_../toggle-re.aig_reset ;
reg [0:0] \sig_../toggle-re.aig_enable ;
reg [0:0] \sig_../toggle-re.aig_clk ;
wire [0:0] \sig_../toggle-re.aig_Q ;
wire [0:0] \sig_../toggle-re.aig_!Q ;
\../toggle-re.aig  \uut_../toggle-re.aig (
	.reset(\sig_../toggle-re.aig_reset ),
	.enable(\sig_../toggle-re.aig_enable ),
	.clk(\sig_../toggle-re.aig_clk ),
	.Q(\sig_../toggle-re.aig_Q ),
	.\!Q (\sig_../toggle-re.aig_!Q )
);

task \../toggle-re.aig_reset ;
begin
	\sig_../toggle-re.aig_enable  <= #2 0;
	\sig_../toggle-re.aig_reset  <= #4 0;
	\sig_../toggle-re.aig_clk  <= #6 0;
	#100;
	#100; \sig_../toggle-re.aig_clk  <= 1;
	#100; \sig_../toggle-re.aig_clk  <= 0;
	\sig_../toggle-re.aig_enable  <= #2 ~0;
	\sig_../toggle-re.aig_reset  <= #4 ~0;
	#100;
	#100; \sig_../toggle-re.aig_clk  <= 1;
	#100; \sig_../toggle-re.aig_clk  <= 0;
	#0;
end
endtask

task \../toggle-re.aig_update_data ;
begin
	xorshift128;
	\sig_../toggle-re.aig_enable  <= #2 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	xorshift128;
	\sig_../toggle-re.aig_reset  <= #4 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	#100;
end
endtask

task \../toggle-re.aig_update_clock ;
begin
	xorshift128;
	{ \sig_../toggle-re.aig_clk  } = { \sig_../toggle-re.aig_clk  } ^ (1'b1 << (xorshift128_w % 2));
end
endtask

task \../toggle-re.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { \sig_../toggle-re.aig_enable , \sig_../toggle-re.aig_reset  }, { \sig_../toggle-re.aig_clk  }, { \sig_../toggle-re.aig_!Q , \sig_../toggle-re.aig_Q  }, $time, i);
end
endtask

task \../toggle-re.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../toggle-re.aig_enable ");
	$fdisplay(file, "#OUT#   B   \sig_../toggle-re.aig_reset ");
	$fdisplay(file, "#OUT#   C   \sig_../toggle-re.aig_clk ");
	$fdisplay(file, "#OUT#   D   \sig_../toggle-re.aig_!Q ");
	$fdisplay(file, "#OUT#   E   \sig_../toggle-re.aig_Q ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "A", "B", " ", "C", " ", "D", "E"});
end
endtask

task \../toggle-re.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../toggle-re.aig  ====");
	\../toggle-re.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../toggle-re.aig_print_header ;
		#100; \../toggle-re.aig_update_data ;
		#100; \../toggle-re.aig_update_clock ;
		#100; \../toggle-re.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../toggle-re.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
