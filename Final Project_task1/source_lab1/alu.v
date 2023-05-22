module alu (a,b,aluc,s,z);
   input [31:0] a, b;
   input [3:0] aluc;
   output [31:0] s;
   output        z;
   wire z;
   wire [31:0] s;
   
   assign  s = (aluc == 4'b0000)? a + b: 
               (aluc == 4'b1000)? a - b:
               (aluc == 4'b0111)? a & b:
               (aluc == 4'b0110)? a | b:
               (aluc == 4'b0100)? a ^ b:
               (aluc == 4'b0010)? b    :
               (aluc == 4'b0001)? a << b:
               (aluc == 4'b0101)? a >> b:
               (aluc == 4'b1111) ? count_ones(a ^ b):
               (aluc == 4'b1101)? $signed($signed(a) >>> b):
               0;
  assign z = (s == 0); 
  
   function automatic integer count_ones;
       input [31:0] value;
       integer count, i;
       begin
          count = 0;
          for (i = 0; i < 32; i = i + 1) begin
             if (value[i] == 1) begin
                count = count + 1;
             end
          end
          count_ones = count;
       end
    endfunction
       
endmodule 