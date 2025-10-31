module clkdiv (
    input  wire clk_in,     // Input clock
    output reg  clk_out = 0 // Divided clock output
);

`ifdef SIM
    // In test mode — pass the input clock directly
    always @(*) clk_out = clk_in;
`else

    // Divider counter
    localparam DIVISOR = 500_000;
    integer count = 0;

    always @(posedge clk_in) begin
        if (count == (DIVISOR - 1)) begin
            count   <= 0;
            clk_out <= ~clk_out;  // Toggle output
        end else begin
            count <= count + 1;
        end
    end
`endif

endmodule
