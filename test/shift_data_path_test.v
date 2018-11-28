// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_data_path_test ();

integer file_handle;

reg         write_en;
reg         clk;
reg  [31:0] data_in;
wire [31:0] w0;
wire [31:0] w1;
wire [31:0] w2;
wire [31:0] w3;
wire [31:0] w4;
wire [31:0] w5;

//Instantiate module under test
shift_data_path data_path (.clk(clk),
                      .write_en(write_en),
                      .data_in(data_in),
                      .w0(w0),
                      .w1(w1),
                      .w2(w2),
                      .w3(w3),
                      .w4(w4),
                      .w5(w5));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_data_path_test.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from the Data Path Module tests\n"); // Output title

  clk = 0;
	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
  if (write_en == 0) begin
    write_en = 1;
  end else begin
    write_en = 0;
  end

  data_in = data_in + 1;

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
initial
 begin
 
  $dumpfile ("shift_data_path_test.vcd");
  $dumpvars(0, shift_data_path_test);

 end

endmodule

