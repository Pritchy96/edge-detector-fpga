module shift_8_multi_read(input  wire          write_en,
                            input  wire        clk,
                            input  wire [6:0]  addr,
                            input  wire [31:0] wr_data,
                            output reg  [31:0] rd_data,
                            output wire [31:0] p2,
                            output wire [31:0] p3,
                            output wire [31:0] p4,
                            output wire [31:0] p5,
                            output wire [31:0] p6,
                            output wire [31:0] p7 );

    reg[31:0] memory [7:0];


    assign p2 = memory[addr-1];
    assign p3 = memory[addr-2];
    assign p4 = memory[addr-3];
    assign p5 = memory[addr-4];
    assign p6 = memory[addr-5];
    assign p7 = memory[addr-6];

    always @ (posedge clk) begin
		$display("Get clocked son.");
        if (write_en) begin
		    $display("Write_en");
            memory[addr] <= wr_data;

            $display("memory[addr]: ");
            $display(memory[addr]); 
        end
        rd_data <= memory[addr];
    end 
endmodule