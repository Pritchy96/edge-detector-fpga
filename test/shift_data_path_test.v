// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module shift_data_path_test ();

integer file_handle;

reg         clk;
wire [31:0] p0;
wire [31:0] p1;
wire [31:0] p2;
wire [31:0] p3;
wire [31:0] p4;
wire [31:0] p5;
wire [31:0] p6;
wire [31:0] p7;
wire [31:0] p8;
wire [31:0] p9;
wire [31:0] p10;
wire [31:0] p11;
wire [31:0] p12;
wire [31:0] p13;
wire [31:0] p14;
wire [31:0] p15;
wire [31:0] p16;
wire [31:0] p17;


//Instantiate module under test
shift_data_path data_path (.clk(clk),
                      .p0(p0),
                      .p1(p1),
                      .p2(p2),
                      .p3(p3),
                      .p4(p4),
                      .p5(p5),
                      .p6(p6),
                      .p7(p7),
                      .p8(p8),
                      .p9(p9),
                      .p10(p10),
                      .p11(p11),
                      .p12(p12),
                      .p13(p13),
                      .p14(p14),
                      .p15(p15),
                      .p16(p16),
                      .p17(p17));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin
  file_handle = $fopen("shift_data_path_test.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from the Data Path Module tests\n"); // Output title

  clk = 0;
	$display(file_handle, "Set up input signals.");
end


// always @ (posedge clk) begin

// end


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
 
  $dumpfile ("shift_data_path.vcd");
  $dumpvars(0, data_path);

 end

endmodule

