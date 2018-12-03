module shift_data_path(
                        input  wire        write_en,
                        input  wire        clk,
                        input  wire [31:0] data_in,
                        output wire [31:0] w0,
                        output wire [31:0] w1,
                        output wire [31:0] w2,
                        output wire [31:0] w3,
                        output wire [31:0] w4,
                        output wire [31:0] w5 );

    reg  [06:0] addr;
    wire [31:0] rd_data;
    wire [31:0] shift_2_line_1_out;
    wire [31:0] shift_76_line_1_out;
    wire [31:0] shift_2_line_2_out;
    wire [31:0] shift_76_line_2_out;
    wire [31:0] shift_2_line_3_out;
    wire        shift_76_line_1_ready;
    wire        shift_76_line_2_ready;

    shift_2 shift_2_line_1 (.clk(clk),
            .write_en(write_en),
            .data_in(data_in),
            .data_out(shift_2_line_1_out),
            .word_1(w5),
            .word_2(w4));

    shift_76 shift_76_line_1 (.clk(clk),
            .write_en(write_en),
            .wr_addr(addr),
            .wr_data(shift_2_line_1_out),
            .rd_data(shift_76_line_1_out),
            .ready(shift_76_line_1_ready));

    shift_2 shift_2_line_2 (.clk(clk),
            .write_en(write_en),
            .data_in(shift_76_line_1_out),
            .data_out(shift_2_line_2_out),
            .word_1(w3),
            .word_2(w2));

    shift_76 shift_76_line_2 (.clk(clk),
            .write_en(write_en),
            .wr_addr(addr),
            .wr_data(shift_2_line_2_out),
            .rd_data(shift_76_line_2_out),
            .ready(shift_76_line_2_ready));

    shift_2 shift_2_line_3 (.clk(clk),
            .write_en(write_en),
            .data_in(shift_76_line_2_out),
            .data_out(shift_2_line_3_out),
            .word_1(w1),
            .word_2(w0));

    always @ (posedge clk) begin
        if ( write_en) begin
            if (addr > 74) begin
                addr = 0;
            end else begin
                addr = addr + 1;
            end
        end
    end 

    initial begin
        addr = 0;
    end


    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    /* //Dump a vcd file for GTKWave.                                             */
    reg [32:0] idx;

    initial
    begin
    
    //$dumpfile ("shift_76_tb.vcd");
    $dumpvars(0, shift_76_line_1);

    for (idx = 0; idx < 75; idx = idx + 1) begin
        $dumpvars(0, shift_76_line_1.memory[idx]);
    end
    
    end

endmodule