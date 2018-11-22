`define IDLE 0
`define SETUP 1
`define DETECTING 2

module edge_detector( input  wire        clk,
                      input  wire        req,
                      output reg         ack,
                      output wire        busy,
                      input  wire [15:0] r0,
                      input  wire [15:0] r1,
                      input  wire [15:0] r2,
                      input  wire [15:0] r3,
                      input  wire [15:0] r4,
                      input  wire [15:0] r5,
                      input  wire [15:0] r6,
                      input  wire [15:0] r7,
                      output wire        de_req,
                      input  wire        de_ack,
                      output wire [17:0] de_addr,
                      output wire  [3:0] de_nbyte,
                      output wire        de_rnw,
                      output wire [31:0] de_w_data,
                      input  wire [31:0] de_r_data );

reg [31:0] word1;
reg [31:0] word2;
reg [31:0] word3;
reg [31:0] word4;
reg [01:0] draw_state;
reg        more_to_draw;

initial
  begin
    draw_state   = `IDLE;
    ack          = 0;
    more_to_draw = 0;
    word1        = 32'hxxxxxxxx;
    word2        = 32'hxxxxxxxx;
    word3        = 32'hxxxxxxxx;
    word4        = 32'hxxxxxxxx;
  end

assign busy      = (draw_state != `IDLE);
assign de_req    = busy && ((more_to_draw != 0) || !de_ack);
assign need_data = (word1 === 32'hxxxxxxxx) || (word2 === 32'hxxxxxxxx) || (word3 === 32'hxxxxxxxx) || (word4 === 32'hxxxxxxxx);

always @ (posedge clk)
  case (draw_state)
    `IDLE:
      begin
			$display("State = IDLE.");
      if (req)  //Wait for request
        begin
        ack <= 1; //Ack start
        more_to_draw <= 1;
        
        draw_state <= `SETUP;	
        end
      end

    `SETUP:
      begin
				$display("State = SETUP.");
        if (de_ack) //last pixel read ack'd, start another.
          begin
				  $display("de_ack high.");

          if (word1 === 32'hxxxxxxxx) //Check empty
              begin
              read_frame();
              word1 = de_r_data;
              end
          else if (word2 === 32'hxxxxxxxx)
              begin
              read_frame();
              word2 = de_r_data;
              end
          else if (word3 === 32'hxxxxxxxx)
              begin
              read_frame();
              word3 = de_r_data;
              end
          else if (word4 === 32'hxxxxxxxx)
              begin
              read_frame();
              word4 = de_r_data;
              draw_state <= `DETECTING;
              end
          end
      end

    `DETECTING:
      begin
				$display("State = DETECTING.");
      end
  endcase

  task read_frame;
    begin

		$display("Reading Frame.. Honest!");

    // Set RNW = 1
    // Set de_addr = addr?

    
    // read data...somehow..
    end
  endtask

endmodule


