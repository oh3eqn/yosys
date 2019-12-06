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

reg [0:0] \sig_../halfadder.aig_y ;
reg [0:0] \sig_../halfadder.aig_x ;
wire [0:0] \sig_../halfadder.aig_s ;
wire [0:0] \sig_../halfadder.aig_c ;
\../halfadder.aig  \uut_../halfadder.aig (
	.y(\sig_../halfadder.aig_y ),
	.x(\sig_../halfadder.aig_x ),
	.s(\sig_../halfadder.aig_s ),
	.c(\sig_../halfadder.aig_c )
);

task \../halfadder.aig_reset ;
begin
	\sig_../halfadder.aig_x  <= #2 0;
	\sig_../halfadder.aig_y  <= #4 0;
	#100;
	\sig_../halfadder.aig_x  <= #2 ~0;
	\sig_../halfadder.aig_y  <= #4 ~0;
	#100;
	#0;
end
endtask

task \../halfadder.aig_update_data ;
begin
	xorshift128;
	\sig_../halfadder.aig_x  <= #2 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	xorshift128;
	\sig_../halfadder.aig_y  <= #4 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	#100;
end
endtask

task \../halfadder.aig_update_clock ;
begin
end
endtask

task \../halfadder.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { \sig_../halfadder.aig_x , \sig_../halfadder.aig_y  }, { 1'bx }, { \sig_../halfadder.aig_c , \sig_../halfadder.aig_s  }, $time, i);
end
endtask

task \../halfadder.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../halfadder.aig_x ");
	$fdisplay(file, "#OUT#   B   \sig_../halfadder.aig_y ");
	$fdisplay(file, "#OUT#   C   \sig_../halfadder.aig_c ");
	$fdisplay(file, "#OUT#   D   \sig_../halfadder.aig_s ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "A", "B", " ", "#", " ", "C", "D"});
end
endtask

task \../halfadder.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../halfadder.aig  ====");
	\../halfadder.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../halfadder.aig_print_header ;
		#100; \../halfadder.aig_update_data ;
		#100; \../halfadder.aig_update_clock ;
		#100; \../halfadder.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../halfadder.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
