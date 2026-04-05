module horizontal_sync (
    input wire clk,
    input wire reset,
    output wire hsync,
    output wire hblank,
    output reg [10:0] hcount
);

always @(posedge clk or posedge reset) begin
    if (reset)
        hcount <= 11'd0;
    else if (hcount == 11'd1055)
        hcount <= 11'd0;
    else
        hcount <= hcount + 11'd1;
end

assign hsync  = ~(hcount >= 11'd840 && hcount < 11'd968);
assign hblank = (hcount >= 11'd800);

endmodule