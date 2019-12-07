module block_break (CLOCK_50, reset, SW, KEY,
 VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK,
 VGA_HS, VGA_VS, VGA_SYNC_N);

	input CLOCK_50, reset;
	input [2:0] KEY, SW;
	output [7:0] VGA_R, VGA_G, VGA_B;
	output VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_VS, VGA_SYNC_N;
 
	reg CLK25;
	wire [7:0] inR, inG, inB;
	wire [9:0] px, py;
	wire game_clk;
 
 // generate 25MHz clock
	always @(posedge CLOCK_50 or posedge reset) begin
		if(reset) CLK25 <= 0;
		else CLK25 <= ~CLK25; // invert at each 50MHz clock is set. -> 25MHz
	end
 
	vga_sync u1 (CLK25, reset, inR, inG, inB, VGA_R, VGA_G, VGA_B,
					VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_VS, VGA_SYNC_N, px, py, game_clk);
	
	
	block_main u2 (game_clk, reset, KEY, px, py, inR, inG, inB);
	
	
	
	
	//test
	//assign inR = (px <= 200) ? 8'hFF : 8'h00;
	//assign inG = (px > 200 && px < 400) ? 8'hFF : 8'h00;
	//assign inB = (px >= 400 && px < 640) ? 8'hFF : 8'h00;
	
endmodule
