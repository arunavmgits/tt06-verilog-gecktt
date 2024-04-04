module fault_pro(
    input [7:0] r0,
    input [1:0] check,
    input reset,
    input clk,
    output reg [2:0] out,
    output reg [1:0] out1
   
);

reg [9:0] proc;
reg [2:0] counter1 = 3'b0;
reg [2:0] counter2 = 3'b0;
reg [2:0] counter3 = 3'b0;
reg [2:0] counter4 = 3'b0;
reg maincount = 1'b0;
reg fin = 1'b0;

reg [9:0] diff1=10'b0;  
reg [9:0] diff2=10'b0;
reg [9:0] diff3=10'b0;
reg [9:0] diff4=10'b0;

//data storing registers
reg [9:0] r1=10'b0;  
reg [9:0] r2=10'b0;
reg [9:0] r3=10'b0;
reg [9:0] r4=10'b0;

//1st 4 set mean values
reg [9:0] m1=10'b0;
reg [9:0] m2=10'b0;
reg [9:0] m3=10'b0;
reg [9:0] m4=10'b0;

//2nd 4 set mean values
reg [9:0] w1=10'b0;
reg [9:0] w2=10'b0;
reg [9:0] w3=10'b0;
reg [9:0] w4=10'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        r1 <= 10'b0;
        r2 <= 10'b0;
        r3 <= 10'b0;
        r4 <= 10'b0;
        counter1 <= 3'b0;
        counter2 <= 3'b0;
        counter3 <= 3'b0;
        counter4 <= 3'b0;
        maincount <= 1'b0;
        fin <= 1'b0;
        out <= 3'b0;
        out1 <= 2'b0;
    end else begin
        case (check)
            2'b00: begin
                proc = r1;
                counter1 <= counter1 + 1;
            end
            2'b01: begin
                proc = r2;
                counter2 <= counter2 + 1;
            end
            2'b10: begin
                proc = r3;
                counter3 <= counter3 + 1;
            end
            2'b11: begin
                proc = r4;
                counter4 <= counter4 + 1;
            end
        endcase
      
        case (check)
            2'b00: r1 <= proc + r0;
            2'b01: r2 <= proc + r0;
            2'b10: r3 <= proc + r0;
            2'b11: r4 <= proc + r0;
        endcase
        if (counter1 == 4) begin    //checking whether sum of 4 data was calculated 
          m1 <= r1/4;
                                    //calculating the mean of the 4 datas  
        end
        if (counter2 == 4) begin
          m2 <= r2/4;
        end
        if (counter3 == 4) begin
          m2 <= r3/4;
        end
        if (counter4 == 4) begin
          m4 <= r4/4;
        end
        
        if (counter1 == 4 && counter2 == 4 && counter3 == 4 && counter4 == 4 && !maincount) begin
            maincount <= 1'b1;
            r1 <= 10'b0;
            r2 <= 10'b0;
            r3 <= 10'b0;
            r4 <= 10'b0;
            counter1 <= 3'b0;
            counter2 <= 3'b0;
            counter3 <= 3'b0;
            counter4 <= 3'b0;
            fin <= 1'b1;
        end
        
        // calculating mean of next 4 set datas
        if (fin) begin
            case (check)
                2'b00: begin
                    proc = r1;
                    counter1 <= counter1 + 1;
                end
                2'b01: begin
                    proc = r2;
                    counter2 <= counter2 + 1;
                end
                2'b10: begin
                    proc = r3;
                    counter3 <= counter3 + 1;
                end
                2'b11: begin
                    proc = r4;
                    counter4 <= counter4 + 1;
                end
            endcase
            
            case (check)
                2'b00: r1 <= proc + r0;
                2'b01: r2 <= proc + r0;
                2'b10: r3 <= proc + r0;
                2'b11: r4 <= proc + r0;
            endcase
            
            if (counter1 == 4) begin
                w1 <= r1/4;
                
            end
            if (counter2 == 4) begin
                w2 <= r2/4;
            end
            if (counter3 == 4) begin
                w3 <= r3/4;
            end
            if (counter4 == 4) begin
                w4 <= r4/4;
                
            end
        end
        
        diff1 = (w1 > m1) ? (w1 - m1) : (m1 - w1);
        diff2 = (w2 > m2) ? (w2 - m2) : (m2 - w2);
        diff3 = (w3 > m3) ? (w3 - m3) : (m3 - w3);
        diff4 = (w4 > m4) ? (w4 - m4) : (m4 - w4);
            
        if(diff1 >= 100) begin
          out <= 3'b100;
          out1 <= 2'b00;
        end
      else if(diff1 >= 50) begin
          out <= 3'b011;
          out1 <= 2'b00;
        end
      else if(diff1 >= 25) begin
          out <= 3'b010;
          out1 <= 2'b00;
        end
      else if(diff1 >= 10) begin
          out <= 3'b001;
          out1 <= 2'b00;
        end
        if(diff2 >= 100) begin
          out <= 3'b100;
          out1 <= 2'b01;
        end
      else if(diff2 >= 50) begin
          out <= 3'b011;
          out1 <= 2'b01;
        end
      else if(diff2 >= 25) begin
          out <= 3'b010;
          out1 <= 2'b01;
        end
      else if(diff2 >= 10) begin
          out <= 3'b001;
          out1 <= 2'b01;
        end
        if(diff3 >= 100) begin
          out <= 3'b100;
          out1 <= 2'b10;
        end
      else if(diff3 >= 50) begin
          out <= 3'b011;
          out1 <= 2'b10;
        end
      else if(diff3 >= 25) begin
          out <= 3'b010;
          out1 <= 2'b10;
        end
      else if(diff3 >= 10) begin
          out <= 3'b001;
          out1 <= 2'b10;
        end
        if(diff4 >= 100) begin
          out <= 3'b100;
          out1 <= 2'b11;
        end
      else if(diff4 >= 50) begin
          out <= 3'b011;
          out1 <= 2'b11;
        end
      else if(diff4 >= 25) begin
          out <= 3'b010;
          out1 <= 2'b11;
        end
      else if(diff4 >= 10) begin
          out <= 3'b001;
          out1 <= 2'b11;
        end
        
        end
        end
endmodule

