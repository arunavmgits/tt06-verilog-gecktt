module co_processor (
    input [7:0] r0, // 8-bit input
    input [1:0] check, // sensor checking
    input reset,
    input clk, // clock input
    output reg Q // output Q
);

reg [7:0] proc; // processing register
reg [7:0] r1= 8'b0;
reg [7:0] r2= 8'b0;
reg [7:0] r3= 8'b0;
reg [7:0] r4= 8'b0;
reg [7:0] res;
 
always @(posedge clk or posedge reset) begin
    if (reset) begin
        r1 <= 8'b0;
        r2 <= 8'b0;
        r3 <= 8'b0;
        r4 <= 8'b0;
        Q <= 1'b0;
    end else begin
        case (check)
            2'b00: proc = r1;
            2'b01: proc = r2;
            2'b10: proc = r3;
            2'b11: proc = r4;
        endcase

        if (proc == r0) begin
            Q <= 1'b0;
        end else begin
            if (proc > r0) begin
                res = proc - r0;
            end else begin
                res = r0 - proc;
            end

            if (res > 8'b00000010) begin
                case (check)
                    2'b00: r1 <= r0;
                    2'b01: r2 <= r0;
                    2'b10: r3 <= r0;
                    2'b11: r4 <= r0;
                endcase
                Q <= 1'b1;
            end else begin
                Q <= 1'b0;
            end
        end
    end
end

endmodule

