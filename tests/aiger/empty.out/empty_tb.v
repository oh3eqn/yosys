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

\../empty.aig  \uut_../empty.aig (
);

task \../empty.aig_reset ;
begin
	#0;
	#0;
	#0;
end
endtask

task \../empty.aig_update_data ;
begin
	#0;
end
endtask

task \../empty.aig_update_clock ;
begin
end
endtask

task \../empty.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { 1'bx }, { 1'bx }, { 1'bx }, $time, i);
end
endtask

task \../empty.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "#", " ", "#", " ", "#"});
end
endtask

task \../empty.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../empty.aig  ====");
	\../empty.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../empty.aig_print_header ;
		#100; \../empty.aig_update_data ;
		#100; \../empty.aig_update_clock ;
		#100; \../empty.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../empty.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
