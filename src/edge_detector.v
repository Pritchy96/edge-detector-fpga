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
                      input  wire [15:0] r0,
                      input  wire [15:0] r1,
                      input  wire [15:0] r2,
                      input  wire [15:0] r3,
                      input  wire [15:0] r4,
                      input  wire [15:0] r5,
                      input  wire [15:0] r6,
                      input  wire [15:0] r7,
                      output reg         de_req,
                      input  wire        de_ack,
                      output reg  [17:0] de_addr,
                      output reg   [3:0] de_nbyte,
                      output reg         de_rnw,
                      output reg  [31:0] de_w_data,
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
wire [31:0] word_edges;

//TODO: Define a better value for this.
wire [07:0] threshold;
assign threshold = 10;

reg         internal_de_req;
wire        internal_de_ack;

//State control
reg [01:0] overall_state;
reg [01:0] detecting_state;
reg [01:0] setup_state;
reg        more_to_draw;


initial
  begin
    //Initialise Control Signals.
    overall_state   = `IDLE;
    setup_state     = `READING;
    detecting_state = `READING;
    more_to_draw = 1;
    ack          = 0;
    dstore_write_enable = 0;
    dstore_data_in = 0;
    internal_de_req = 0;
    de_addr = 0;
    de_rnw = 0;
  end

assign busy = (overall_state != `IDLE);
// assign internal_de_req = busy && ((more_to_draw != 0) || !internal_de_ack);
assign need_setup_data = (word0 === 32'hxxxxxxxx);


always @ (posedge clk)
  case (overall_state)
    `IDLE:
      begin
      if (req)  //Wait for request
        begin
        ack <= 1; //Ack start
        more_to_draw <= 1;

        overall_state <= `SETUP;
        end
      end

    `SETUP: begin
      handle_setup;
    end

    `DETECTING: begin
      edge_detecting;
    end
  endcase

  task edge_detecting;
    begin
    case (detecting_state)
      `READING: begin
        //de_addr = ?;
        de_rnw = 1;
        internal_de_req = 1;
        detecting_state = `WAITING_FOR_DATA;
      end

      `WAITING_FOR_DATA: begin
        // if (internal_de_ack == 1) begin  //TODO: Readd this when plugged into the framestore.
          #20
            //Data will be available next clock edge
            read_frame;

            detecting_state = `SETTING_DATA;
        // end
      end

      `SETTING_DATA: begin
        //Basically this state delays the FSM by one clock cycle
        //So the contents of dstore_data_in get written into the store
        dstore_write_enable = 1;
        detecting_state <= `WRITING;
      end

      `WRITING: begin
        dstore_write_enable = 0;
        de_rnw = 0;
        //Comb logic, should be 'instant'
        detecting_state <= `READING;
      end
    endcase
    end
  endtask

  task handle_setup;
    case (setup_state)
    `READING: begin
      dstore_write_enable = 0;

      if (need_setup_data) begin
          //de_addr = ?;
          de_rnw = 1;
          internal_de_req = 1;
          setup_state = `WAITING_FOR_DATA;
      end else begin
          de_req = 1;
          overall_state <= `DETECTING;
      end
    end

    `WAITING_FOR_DATA: begin
      // if (internal_de_ack == 1) begin  //TODO: Readd this when plugged into the framestore.
          #20
          //Data will be available next clock edge
          read_frame;
          setup_state = `SETTING_DATA;
      // end
    end

    `SETTING_DATA: begin
      //Basically this state delays the FSM by one clock cycle
      //So the contents of dstore_data_in get written into the store
      dstore_write_enable <= 1;
      setup_state <= `READING;
    end
    endcase
  endtask

  task read_frame;
    begin
    // Set de_addr = addr?
    //Temp for testing
    dstore_data_in = dstore_data_in + 1; //Better for visualising data flow.
    // dstore_data_in = $random%128; //Better for visualising data flow.
    de_rnw = 0;
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
