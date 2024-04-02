/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_ha (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
   // assign ui_in[7:2]=6'b000000;
    uo_out[7:1]<=7'b0;
   // assign uio_in = 0;
  assign uio_out = 0;
  assign uio_oe  = 0;
    reg [7:0] proc; // processing register
reg [7:0] r1= 8'b0;
reg [7:0] r2= 8'b0;
reg [7:0] r3= 8'b0;
reg [7:0] r4= 8'b0;
reg [7:0] res;
 
always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        r1 <= 8'b0;
        r2 <= 8'b0;
        r3 <= 8'b0;
        r4 <= 8'b0;
        uo_out[0] <= 1'b0;
    end else begin
        case (uio_in[1:0])
            2'b00: proc = r1;
            2'b01: proc = r2;
            2'b10: proc = r3;
            2'b11: proc = r4;
        endcase

        if (proc == ui_in) begin
            uo_out[0] <= 1'b0;
        end else begin
            if (proc > ui_in) begin
                res = proc - ui_in;
            end else begin
                res = ui_in - proc;
            end

            if (res > 8'b00000010) begin
                case (uio_in[1:0])
                    2'b00: r1 <= ui_in;
                    2'b01: r2 <= ui_in;
                    2'b10: r3 <= ui_in;
                    2'b11: r4 <= ui_in;
                endcase
                uo_out[0] <= 1'b1;
            end else begin
                uo_out[0] <= 1'b0;
            end
        end
    end
end

endmodule
