// position of airplane
module airplane_pos (game_clk, reset, KEY, apx, apy);
	input reset, game_clk;
	input [2:0] KEY;	
	output reg [9:0] apx;
	output [9:0] apy;
	
	assign apy = 400;
	always @(posedge game_clk or posedge reset) begin
		if(reset) begin apx <= 340; end
		else begin
			if(~KEY[0]) begin // if KEY0 is pushed
				if(apx >= 659 ) apx <= apx; // out of range : nothing   // apx >= less than 659 -> error.. why?? :(
				else apx <= apx + 1;
			end
			else if (~KEY[1]) begin
				if( apx <= 20) apx <= apx;// nothing
				else apx <= apx - 1;
			end
		end
	end
endmodule
