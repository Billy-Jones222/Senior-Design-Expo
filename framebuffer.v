module framebuffer (
    input  wire        clk,
    input  wire [10:0] x,
    input  wire [9:0]  y,
    output reg  [3:0]  r,
    output reg  [3:0]  g,
    output reg  [3:0]  b
);

localparam WIDTH  = 400;
localparam HEIGHT = 300;

reg [11:0] mem [0:WIDTH*HEIGHT-1];
reg [16:0] addr;

wire [16:0] addr_next = y * WIDTH + x;

initial begin
    $readmemh("image.hex", mem);
end

always @(posedge clk) begin
    addr <= addr_next;
    {r, g, b} <= mem[addr];
end

endmodule