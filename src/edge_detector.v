`define IDLE 0
`define SETUP 1
`define DETECTING 2

`define READING 0
`define WAITING_FOR_DATA 1
`define SETTING_DATA 2
`define WRITING 3

module edge_detector( input  wire        clk,
                      input  wire        req,
                      output reg         ack,
                      output wire        busy,
                      output reg         intial_de_req,
                      input  wire        intial_de_ack);   

//Data store
reg  [31:0] dstore_data_in;
reg         dstore_write_enable;
wire [31:0] word0;
wire [31:0] word1;
wire [31:0] word2;
wire [31:0] word3;
wire [31:0] word4;
wire [31:0] word5;
wire [31:0] word_edges;

//TODO: Define a better value for this.
wire [07:0] threshold;
assign threshold = 200;

reg         de_req;
wire        de_ack;
reg  [17:0] de_addr;
wire [03:0] de_nbyte;
reg         de_rnw;
wire [31:0] de_w_data;
wire [31:0] de_r_data;

//State control
reg [01:0] overall_state;
reg [01:0] detecting_state;
reg        more_to_draw;

initial
  begin
    overall_state   = `IDLE;
    detecting_state = `READING;
    more_to_draw = 1;

    ack          = 0;
    dstore_write_enable = 0;
    dstore_data_in = 0;
    de_req = 0;
    de_addr = 0;
    de_rnw = 0; 
  end

assign busy = (overall_state != `IDLE);
// assign de_req = busy && ((more_to_draw != 0) || !de_ack);
assign need_setup_data = (word0 === 32'hxxxxxxxx);


always @ (posedge clk)
  case (overall_state)
    `IDLE:
      begin
			$display("overall_state = IDLE.");
      if (req)  //Wait for request
        begin
        ack <= 1; //Ack start
        more_to_draw <= 1;
        
        overall_state <= `SETUP;	
        end
      end

    `SETUP:
      begin
				$display("overall_state = SETUP.");
        //This is on the next clock after setting dstore_write_enable, so set it low.
        if (dstore_write_enable == 1) begin
          dstore_write_enable = 0;
        end

        if (need_setup_data) begin
          if (de_req == 0 || de_ack == 1) //last pixel read ack'd, start another.
            begin
            $display("de_ack high.");

            //First, put the pixel word we just read into our data store.
            dstore_data_in <= dstore_data_in + 1;
            dstore_write_enable <= 1;
            //de_req = 1;

            //Read in data.
            // read_frame();
            end
          end else begin
            intial_de_req = 1;
            overall_state <= `DETECTING;
          end
      end

    `DETECTING:
      begin
				$display("overall_state = DETECTING.");
        edge_detecting;
      end
  endcase

  task edge_detecting;
    begin
    case (detecting_state)
      `READING: begin
        $display("detecting_state = READING.");
        //de_addr = ?;
        de_rnw = 1;
        de_req = 1;
        detecting_state = `WAITING_FOR_DATA;
      end

      `WAITING_FOR_DATA: begin 
        // if (de_ack == 1) begin  //TODO: Readd this when plugged into the framestore.
          #200
            //Data will be available next clock edge
            dstore_data_in = dstore_data_in + 1;

            detecting_state = `SETTING_DATA;
        // end
      end

      `SETTING_DATA: begin
        //Basically this state delays the FSM by one clock cycle
        //So the contents of dstore_data_in get written into the store
        dstore_write_enable = 1;
        detecting_state = `WRITING;
      end

      `WRITING: begin
        dstore_write_enable = 0;
        de_rnw = 0;
        //sobel stuff here
        //Comb logic, should be 'instant'
        detecting_state = `READING;
      end
    endcase
    end
  endtask

//TODO: Implement this.
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

sobel_module sobel1 (.p0(word5[23:16]),
                    .p1(word5[31:24]),
                    .p2(word4[07:00]),
                    .p3(word3[23:16]),
                    .p5(word2[07:00]),
                    .p6(word1[23:16]),
                    .p7(word1[31:24]),
                    .p8(word0[07:00]),
                    .threshold(threshold),
                    .result(word_edges[07:00]));

sobel_module sobel2 (.p0(word5[31:24]),
                    .p1(word4[07:00]),
                    .p2(word4[15:08]),
                    .p3(word3[31:24]),
                    .p5(word2[15:08]),
                    .p6(word1[31:24]),
                    .p7(word1[07:00]),
                    .p8(word0[15:08]),
                    .threshold(threshold),
                    .result(word_edges[15:08]));

sobel_module sobel3 (.p0(word4[07:00]),
                     .p1(word4[15:08]),
                     .p2(word4[23:16]),
                     .p3(word3[07:00]),
                     .p5(word2[23:16]),
                     .p6(word1[07:00]),
                     .p7(word1[15:08]),
                     .p8(word0[23:16]),
                     .threshold(threshold),
                     .result(word_edges[23:16]));

sobel_module sobel4 (.p0(word4[15:08]),
                     .p1(word4[23:16]),
                     .p2(word4[31:24]),
                     .p3(word3[15:08]),
                     .p5(word2[31:24]),
                     .p6(word1[15:08]),
                     .p7(word1[23:16]),
                     .p8(word0[31:24]),
                     .threshold(threshold),
                     .result(word_edges[31:24]));
endmodule