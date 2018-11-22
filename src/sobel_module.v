module sobel_module( input wire [7:0] p0,
                     input  wire [7:0] p1,
                     input  wire [7:0] p2,
                     input  wire [7:0] p3,
                     input  wire [7:0] p5,
                     input  wire [7:0] p6,
                     input  wire [7:0] p7,
                     input  wire [7:0] p8,
                     input  wire [7:0] threshold,
                     output wire       result );
 
    wire [15:0] sum1;
    wire [15:0] sum2;
    wire  [15:0] absSum1;
    wire  [15:0] absSum2;

    assign sum1 = (p5 + p7 + p8) - (p0 + p1 + p3);
    assign sum2 = (p3 + p6 + p7) - (p1 + p2 + p5);
    
    assign absSum1 = sum1[15] ? -sum1 : sum1;
    assign absSum2 = sum2[15] ? -sum2 : sum2;
    assign result = (absSum1 > threshold || absSum2 > threshold);
endmodule