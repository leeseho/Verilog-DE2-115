module block_main(game_clk, reset, KEY, px, py, inR, inG, inB);
	input [9:0] px; // 
	input [8:0] py; // x, y pixel position that soon output
	input reset, game_clk;
	input [2:0] KEY; // control key : right, left, shoot
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
	parameter block_size = 100;
	
	output [7:0] inR, inG, inB;
	wire [9:0] apx, apy; 	//apx : airplane position X, apy : airplane position Y.
	wire [9:0] mpx, mpy; // missile's position
	integer block_col;
	wire airplane;
	wire missiles;
	wire block;
	wire hit; // variable for determine hit by missile
	wire mstate; // missile's state

	
	// airplane
	airplane_pos u3 (game_clk, reset, KEY, apx, apy);
	
	// missile
	missile_pos u4 (game_clk, reset, KEY, apx, apy, mpx, mpy, hit, mstate);
	
	// block_col
	always @(posedge game_clk or posedge reset) begin
		if (reset) block_col <= 8'hB0;
		else begin
			if (block_col != 8'h00) begin
				if (hit) block_col <= block_col - 8'h01;			
			end
		end
	end
	
	
	assign airplane = ((px >= apx -(py - apy)) && (px <= apx +(py - apy))) &&
									((py >= apy) && (py <= apy + 20)); // triangle
	
	assign missiles = ((px >= mpx -(py - mpy)) && (px <= mpx +(py - mpy))) &&
									((py >= mpy) && (py <= mpy + 6)) && (mstate == S1); // print only S1
	
	assign block = ((px <= 680) && (px >= 0)) && ((py <= block_size) && (py >= 0));
	
	assign inR = airplane ? 8'hF0 : 8'h00;
	assign inG = block ? block_col : 8'h00; // 
	assign inB = missiles ? 8'hF0 : 8'h00; 
endmodule
