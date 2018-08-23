module counter(input clk, load, input [9:0] data, output tc);

	// your code here
	logic [9:0] R;
	
	// Register
	always @(posedge clk) begin
		if (load) begin 
			R <= data;
		end else if (R == 0) begin
			R <= 0;
		end else begin
			R <= R-1;
		end
	end
	
	assign tc = (R == 0);
	
endmodule

module counter_tb;
	logic clk, load;
	logic [9:0] data;
	logic tc;

	counter dut(.clk(clk), .load(load), .data(data), .tc(tc));

	initial begin
		clk = 1; forever #5 clk = ~clk;
	end

	initial begin
		data = 3; load = 1;
		#10 load = 0;
		$monitor("t=%2d tc=%1b", $time, tc);
		#40 data = 2; load = 1;
		#10 load = 0;
		#60 $stop;
	end

	initial $dumpvars(0, counter_tb); // needed for gtkwave

endmodule
