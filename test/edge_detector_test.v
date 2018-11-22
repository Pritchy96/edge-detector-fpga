// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module edge_detector_test ();

integer file_handle;                      // The place to write output

reg         clk;
reg         req;
wire        ack;
wire        busy;
wire        de_req;
reg         de_ack;
wire [17:0] de_addr;
wire  [3:0] de_nbyte;
wire        de_rnw;
wire [31:0] de_w_data;
wire [31:0] de_r_data;

//Instantiate module under test
edge_detector detector (.clk(clk),     
               .req(req),
               .ack(ack), 
               .busy(busy),
               .de_req(de_req),
               .de_ack(de_ack),
               .de_addr(de_addr),
               .de_nbyte(de_nbyte),
               .de_rnw(de_rnw),
               .de_w_data(de_w_data),
               .de_r_data(de_r_data));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin

  file_handle = $fopen("edge_detector_test_out.log"); // Open a message output file
  $fdisplay(file_handle, "Outcome from Edge Detector tests\n"); // Output title
  
	clk = 0;
	req = 0;
	de_ack = 0;

	$display(file_handle, "Set up control signals, moving to drawing.");
  #10

  req = 1;
end 

always @ (posedge clk) begin
if (de_req) 
  begin 
  #10
  de_ack = 1; 
  end
end

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Set up clock input																						              */
always #10 clk = ~clk;


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
  $dumpfile ("edge_detector_test.vcd");
  $dumpvars(0, edge_detector_test);
 end

endmodule

