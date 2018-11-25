// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_32_test ();

integer file_handle;

reg         clk;
reg         write_en;
reg  [06:0] addr;
reg  [31:0] wr_data;
wire [31:0] rd_data;


//Instantiate module under test
shift_32 shift (.clk(clk),
                .write_en(write_en),
                .addr(addr),
                .wr_data(wr_data),
                .rd_data(rd_data));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_32_test.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Shift Register 32 Bit Module tests\n"); // Output title

  clk = 0;
  addr = 0;
  wr_data = 0;
  write_en = 1;

	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
	$display(file_handle, "Set up input signals.");
  // write_en = 0;
  #10
  addr = addr + 1;
  wr_data = wr_data + 1;
  write_en = 1;
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
 
  $dumpfile ("shift_32_test.vcd");
  $dumpvars(0, shift_32_test);

  for (idx = 0; idx < 71; idx = idx + 1) begin
      $dumpvars(0, shift.memory[idx]);
  end
  
 end

endmodule

