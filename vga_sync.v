module vga_sync (CLK25, reset, inR, inG, inB,
 VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK,
 VGA_HS, VGA_VS, VGA_SYNC_N,
 px, py, game_clk);
 
	input CLK25, reset;
	input [7:0] inR, inG, inB;
 
	output reg [9:0] px;
	output reg [8:0] py;
	output reg VGA_HS, VGA_VS;
	output VGA_BLANK_N, VGA_CLK, VGA_SYNC_N;
	output [7:0] VGA_R, VGA_G, VGA_B;
	output game_clk;
 
 
	reg video_on;
	reg [9:0] hcount; // 0~799
	reg [8:0] vcount; // 0~524
 
 
 // horizontal count
	always @(posedge CLK25 or posedge reset) begin
		if(reset) hcount <= 0;
		else begin
			if(hcount == 799) hcount <= 0;
			else	hcount <= hcount + 1;
		end
	end
 
 // h sync : signal for monitor output of pixel
	always @(posedge CLK25) begin
		if((hcount >= 659) && (hcount <= 755)) VGA_HS <= 0; // Active Low
		else VGA_HS <= 1;
	end
 
 
 
 // vertical count
	always @(posedge CLK25 or posedge reset) begin
		if(reset) vcount <= 0;
		else if (hcount == 799) begin
			if(vcount == 524) vcount <= 0;
			else vcount <= vcount +1;
		end
	end
 
 // v sync : line signal
	always @(posedge CLK25) begin
		if(vcount >= 493 && vcount <= 494) VGA_VS <= 0;
		else VGA_VS <= 1;
	end
 
 
	always @(posedge CLK25) begin
		video_on <= (hcount <= 639) && (vcount <= 479);
		px <= hcount;
		py <= vcount;
	end
	
	assign game_clk = (hcount >= 640 && hcount <= 799 && vcount <= 524 && vcount >= 480); // 60Hz.. consider delay!
	// hcount == 799 && vcount == 524.. can't satisfiy "hold time" condition. maybe..
	
	assign VGA_CLK = ~CLK25;
	assign VGA_BLANK_N = VGA_HS & VGA_VS;
	assign VGA_SYNC_N = 1'b0;
 
	assign VGA_R = video_on? inR : 8'h00;
	assign VGA_G = video_on? inG : 8'h00;
	assign VGA_B = video_on? inB : 8'h00;
endmodule
