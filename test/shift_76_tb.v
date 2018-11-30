// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_76_tb ();

integer file_handle;

reg         clk;
reg         write_en;
reg  [06:0] addr;
reg  [31:0] wr_data;
wire [31:0] rd_data;


//Instantiate module under test
shift_76 shift (.clk(clk),
                .write_en(write_en),
                .addr(addr),
                .wr_data(wr_data),
                .rd_data(rd_data));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_76_tb.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Shift Register 76 deep, 32 bit wide module tests\n"); // Output title

  clk = 0;
  addr = 0;
  wr_data = 0;
  write_en = 1;

	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
  // write_en = 0;
  #10

  if (addr > 71) begin
    addr = 0;
  end else begin
    addr = addr + 1;
  end

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
 
  $dumpfile ("shift_76_tb.vcd");
  $dumpvars(0, shift_76_tb);

  for (idx = 0; idx < 75; idx = idx + 1) begin
      $dumpvars(0, shift.memory[idx]);
  end
  
 end

endmodule

