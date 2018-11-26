// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_8_multi_read_test ();

integer file_handle;

reg         clk;
reg         write_en;
reg  [31:0] data_in;
wire [31:0] data_out;
wire [31:0] word_1;
wire [31:0] word_2;

//Instantiate module under test
shift_8_multi_read shift (.clk(clk),
                .write_en(write_en),
                .data_in(data_in),
                .data_out(data_out),
                .word_1(word_1),
                .word_2(word_2));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_8_read_multi_test.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Shift Register 8 Bit Module tests\n"); // Output title

  clk = 0;
  data_in = 0;
  write_en = 1;

	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
	$display(file_handle, "Set up input signals.");
  // write_en = 0;
  #10
  data_in = data_in + 1;
  // write_en = 1;
end


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Set up clock input																						              */
always #10 clk = ~clk;


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Standard timeout, stopping runaway execution.                              */
initial 
  begin
  #10000
  $fclose(file_handle);
  $stop;
  end


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* //Dump a vcd file for GTKWave.                                             */
reg [32:0] idx;

initial
 begin
 
  $dumpfile ("shift_8_multi_read_test.vcd");
  $dumpvars(0, shift_8_multi_read_test);
  
 end

endmodule

