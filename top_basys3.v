module top_basys3 (
    input wire clk,   // 100 MHz
    input wire reset,
    output wire hsync,
    output wire vsync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
);

// 40 MHz from clock wizard
wire clk_40;
wire locked;

clk_wiz_0 clkgen (
    .clk_in1(clk),
    .clk_out1(clk_40),
    .locked(locked),
    .reset(1'b0)
);

wire reset_sync = reset | ~locked;

// Sync signals
wire [10:0] hcount;
wire [9:0]  vcount;
wire hblank, vblank;

// Horizontal
horizontal_sync hsync_inst (
    .clk(clk_40),
    .reset(reset_sync),
    .hsync(hsync),
    .hblank(hblank),
    .hcount(hcount)
);

// Vertical
wire h_end = (hcount == 11'd1055);

vertical_sync vsync_inst (
    .clk(clk_40),
    .reset(reset_sync),
    .enable(h_end),
    .vsync(vsync),
    .vblank(vblank),
    .vcount(vcount)
);

// Center a 400x300 image inside 800x600
wire in_image_window =
    (hcount >= 11'd200 && hcount < 11'd600) &&
    (vcount >= 10'd150 && vcount < 10'd450);

wire [10:0] x_img = hcount - 11'd200; // 0..399
wire [9:0]  y_img = vcount - 10'd150; // 0..299

wire [3:0] r_raw, g_raw, b_raw;

framebuffer fb (
    .clk(clk_40),
    .x(x_img),
    .y(y_img),
    .r(r_raw),
    .g(g_raw),
    .b(b_raw)
);

assign vga_r = (hblank || vblank || !in_image_window) ? 4'h0 : r_raw;
assign vga_g = (hblank || vblank || !in_image_window) ? 4'h0 : g_raw;
assign vga_b = (hblank || vblank || !in_image_window) ? 4'h0 : b_raw;

endmodule