module shift_data_path(input  wire        clk,
                        output wire [31:0] p0,
                        output wire [31:0] p1,
                        output wire [31:0] p2,
                        output wire [31:0] p3,
                        output wire [31:0] p4,
                        output wire [31:0] p5,
                        output wire [31:0] p6,
                        output wire [31:0] p7,
                        output wire [31:0] p8,
                        output wire [31:0] p9,
                        output wire [31:0] p10,
                        output wire [31:0] p11,
                        output wire [31:0] p12,
                        output wire [31:0] p13,
                        output wire [31:0] p14,
                        output wire [31:0] p15,
                        output wire [31:0] p16,
                        output wire [31:0] p17 );

    reg         write_en;
    reg  [06:0] addr;
    reg  [31:0] data_in;
    wire [31:0] rd_data;
    wire [31:0] shift_8_line_1_out;


    shift_8_multi_read shift_8_line_1 (.clk(clk),
                .write_en(write_en),
                .addr(addr),
                .wr_data(data_in),
                .rd_data(shift_8_line_1_out),
                .p2(p12),
                .p3(p13),
                .p4(p14),
                .p5(p15),
                .p6(p16),
                .p7(p17));

    shift_32 shift_32_line_1 (.clk(clk),
            .write_en(write_en),
            .addr(addr),
            .wr_data(shift_8_line_1_out),
            .rd_data(rd_data));

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
        addr = addr + 1;
        data_in = data_in + 1;
    end
  endtask

endmodule