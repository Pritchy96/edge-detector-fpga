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

//Data store
reg  [31:0] dstore_data_in;
reg         dstore_write_enable;
wire [31:0] word0;
wire [31:0] word1;
wire [31:0] word2;
wire [31:0] word3;
wire [31:0] word4;
wire [31:0] word5;
reg  [31:0] word_edges;

//State control
reg [01:0] draw_state;
reg        more_to_draw;

initial
  begin
    draw_state   = `IDLE;
    ack          = 0;
  end

assign busy      = (draw_state != `IDLE);
assign de_req    = busy && ((more_to_draw != 0) || !de_ack);
assign need_setup_data = (word5 === 32'hxxxxxxxx);

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
        //This is on the next clock after setting dstore_write_enable, so set it low.
        if (dstore_write_enable == 1) begin
          dstore_write_enable = 0;
        end

        if (need_setup_data)
          begin
          if (de_ack) //last pixel read ack'd, start another.
            begin
            $display("de_ack high.");

            //First, put the pixel word we just read into our data store.
            dstore_write_enable = 1;

            //Read in data.
            read_frame();
            end
          end else begin
            state <= `DETECTING;
          end
      end

    `DETECTING:
      begin
				$display("State = DETECTING.");

        if (de_ack) //last pixel read/write ack'd, start another.
          if (dstore_write_enable == 1) begin //Just wrote a pixel
            //This is on the next clock after setting dstore_write_enable, so set it low.
            dstore_write_enable = 0; 

            //We have written our pixel word, so now read a pixel word.
            read_frame();

          end else begin  //Just read a pixel
          //TODO: If we're async sending jobs to the frame store, how do we know when the read happens?

            dstore_write_enable = 1;
          end

      end
  endcase


  task read_frame;
    begin

		$display("Reading Frame.. Honest!");
    // dstore_data_in = dstore_data_in + 1;

    // Set RNW = 1
    // Set de_addr = addr?
    // read data...somehow..
    end
  endtask

shift_data_path data_path (.clk(clk),
                      .write_en(dstore_write_enable),
                      .data_in(dstore_data_in),
                      .w0(word0),
                      .w1(word1),
                      .w2(word2),
                      .w3(word3),
                      .w4(word4),
                      .w5(word5));


sobel_module sobel1 (.p0(p0),
                    .p1(p1),
                    .p2(p2),
                    .p3(p3),
                    .p5(p5),
                    .p6(p6),
                    .p7(p7),
                    .p8(p8),
                    .threshold(threshold),
                    .result(result));

endmodule