module plru(output reg hit, input [15:0] address, input reset, clk);
	parameter offBits=4, setBits=6, w=4;

	logic [w-1:0][15-setBits-offBits:0] tagArray [0:2**setBits-1];
	logic [w-1:0] valid [0:2**setBits-1];
	logic [w-1:0] used [0:2**setBits-1];

	logic [15-setBits-offBits:0] Tag;
	
	// your code here
	generate 
		genvar i;
		for (i = 0; i < (2**setBits)-1; i = i + 1) begin
			always @(posedge clk) begin
				// Get the tag from the provided address
				Tag = address[15:(setBits+offBits)];
				if (reset) begin
					used[i] <= 0;
					valid[i] <= 0;
				end else begin
					if ((valid[i][0] == 1) && (tagArray[i][0] == Tag)) begin
						used[i][0] <= 1;
						hit <= 1;
					end else if ((valid[i][1] == 1) && (tagArray[i][1] == Tag)) begin
						used[i][1] <= 1;
						hit <= 1;
					end else if ((valid[i][2] == 1) && (tagArray[i][2] == Tag)) begin
						used[i][2] <= 1;
						hit <= 1;
					end else if ((valid[i][3] == 1) && (tagArray[i][3] == Tag)) begin
						used[i][3] <= 1;
						hit <= 1;
					end else begin
						hit <= 0;
						if (used[i][0] == 0) begin 
							used[i][0] <= 1;
							valid[i][0] <= 1;
							tagArray[i][0] <= Tag;
						end else if (used[i][1] == 0) begin 
							used[i][1] <= 1;
							valid[i][1] <= 1;
							tagArray[i][1] <= Tag;
						end else if (used[i][2] == 0) begin
							used[i][2] <= 1;
							valid[i][2] <= 1;
							tagArray[i][2] <= Tag;
						end else if (used[i][3] == 0) begin
							used[i][3] <= 1;
							valid[i][3] <= 1;
							tagArray[i][3] <= Tag;
							used[i][0] <= 0;
							used[i][1] <= 0;
							used[i][2] <= 0;
						end
					end
				end
			end
		end
	endgenerate
	
endmodule

module plru_tb;
	logic hit, reset, clk;
	logic [15:0] address;
	plru #(.setBits(4)) dut(.hit(hit), .address(address), .reset(reset),
		.clk(clk));

	initial begin
		clk = 1; forever #5 clk = ~clk;
	end

	initial $monitor("t=%2d: address %4h hit %b", $time, address, hit);
	
	/*initial $monitor("t=%2d: address %4h hit %b", $time, address, hit,
		"\n\t[0][0] tag=%2h valid=%b used=%b", dut.tagArray[0][0],
			dut.valid[0][0], dut.used[0][0],
		"\n\t[0][1] tag=%2h valid=%b used=%b", dut.tagArray[0][1],
			dut.valid[0][1], dut.used[0][1],
		"\n\t[0][2] tag=%2h valid=%b used=%b", dut.tagArray[0][2],
			dut.valid[0][2], dut.used[0][2],
		"\n\t[0][3] tag=%2h valid=%b used=%b", dut.tagArray[0][3],
			dut.valid[0][3], dut.used[0][3]);*/
	
	initial begin
		reset = 1;
		# 10 address = 16'h0000; reset = 0;
		# 10 address = 16'h0010;
		# 10 address = 16'h0000;
		# 10 address = 16'h0010;
		# 10 address = 16'h0100;
		# 10 address = 16'h0200;
		# 10 address = 16'h0300;
		# 10 address = 16'h0400;
		# 10 address = 16'h0100;
		# 10 address = 16'h0300;
		# 10 address = 16'h0300;
		# 10 address = 16'h0000;
		# 10 address = 16'h0200;
		# 10 $stop;
	end

	initial $dumpvars(0, plru_tb); // needed for gtkwave
endmodule
