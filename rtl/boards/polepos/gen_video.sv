//  Based on gen_video.vhd by Dar (darfpga@aol.fr, http://darfpga.blogspot.fr)
`default_nettype none

module gen_video (
    input  wire        clk,
    input  wire        enable,
    output wire [8:0]  hcnt,
    output wire [8:0]  vcnt,
    output wire         hsync,
    output logic        vsync,
    output wire         csync,
    output wire         blank_h,
    output wire         blank_v,
    output logic        blankn,
    input  wire signed [5:0] h_offset,
    input  wire signed [3:0] v_offset
);

    logic [1:0] hclkReg;
    logic       hblank;
    logic       vblank;
    logic [8:0] hcntReg = 9'd0;
    logic [8:0] vcntReg = 9'd15;

    logic hsync0;
    logic hsync1;
    logic hsync2;

    integer hsync_base;
    integer hsync_end;
    integer vsync_base;

    wire [31:0] hcnt32 = 32'(hcntReg);
    wire [31:0] vcnt32 = 32'(vcntReg);

    assign blank_h = hblank;
    assign blank_v = vblank;

    assign hcnt  = hcntReg;
    assign vcnt  = vcntReg;
    assign hsync = ~hsync0;

    always_ff @(posedge clk) begin
        if (enable) begin

            if (hcntReg == 511) begin
                hcntReg <= 128;
                if (vcntReg == 263) begin
                    vcntReg <= 0;
                end else begin
                    vcntReg <= vcntReg + 1;
                end
            end else begin
                hcntReg <= hcntReg + 1;
            end

            hsync_base <= 177 + int'(h_offset);
            hsync_end  <= ((177 + int'(h_offset) + 29) > 511)
                        ?  (177 + int'(h_offset) + 29 - 384)
                        :  (177 + int'(h_offset) + 29);
            if (hcnt32 == hsync_base) begin
                hsync0 <= 1'b0;
            end else if (hcnt32 == hsync_end) begin
                hsync0 <= 1'b1;
            end

            if (hcnt32 == hsync_base) begin
                hsync1 <= 1'b0;
            end else if (hcnt32 == (hsync_base+13)) begin
                hsync1 <= 1'b1;
            end else if (hcnt32 == (hsync_base+192-384)) begin
                hsync1 <= 1'b0;
            end else if (hcnt32 == (hsync_base+13+192-384)) begin
                hsync1 <= 1'b1;
            end

            if (hcnt32 == hsync_base) begin
                hsync2 <= 1'b0;
            end else if (hcnt32 == (hsync_base-28)) begin
                hsync2 <= 1'b1;
            end

            vsync_base <= 250 + int'(v_offset);
            if ((vcnt32 == (vsync_base+10)) && (int'(v_offset) < (263-250-10))) begin
                vsync <= 1'b1;
            end else if ((vcnt32 == (vsync_base+10-263)) && (int'(v_offset) >= (263-250-10))) begin
                vsync <= 1'b1;
            end else if ((vcnt32 == (vsync_base+17)) && (int'(v_offset) < (263-250-17))) begin
                vsync <= 1'b0;
            end else if ((vcnt32 == (vsync_base+17-263)) && (int'(v_offset) >= (263-250-17))) begin
                vsync <= 1'b0;
            end

            if (hcntReg == (448+16+8+40-384)) begin
                hblank <= 1'b1;
            end else if (hcntReg == (192-16+8+32+40)) begin
                hblank <= 1'b0;
            end

            if (vcntReg == (240+0)) begin
                vblank <= 1'b1;
            end else if (vcntReg == (016+0)) begin
                vblank <= 1'b0;
            end

            blankn <= ~(hblank | vblank);
        end
    end

endmodule

`default_nettype wire
