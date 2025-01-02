module counter #(parameter N = 8) (
	input wire clk,
	input wire rst_n,
	input wire count_en,
	input wire count_clr,
	input wire count_dir,
	output reg overflow,
	output reg [N - 1: 0] count
);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= {N{1'b0}};
		overflow <= 1'b0;
	end else begin
		count <= (count_clr) ? 0 : ((!count_en) ? count : (count_dir) ? count + 1 : count - 1 );
		overflow <= (count_dir) ? ((count == {N{1'b1}}) && count_en) : ((count == {N{1'b0}}) && count_en);
	end
end

endmodule

