module shift_2 (input  wire        write_en,
                input  wire        clk,
                input  wire [31:0] data_in,
                output reg  [31:0] data_out,
                output reg  [31:0] word_1,
                output reg  [31:0] word_2
                );

    always @ (negedge clk) begin
        if (write_en) begin
            data_out <= word_2;
            word_2 <= word_1;
            word_1 <= data_in;
        end
    end 
endmodule