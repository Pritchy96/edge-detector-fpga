// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_data_path_mock_tb ();

integer file_handle;

reg         clk;
reg         datastore_write_en;
reg         write_en;
reg  [06:0] addr;
reg  [31:0] data_in;
wire [31:0] rd_data;
wire        ready;

wire [31:0] shift_2_line_1_out;
wire [31:0] shift_76_line_1_out;
wire [31:0] shift_2_line_2_out;
wire [31:0] w5;
wire [31:0] w4;
wire [31:0] w3;
wire [31:0] w2;
wire [31:0] w1;
wire [31:0] w0;

//Instantiate module under test

shift_2 shift_2_line_1 (.clk(clk),
                        .write_en(datastore_write_en),
                        .data_in(data_in),
                        .data_out(shift_2_line_1_out),
                        .word_1(w5),
                        .word_2(w4));


shift_76 shift (.clk(clk),
                .write_en(datastore_write_en),
                .wr_addr(addr),
                .wr_data(shift_2_line_1_out),
                .rd_data(shift_76_line_1_out),
                .ready(ready));


shift_2 shift_2_line_2 (.clk(clk),
                        .write_en(datastore_write_en),
                        .data_in(shift_76_line_1_out),
                        .data_out(shift_2_line_2_out),
                        .word_1(w3),
                        .word_2(w2));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_data_path_mock_tb.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Shift Register 76 deep, 32 bit wide module tests\n"); // Output title

  clk = 0;
  addr = 0;
  data_in = 0;
  write_en = 1;
  datastore_write_en = 0;

	$display(file_handle, "Set up input signals.");
end

//Add some delays to test write_en
initial begin
 #2100
 write_en = 0;
 #450
 write_en = 1;
end

//Increment address if we can write.
//Should this be inside shift_76??
always @ (posedge clk) begin
  if (write_en) begin
      if (addr > 71) begin
        addr <= 0;
      end else begin
        addr <= addr + 1;
      end

      data_in <= data_in + 1;
      datastore_write_en = 1;
    end else begin
      datastore_write_en <= 0;
    end
end


always @ (posedge clk) begin
  if (write_en) begin
    end
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
 
  $dumpfile ("shift_data_path_mock_tb..vcd");
  $dumpvars(0, shift_data_path_mock_tb);

  for (idx = 0; idx < 75; idx = idx + 1) begin
      $dumpvars(0, shift.memory[idx]);
  end
  
 end

endmodule

