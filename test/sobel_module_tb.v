// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module sobel_module_tb ();

integer file_handle;

reg        clk;
reg  [7:0] p0;
reg  [7:0] p1;
reg  [7:0] p2;
reg  [7:0] p3;
reg  [7:0] p5;
reg  [7:0] p6;
reg  [7:0] p7;
reg  [7:0] p8;
reg  [7:0] threshold;
wire       result;

//Instantiate module under test
sobel_module sobel (.p0(p0),
                    .p1(p1),
                    .p2(p2),
                    .p3(p3),
                    .p5(p5),
                    .p6(p6),
                    .p7(p7),
                    .p8(p8),
                    .threshold(threshold),
                    .result(result));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin

  file_handle = $fopen("sobel_module_tb_out.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Sobel Module tests\n"); // Output title
  
  clk = 0;
  p0 = 8'h00;
  p1 = 8'h00;
  p2 = 8'h00;
  p3 = 8'h00;
  p5 = 8'h00;
  p6 = 8'h00;
  p7 = 8'h00;
  p8 = 8'h00;
  threshold = 8'h00;

	$display(file_handle, "Set up input signals.");
end


always @ (posedge clk) begin
  #30;
  p0 = $urandom%128;
  p1 = $urandom%128;
  p2 = $urandom%128;
  p3 = $urandom%128;
  p5 = $urandom%128;
  p6 = $urandom%128;
  p7 = $urandom%128;
  p8 = $urandom%128;
  threshold = $urandom%128;
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
  $dumpfile ("sobel_module_tb.vcd");
  $dumpvars(0, sobel_module_tb);
 end

endmodule

