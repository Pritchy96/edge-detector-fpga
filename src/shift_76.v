module shift_76(input  wire        write_en,
                input  wire        clk,
                input  wire [6:0]  wr_addr,
                input  wire [31:0] wr_data,
                output reg  [31:0] rd_data,
                output reg         ready);
    
    reg  [31:0] memory [77:0];
    wire [6:0] rd_addr;

    assign rd_addr = ((wr_addr + 1) > 77) ? 0 : wr_addr + 1; //TODO: Needed?

    initial begin
        ready = 1;
    end

    //Handle ready signal.
    always @ (posedge clk) begin
        if (write_en && ready) begin
            ready = 0;  //TODO: This isn't needed?
        end else begin
            ready = 1;
        end
    end

    //This must be kept as is so it will synthesise into block RAM?
    always @ (posedge clk) begin
        if (write_en) memory[wr_addr] = wr_data;
        rd_data = memory[rd_addr];
    end
endmodule