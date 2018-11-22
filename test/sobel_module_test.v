// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module sobel_module_test ();

integer file_handle;

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

  file_handle = $fopen("sobel_module_test_out.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Sobel Module tests\n"); // Output title
  
  p0 = 8'h1E;
  p1 = 8'h35;
  p2 = 8'hAE;
  p3 = 8'h01;
  p5 = 8'hFF;
  p6 = 8'h00;
  p7 = 8'h1F;
  p8 = 8'hFF;
  threshold = 200;

	$display(file_handle, "Set up input signals.");
end



/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Standard timeout, stopping runaway execution.                              */
initial 
  begin
  #1000
  $fclose(file_handle);
  $stop;
  end

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* //Dump a vcd file for GTKWave.                                             */
initial
 begin
  $dumpfile ("sobel_module_test.vcd");
  $dumpvars(0, sobel_module_test);
 end

endmodule

