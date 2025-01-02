`timescale 1ns/1ps
module test_bench;
	parameter N = 8;

	reg clk, rst_n, count_en, count_clr, count_dir;
	wire overflow;
	wire [N - 1: 0] count;

	reg exp_overflow;
	reg [N - 1: 0] exp_count;

	counter #(N) dut(
		.clk(clk),
		.rst_n(rst_n),
		.count_en(count_en),
		.count_clr(count_clr),
		.count_dir(count_dir),
		.overflow(overflow),
		.count(count)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	task verify;
		input exp_overflow, overflow;
		input [N - 1: 0] exp_count, count;
		begin
			$display("At time: %t, rst_n = %b, count_en = %b, count_clr = %b, count_dir = %b", $time, rst_n, count_en, count_clr, count_dir);
			if((overflow == exp_overflow)&&(count == exp_count)) begin
				$display("---------------------------------------------------------------------------------------------------------------------------------");
				$display("PASSED: Expected count = %d,Got count = %d, Expected overflow = 1'b%b, Got overflow: 1'b%b",exp_count, count, exp_overflow, overflow);
			   	$display("---------------------------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("---------------------------------------------------------------------------------------------------------------------------------");
				$display("FAILED: Expected count = %d,Got count = %d, Expected overflow = 1'b%b, Got overflow: 1'b%b",exp_count, count, exp_overflow, overflow);
				$display("---------------------------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);

		$display("----------------------------------------------------------------------------------------------------------------------------------");
		$display(" ---------------------------------------- TESTBENCH FOR COUNTER ------------------------------------------------------------------");
		$display("----------------------------------------------------------------------------------------------------------------------------------");

		rst_n = 0;
		count_en = 0;
		count_clr = 0;
		count_dir = 0;
		exp_count = 0;
		exp_overflow = 0;
		#1;
		verify(exp_overflow, overflow, exp_count, count);

		#10;
		rst_n = 1;
		@(posedge clk);
		verify(exp_overflow, overflow, exp_count, count);

		count_en = 1;
		count_dir = 1;
		repeat (2**N + 2) begin
			@(posedge clk);
			if (exp_count == {N{1'b1}}) begin
				exp_count = 0;
				exp_overflow = 1;
			end else begin
				exp_count = exp_count + 1;
				exp_overflow = 0;
			end
			verify(exp_overflow, overflow, exp_count, count);
		end

		count_clr = 1;
		@(posedge clk);
		exp_count = 0;
		exp_overflow = 0;
		verify(exp_overflow, overflow, exp_count, count);
		count_clr = 0;

		count_dir = 0;
		repeat (2**N + 2) begin
			@(posedge clk);
			if(exp_count == {N{1'b0}}) begin
				exp_overflow = 1;
		       		exp_count = {N{1'b1}};
			end else begin
				exp_count = exp_count - 1;
				exp_overflow = 0;
			end
			verify(exp_overflow, overflow, exp_count, count);
		end

		count_en = 0;
		@(posedge clk);
		verify(exp_overflow, overflow, exp_count, count);

		rst_n = 0;
		@(posedge clk);
		exp_overflow = 0;
		exp_count = 0;
		verify(exp_overflow, overflow, exp_count, count);

		#100;
		$finish;

	end
endmodule

