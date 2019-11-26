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

wire [0:0] \sig_../inverter.aig_n1_inv ;
reg [0:0] \sig_../inverter.aig_n1 ;
\../inverter.aig  \uut_../inverter.aig (
	.n1_inv(\sig_../inverter.aig_n1_inv ),
	.n1(\sig_../inverter.aig_n1 )
);

task \../inverter.aig_reset ;
begin
	\sig_../inverter.aig_n1  <= #2 0;
	#100;
	\sig_../inverter.aig_n1  <= #2 ~0;
	#100;
	#0;
end
endtask

task \../inverter.aig_update_data ;
begin
	xorshift128;
	\sig_../inverter.aig_n1  <= #2 { xorshift128_x, xorshift128_y, xorshift128_z, xorshift128_w };
	#100;
end
endtask

task \../inverter.aig_update_clock ;
begin
end
endtask

task \../inverter.aig_print_status ;
begin
	$fdisplay(file, "#OUT# %b %b %b %t %d", { \sig_../inverter.aig_n1  }, { 1'bx }, { \sig_../inverter.aig_n1_inv  }, $time, i);
end
endtask

task \../inverter.aig_print_header ;
begin
	$fdisplay(file, "#OUT#");
	$fdisplay(file, "#OUT#   A   \sig_../inverter.aig_n1 ");
	$fdisplay(file, "#OUT#   B   \sig_../inverter.aig_n1_inv ");
	$fdisplay(file, "#OUT#");
	$fdisplay(file, {"#OUT# ", "A", " ", "#", " ", "B"});
end
endtask

task \../inverter.aig_test ;
begin
	$fdisplay(file, "#OUT#\n#OUT# ==== \../inverter.aig  ====");
	\../inverter.aig_reset ;
	for (i=0; i<1000; i=i+1) begin
		if (i % 20 == 0) \../inverter.aig_print_header ;
		#100; \../inverter.aig_update_data ;
		#100; \../inverter.aig_update_clock ;
		#100; \../inverter.aig_print_status ;
	end
end
endtask

initial begin
	// $dumpfile("testbench.vcd");
	// $dumpvars(0, testbench);
	file = $fopen(`outfile);
	\../inverter.aig_test ;
	$fclose(file);
	$finish;
end

endmodule
