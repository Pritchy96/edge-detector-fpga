// Testing for Edge Detector
//
// Created by Tom Pritchard, November 2018

module edge_detector_tb ();

integer file_handle;                      // The place to write output

reg         clk;
reg         req;
wire        ack;
wire        busy;

wire        de_req;
reg         de_ack;

//Instantiate module under test
edge_detector detector (.clk(clk),     
               .req(req),
               .ack(ack), 
               .busy(busy),
               .intial_de_req(de_req),
               .intial_de_ack(de_ack));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Test                                                                       */

initial
begin

  file_handle = $fopen("edge_detector_tb_out.log"); // Open a message output file
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
  #10000
  $fclose(file_handle);
  $stop;
  end

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* //Dump a vcd file for GTKWave.                                             */
initial
 begin
  $dumpfile ("edge_detector_tb.vcd");
  $dumpvars(2000, edge_detector_tb);

  
 end

endmodule

