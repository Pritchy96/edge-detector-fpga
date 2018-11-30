// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_2_tb ();

integer file_handle;

reg         clk;
reg         write_en;
reg  [31:0] data_in;
wire [31:0] data_out;
wire [31:0] word_1;
wire [31:0] word_2;

//Instantiate module under test
shift_2 shift(.clk(clk),
              .write_en(write_en),
              .data_in(data_in),
              .data_out(data_out),
              .word_1(word_1),
              .word_2(word_2));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_2_tb.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Shift Register 2 deep, 32 bit wide module tests\n"); // Output title

  clk = 0;
  data_in = 0;
  write_en = 1;

	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
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
 
  $dumpfile ("shift_2_tb.vcd");
  $dumpvars(0, shift_2_tb);
  
 end

endmodule

