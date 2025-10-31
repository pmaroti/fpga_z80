module system (
    input wire clk_in,
    output wire [5:0] led
);

localparam VCC = 1'b1;
localparam GND = 1'b0;

reg [7:0] data_in;
wire [7:0] ctrl_signals;
wire [7:0] uio_in;
wire [7:0] uio_out;
wire [15:0] addr_bus;
wire m1_n;
wire mreq_n;
wire iorq_n;
wire rd_n;
wire wr_n;
wire rfsh_n;
wire halt_n;
wire busak_n;
reg is_read;
wire doe;

reg [5:0] leds;

wire clk;
clkdiv clkdiv(
    .clk_in (clk_in),
    .clk_out (clk)
);


reg [10:0]  reset_cntr=11'b0;

reg reset_n = 1'b0;
always @(posedge clk) begin
    if (reset_cntr < 11'h2) begin
        reset_cntr <= reset_cntr + 11'b1;
        reset_n <= 1'b0;
    end else begin  
        reset_n <= 1'b1;
    end
end

z80 z80 (
        .clk     (clk),
        .cen     (VCC),
        .reset_n (reset_n),
        .wait_n  (VCC),
        .int_n   (VCC),
        .nmi_n   (VCC),
        .busrq_n (VCC),
        .di      (uio_in),
        .dout    (uio_out),
        .doe     (doe),
        .A       (addr_bus),
        .m1_n    (m1_n),
        .mreq_n  (mreq_n),
        .iorq_n  (iorq_n),
        .rd_n    (rd_n),
        .wr_n    (wr_n),
        .rfsh_n  (rfsh_n),
        .halt_n  (halt_n),
        .busak_n (busak_n)
    );

always @(posedge clk) begin
    if(!iorq_n && !wr_n) begin
        leds <= uio_out;
    end
end

wire [7:0] rom_dout;
wire rom_ce;

rom rom(
    .dout(rom_dout),
    .clk(clk),
    .oce(VCC),
    .ce(rom_ce),
    .reset(GND),
    .ad(addr_bus[10:0])
);

/*
0000_0000_0000_0000
0000_0111_1111_1111
*/
assign rom_ce = (addr_bus[15:11] == 8'b0000_0);


wire [7:0] ram_dout;
wire ram_ce;
wire wre;

assign wre = ~wr_n;

ram ram(
    .dout(ram_dout), //output [7:0] dout
    .clk(clk), //input clk
    .oce(VCC), //input oce
    .ce(ram_ce), //input ce
    .reset(GND), //input reset
    .wre(wre), //input wre
    .ad(addr_bus[10:0]), //input [10:0] ad
    .din(uio_out) //input [7:0] din
);

assign ram_ce = ~rom_ce; // 

assign uio_in = (!mreq_n && !rd_n) ? (rom_ce ? rom_dout : ram_dout): 8'bzzzz_zzzz ;

//
assign led = ~leds;

endmodule