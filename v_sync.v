module vertical_sync (
    input wire clk,
    input wire reset,
    input wire enable,
    output wire vsync,
    output wire vblank,
    output reg [9:0] vcount
);

always @(posedge clk or posedge reset) begin
    if (reset)
        vcount <= 10'd0;
    else if (enable) begin
        if (vcount == 10'd627)
            vcount <= 10'd0;
        else
            vcount <= vcount + 10'd1;
    end
end

assign vsync  = ~(vcount >= 10'd601 && vcount < 10'd605);
assign vblank = (vcount >= 10'd600);

endmodule