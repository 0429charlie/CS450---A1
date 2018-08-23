module cordic(input clk, go, input [15:0] a,
	output logic done, output logic [15:0] sin, cos);

	logic [15:0] e [0:15];
	assign e[0] = 16'h3244;
	assign e[1] = 16'h1dac;
	assign e[2] = 16'h0fae;
	assign e[3] = 16'h07f5;
	assign e[4] = 16'h03ff;
	assign e[5] = 16'h0200;
	assign e[6] = 16'h0100;
	assign e[7] = 16'h0080;
	assign e[8] = 16'h0040;
	assign e[9] = 16'h0020;
	assign e[10] = 16'h0010;
	assign e[11] = 16'h0008;
	assign e[12] = 16'h0004;
	assign e[13] = 16'h0002;
	assign e[14] = 16'h0001;
	assign e[15] = 16'h0000;

	logic [15:0] x_0 = 16'h26dd;

	logic signed [15:0] x, y, z;
	
	int c;

	// your code here
	always @(posedge clk) begin
		if (go == 1) begin
			c <= 0;
			x <= x_0;
			y <= 0;
			z <= a;
			done <= 0;
		end else begin
			if (c == 16) begin 
				sin <= y;
				cos <= x; 
				done <= 1;
			end else begin
				if (z < 0) begin
					x <= x + (y >>> c);
					y <= y - (x >>> c);
					z <= z + e[c];
				end else begin
					x <= x - (y >>> c);
					y <= y + (x >>> c);
					z <= z - e[c];
				end
				c <= c + 1;
			end
		end
	end

endmodule

module cordic_tb;
	logic clk, go, done;
	logic [15:0] a, sin, cos;
	cordic dut(.clk(clk), .go(go), .a(a), .done(done), .sin(sin), .cos(cos));

	initial begin
		clk = 1; forever #5 clk = ~clk;
	end

	initial begin
		a = 16'h0; // angle = 0 rad
		go = 1;
		#10 go = 0;
		wait(done==1)
			// should display roughly sin=0000 and cos=4000 in hexadecimal
			$display("t=%3d sin=%4h cos=%4h", $time, sin, cos);

		#10 a = 16'h4000; // angle = 1 rad
		go = 1;
		#10 go = 0;
		wait(done==1)
			// should display roughly sin=35da and cos=2294 in hexadecimal
			$display("t=%3d sin=%4h cos=%4h", $time, sin, cos);

		#10 $stop;
	end

	initial $dumpvars(0,cordic_tb); // needed for gtkwave

endmodule
