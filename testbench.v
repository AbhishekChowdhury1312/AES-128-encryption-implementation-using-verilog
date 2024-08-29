module tb;
  wire [127:0]out;
  reg rst;
  reg [127:0]key;
  reg [127:0] plain_text;
  aes128 a(rst,plain_text,key,out);
  
  initial begin
    $monitor("time=%2d,plain_text=%h,key=%h,ciphertext=%h",$time,plain_text,key,out);
    rst = 1;
    plain_text = 128'h54776F204F6E65204E696E652054776F;
    key = 128'h5468617473206D79204B756E67204675;
    #5 rst =0;
     
  end
endmodule
