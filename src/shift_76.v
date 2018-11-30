module shift_76(input  wire        write_en,
                      input  wire        clk,
                      input  wire [6:0]  addr,
                      input  wire [31:0] wr_data,
                      output reg  [31:0] rd_data );
    
    reg[31:0] memory [75:0];

    always @ (posedge clk) begin
        if (write_en) begin
            memory[addr] <= wr_data;
        end
        rd_data <= memory[addr];
    end 
endmodule