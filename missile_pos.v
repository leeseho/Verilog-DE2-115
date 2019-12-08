module missile_pos (game_clk, reset, KEY, apx, apy, mpx, mpy, hit, mstate);
	input game_clk, reset;
	input [2:0] KEY;
	input [9:0] apx, apy;
	output reg [9:0] mpy, mpx;
	output reg hit;
	parameter block_size = 100;
	parameter S0 = 0, S1 = 1;
	output reg mstate;

	always @(posedge game_clk or posedge reset) begin
		if (reset) begin mstate <= S0; end
		else begin
			case(mstate)
			S0: if(~KEY[2]) begin mstate <= S1;  mpx <= apx; mpy <= apy; end
			S1: begin
				if (mpx <= 600 && mpy == block_size) hit <= 1;
				else hit <= 0;
				if (mpy > 0) mpy <= mpy - 1;
				else mstate <= S0;
			end
			default : mstate <= S0;
			endcase
		end
	end
endmodule
