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
 
    wire [15:0] sum1_r, sum1_g, sum1_b, sum2_r, sum2_g, sum2_b,
        absSum1_r, absSum1_g, absSum1_b, absSum2_r, absSum2_g, absSum2_b,
        absSum1, absSum2;

    //Red
    assign sum1_r = (p5[7:5] + p7[7:5] + p8[7:5]) - (p0[7:5] + p1[7:5] + p3[7:5]);
    assign sum2_r = (p3[7:5] + p6[7:5] + p7[7:5]) - (p1[7:5] + p2[7:5] + p5[7:5]);
    assign absSum1_r = sum1_r[15] ? -sum1_r : sum1_r;
    assign absSum2_r = sum2_r[15] ? -sum2_r : sum2_r;

    //Green
    assign sum1_g = (p5[4:2] + p7[4:2] + p8[4:2]) - (p0[4:2] + p1[4:2] + p3[4:2]);
    assign sum2_g = (p3[4:2] + p6[4:2] + p7[4:2]) - (p1[4:2] + p2[4:2] + p5[4:2]);
    assign absSum1_g = sum1_g[15] ? -sum1_g : sum1_g;
    assign absSum2_g = sum2_g[15] ? -sum2_g : sum2_g;

    //Blue
    assign sum1_b = (p5[1:0] + p7[1:0] + p8[1:0]) - (p0[1:0] + p1[1:0] + p3[1:0]);
    assign sum2_b = (p3[1:0] + p6[1:0] + p7[1:0]) - (p1[1:0] + p2[1:0] + p5[1:0]);
    assign absSum1_b = sum1_b[15] ? -sum1_b : sum1_b;
    assign absSum2_b = sum2_b[15] ? -sum2_b : sum2_b;

    assign absSum1 = absSum1_r + absSum1_b + absSum1_g;
    assign absSum2 = absSum2_r + absSum2_b + absSum2_g;

    assign result = (absSum1 > threshold || absSum2 > threshold);
endmodule