module shift_data_path(input  wire        clk,
                        output wire [31:0] w0,
                        output wire [31:0] w1,
                        output wire [31:0] w2,
                        output wire [31:0] w3,
                        output wire [31:0] w4,
                        output wire [31:0] w5 );

    reg         write_en;
    reg  [06:0] addr;
    reg  [31:0] data_in;
    wire [31:0] rd_data;
    
    wire [31:0] shift_8_line_1_out;
    wire [31:0] shift_32_line_1_out;
    wire [31:0] shift_8_line_2_out;
    wire [31:0] shift_32_line_2_out;
    wire [31:0] shift_8_line_3_out;


    shift_8_multi_read shift_8_line_1 (.clk(clk),
            .write_en(write_en),
            .data_in(data_in),
            .data_out(shift_8_line_1_out),
            .word_1(w5),
            .word_2(w4));

    shift_32 shift_32_line_1 (.clk(clk),
            .write_en(write_en),
            .addr(addr),
            .wr_data(shift_8_line_1_out),
            .rd_data(shift_32_line_1_out));

    shift_8_multi_read shift_8_line_2 (.clk(clk),
            .write_en(write_en),
            .data_in(shift_32_line_1_out),
            .data_out(shift_8_line_2_out),
            .word_1(w3),
            .word_2(w2));

    shift_32 shift_32_line_2 (.clk(clk),
            .write_en(write_en),
            .addr(addr),
            .wr_data(shift_8_line_2_out),
            .rd_data(shift_32_line_2_out));

    shift_8_multi_read shift_8_line_3 (.clk(clk),
            .write_en(write_en),
            .data_in(shift_32_line_2_out),
            .data_out(shift_8_line_3_out),
            .word_1(w1),
            .word_2(w0));

    always @ (posedge clk) begin
        if (write_en) begin
            read_frame;
        end
    end 

    initial begin 
        write_en = 1;
        addr = 0;
        data_in = 0;
    end 


    task read_frame;
    begin

		$display("Reading Frame.. Honest!");
        if (addr > 74) begin
            addr = 0;
        end else begin
            addr = addr + 1;
        end

        data_in = data_in + 1;
    end
  endtask

endmodule