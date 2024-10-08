module aes128(rst,plain_text,key,out);
  input [127:0]key;
  input [127:0]plain_text;
  input rst;
  reg [6:0]eas;
  output reg [127:0]out;
  reg [127:0]Wtmp128i,Wtmp;
  reg [127:0]Wtmp128o;
  reg [7:0]Wtmp8i[15:0];
  reg [7:0]Wtmp8o[15:0];
  reg [7:0]sbox[255:0];
  reg [7:0]p,q;
  reg [31:0]x,y;
  reg [31:0]W[43:0];
  integer i,j;
  reg [7:0]tmp,b1,b2,b3,b4,R1;
  reg [31:0]Rcon[10:1];
  reg [2:0]state,next_state;
  reg [3:0]round;
  reg [127:0]plain_text;
  parameter IDLE = 3'b000,addRoundKey = 3'b001,subBytes = 3'b010,shiftRows = 3'b011,mixColumns = 3'b100,increment_round=3'b101;
  initial begin 
      Rcon[1] = 32'h01000000;
      Rcon[2] = 32'h02000000;
      Rcon[3] = 32'h04000000;
      Rcon[4] = 32'h08000000;
      Rcon[5] = 32'h10000000;
      Rcon[6] = 32'h20000000;
      Rcon[7] = 32'h40000000;
      Rcon[8] = 32'h80000000;
      Rcon[9] = 32'h1B000000;
      Rcon[10] =32'h36000000;  
  end
    
  
  initial begin

 //Things to do: change values of S-box
    sbox[0] = 8'h63; sbox[1] = 8'h7c; sbox[2] = 8'h77; sbox[3] = 8'h7b; sbox[4] = 8'hf2; sbox[5] = 8'h6b; sbox[6] = 8'h6f; sbox[7] = 8'hc5; sbox[8] = 8'h30; sbox[9] = 8'h01; sbox[10] = 8'h67; sbox[11] = 8'h2b; sbox[12] = 8'hfe; sbox[13] = 8'hd7; sbox[14] = 8'hab; sbox[15] = 8'h76; sbox[16] = 8'hca; sbox[17] = 8'h82; sbox[18] = 8'hc9; sbox[19] = 8'h7d; sbox[20] = 8'hfa; sbox[21] = 8'h59; sbox[22] = 8'h47; sbox[23] = 8'hf0; sbox[24] = 8'had; sbox[25] = 8'hd4; sbox[26] = 8'ha2; sbox[27] = 8'haf; sbox[28] = 8'h9c; sbox[29] = 8'ha4; sbox[30] = 8'h72; sbox[31] = 8'hc0; sbox[32] = 8'hb7; sbox[33] = 8'hfd; sbox[34] = 8'h93; sbox[35] = 8'h26; sbox[36] = 8'h36; sbox[37] = 8'h3f; sbox[38] = 8'hf7; sbox[39] = 8'hcc; sbox[40] = 8'h34; sbox[41] = 8'ha5; sbox[42] = 8'he5; sbox[43] = 8'hf1; sbox[44] = 8'h71; sbox[45] = 8'hd8; sbox[46] = 8'h31; sbox[47] = 8'h15; sbox[48] = 8'h04; sbox[49] = 8'hc7; sbox[50] = 8'h23; sbox[51] = 8'hc3; sbox[52] = 8'h18; sbox[53] = 8'h96; sbox[54] = 8'h05; sbox[55] = 8'h9a; sbox[56] = 8'h07; sbox[57] = 8'h12; sbox[58] = 8'h80; sbox[59] = 8'he2; sbox[60] = 8'heb; sbox[61] = 8'h27; sbox[62] = 8'hb2; sbox[63] = 8'h75; sbox[64] = 8'h09; sbox[65] = 8'h83; sbox[66] = 8'h2c; sbox[67] = 8'h1a; sbox[68] = 8'h1b; sbox[69] = 8'h6e; sbox[70] = 8'h5a; sbox[71] = 8'ha0; sbox[72] = 8'h52; sbox[73] = 8'h3b; sbox[74] = 8'hd6; sbox[75] = 8'hb3; sbox[76] = 8'h29; sbox[77] = 8'he3; sbox[78] = 8'h2f; sbox[79] = 8'h84; sbox[80] = 8'h53; sbox[81] = 8'hd1; sbox[82] = 8'h00; sbox[83] = 8'hed; sbox[84] = 8'h20; sbox[85] = 8'hfc; sbox[86] = 8'hb1; sbox[87] = 8'h5b; sbox[88] = 8'h6a; sbox[89] = 8'hcb; sbox[90] = 8'hbe; sbox[91] = 8'h39; sbox[92] = 8'h4a; sbox[93] = 8'h4c; sbox[94] = 8'h58; sbox[95] = 8'hcf; sbox[96] = 8'hd0; sbox[97] = 8'hef; sbox[98] = 8'haa; sbox[99] = 8'hfb; sbox[100] = 8'h43; sbox[101] = 8'h4d; sbox[102] = 8'h33; sbox[103] = 8'h85; sbox[104] = 8'h45; sbox[105] = 8'hf9; sbox[106] = 8'h02; sbox[107] = 8'h7f; sbox[108] = 8'h50; sbox[109] = 8'h3c; sbox[110] = 8'h9f; sbox[111] = 8'ha8; sbox[112] = 8'h51; sbox[113] = 8'ha3; sbox[114] = 8'h40; sbox[115] = 8'h8f; sbox[116] = 8'h92; sbox[117] = 8'h9d; sbox[118] = 8'h38; sbox[119] = 8'hf5; sbox[120] = 8'hbc; sbox[121] = 8'hb6; sbox[122] = 8'hda; sbox[123] = 8'h21; sbox[124] = 8'h10; sbox[125] = 8'hff; sbox[126] = 8'hf3; sbox[127] = 8'hd2; sbox[128] = 8'hcd; sbox[129] = 8'h0c; sbox[130] = 8'h13; sbox[131] = 8'hec; sbox[132] = 8'h5f; sbox[133] = 8'h97; sbox[134] = 8'h44; sbox[135] = 8'h17; sbox[136] = 8'hc4; sbox[137] = 8'ha7; sbox[138] = 8'h7e; sbox[139] = 8'h3d; sbox[140] = 8'h64; sbox[141] = 8'h5d; sbox[142] = 8'h19; sbox[143] = 8'h73; sbox[144] = 8'h60; sbox[145] = 8'h81; sbox[146] = 8'h4f; sbox[147] = 8'hdc; sbox[148] = 8'h22; sbox[149] = 8'h2a; sbox[150] = 8'h90; sbox[151] = 8'h88; sbox[152] = 8'h46; sbox[153] = 8'hee; sbox[154] = 8'hb8; sbox[155] = 8'h14; sbox[156] = 8'hde; sbox[157] = 8'h5e; sbox[158] = 8'h0b; sbox[159] = 8'hdb; sbox[160] = 8'he0; sbox[161] = 8'h32; sbox[162] = 8'h3a; sbox[163] = 8'h0a; sbox[164] = 8'h49; sbox[165] = 8'h06; sbox[166] = 8'h24; sbox[167] = 8'h5c; sbox[168] = 8'hc2; sbox[169] = 8'hd3; sbox[170] = 8'hac; sbox[171] = 8'h62; sbox[172] = 8'h91; sbox[173] = 8'h95; sbox[174] = 8'he4; sbox[175] = 8'h79; sbox[176] = 8'he7; sbox[177] = 8'hc8; sbox[178] = 8'h37; sbox[179] = 8'h6d; sbox[180] = 8'h8d; sbox[181] = 8'hd5; sbox[182] = 8'h4e; sbox[183] = 8'ha9; sbox[184] = 8'h6c; sbox[185] = 8'h56; sbox[186] = 8'hf4; sbox[187] = 8'hea; sbox[188] = 8'h65; sbox[189] = 8'h7a; sbox[190] = 8'hae; sbox[191] = 8'h08; sbox[192] = 8'hba; sbox[193] = 8'h78; sbox[194] = 8'h25; sbox[195] = 8'h2e; sbox[196] = 8'h1c; sbox[197] = 8'ha6; sbox[198] = 8'hb4; sbox[199] = 8'hc6; sbox[200] = 8'he8; sbox[201] = 8'hdd; sbox[202] = 8'h74; sbox[203] = 8'h1f; sbox[204] = 8'h4b; sbox[205] = 8'hbd; sbox[206] = 8'h8b; sbox[207] = 8'h8a; sbox[208] = 8'h70; sbox[209] = 8'h3e; sbox[210] = 8'hb5; sbox[211] = 8'h66; sbox[212] = 8'h48; sbox[213] = 8'h03; sbox[214] = 8'hf6; sbox[215] = 8'h0e; sbox[216] = 8'h61; sbox[217] = 8'h35; sbox[218] = 8'h57; sbox[219] = 8'hb9; sbox[220] = 8'h86; sbox[221] = 8'hc1; sbox[222] = 8'h1d; sbox[223] = 8'h9e; sbox[224] = 8'he1; sbox[225] = 8'hf8; sbox[226] = 8'h98; sbox[227] = 8'h11; sbox[228] = 8'h69; sbox[229] = 8'hd9; sbox[230] = 8'h8e; sbox[231] = 8'h94; sbox[232] = 8'h9b; sbox[233] = 8'h1e; sbox[234] = 8'h87; sbox[235] = 8'he9; sbox[236] = 8'hce; sbox[237] = 8'h55; sbox[238] = 8'h28; sbox[239] = 8'hdf; sbox[240] = 8'h8c; sbox[241] = 8'ha1; sbox[242] = 8'h89; sbox[243] = 8'h0d; sbox[244] = 8'hbf; sbox[245] = 8'he6; sbox[246] = 8'h42; sbox[247] = 8'h68; sbox[248] = 8'h41; sbox[249] = 8'h99; sbox[250] = 8'h2d; sbox[251] = 8'h0f; sbox[252] = 8'hb0; sbox[253] = 8'h54; sbox[254] = 8'hbb; sbox[255] = 8'h16;
    
  end 
  
  always @(plain_text,key) begin
    W[3] = key[31:0];
    W[2] = key[63:32];
    W[1] = key[95:64];
    W[0] = key[127:96];

    j = 0;
    for (i=4;i<44;i=i+1) begin
      x = W[i-1];
      y = W[i-4];
      b1 = x [7:0];
      b2 = x [15:8];
      b3= x [23:16];
      b4= x [31:24];
      
      //rotate left
      tmp = b4;
      b4 = b3;
      b3 = b2;
      b2 = b1;
      b1 = tmp;
	 
      //sbox substitution
      //-->>
      
      b4 = sbox[(b4[7:4]*16)+b4[3:0]];
      b3 = sbox[(b3[7:4]*16)+b3[3:0]];
      b2 = sbox[(b2[7:4]*16)+b2[3:0]];
      b1 = sbox[(b1[7:4]*16)+b1[3:0]];

     // round constant
      if(i%4 == 0) begin
        j = j+1;
        x = Rcon[j] ^ {b4,b3,b2,b1};
        x= x^y;
      end
      else
        x = x ^ y;
      
      W[i] = x;
    end
  end
  
  
task aRK;
  input [127:0] plain_text; 
  input [127:0] Wtmp128i;
  output [127:0] Wtmp128o;

    begin
        Wtmp128o = plain_text ^ Wtmp128i;
    end
endtask

  

 task sB;
   input [7:0]Wtmp8i;
   output [7:0]Wtmp8o;
    begin
      Wtmp8o = sbox[16*Wtmp8i[7:4]+Wtmp8i[3:0]];
    end
 endtask
  
  
  
  
 task sR;
  input [127:0]Wtmp;
  output [127:0]Wtmp128o;
  reg [127:0]shifted;
  reg [31:0]ex;
  reg [7:0]tmp;
  integer count,i;
  reg [31:0]Wd[3:0];
  begin
    for (i=0;i<4;i=i+1) begin
      count = 0;
      eas = 127 - 8*i;
      ex = {Wtmp[eas-:8],Wtmp[(eas-32)-:8],Wtmp[(eas-64)-:8],Wtmp[(eas-96)-:8]};

      while (count != i) begin
      //left shift
      tmp = ex[31:24];
      
      ex[31:24]=ex[23:16];
      ex[23:16]=ex[15:8];
      ex[15:8]=ex[7:0];
      ex[7:0]=tmp;
      count= count+1;
    end
      
      Wtmp128o[eas-:8] = ex[31:24];
      Wtmp128o[(eas-32)-:8] = ex[23:16];
      Wtmp128o[(eas-64)-:8] = ex[15:8];
      Wtmp128o[(eas-96)-:8] = ex[7:0];

    end
  end
  endtask
  
  
  task mix_columns;
    input [127:0]word;
    reg [31:0]Wd[3:0];
    reg [2:0]b[15:0];
    reg [7:0]s[15:0];
    output reg [127:0]ans;
    integer i,j;
    begin
    b[0] = 2;b[1] = 3;b[2] = 1; b[3] = 1;
    b[4] = 1;b[5] = 2;b[6] = 3; b[7] = 1;
    b[8] = 1;b[9] = 1;b[10] = 2; b[11] = 3;
    b[12] = 3;b[13] = 1;b[14] = 1; b[15] = 2;
  end
  
    begin
        Wd[0] = word[127:96];
        Wd[1] = word[95:64];
        Wd[2] = word[63:32];
        Wd[3] = word[31:0];
	    
        s[0] = multiply(Wd[0],b[0],b[1],b[2],b[3]);   
        s[1] = multiply(Wd[0],b[4],b[5],b[6],b[7]);
        s[2] = multiply(Wd[0],b[8],b[9],b[10],b[11]);   
        s[3] = multiply(Wd[0],b[12],b[13],b[14],b[15]);
        s[4] = multiply(Wd[1],b[0],b[1],b[2],b[3]);   
        s[5] = multiply(Wd[1],b[4],b[5],b[6],b[7]);
        s[6] = multiply(Wd[1],b[8],b[9],b[10],b[11]);   
        s[7] = multiply(Wd[1],b[12],b[13],b[14],b[15]);
        s[8] = multiply(Wd[2],b[0],b[1],b[2],b[3]);  
        s[9] = multiply(Wd[2],b[4],b[5],b[6],b[7]);
        s[10] = multiply(Wd[2],b[8],b[9],b[10],b[11]);   
        s[11] = multiply(Wd[2],b[12],b[13],b[14],b[15]);
        s[12] = multiply(Wd[3],b[0],b[1],b[2],b[3]);  
        s[13] = multiply(Wd[3],b[4],b[5],b[6],b[7]);
        s[14] = multiply(Wd[3],b[8],b[9],b[10],b[11]);   
        s[15] = multiply(Wd[3],b[12],b[13],b[14],b[15]);
        
        
        
      for(i=0;i<16;i=i+1)
        ans[(127-(8*i)) -: 8] = s[i];  
    end
    
  endtask
    
    function [7:0]multiply;
        input [31:0]a;
        input [2:0]b0,b1,b2,b3;    
        reg [31:0]t1,t2,t3,t4;
        begin
          t4 = goliath(a[31:24],b0);
          t3 = goliath(a[23:16],b1);
          t2 = goliath(a[15:8],b2);
          t1 = goliath(a[7:0], b3);
            
          multiply = t1 ^ t2 ^ t3 ^ t4;
        end
    endfunction
    
    function [7:0]goliath;
        input [7:0]a,b;
        begin
        if (b == 1)
            goliath = a;
        else if (b == 2) begin
            goliath = a << 1;
            if (a[7])
                goliath = goliath ^ 8'h1B;
        end
        else begin
            goliath = a << 1;
            if(a[7])
                goliath = goliath ^ 8'h1B;
            goliath = goliath ^ a;
        end
        end
    endfunction
    
  always @(*)begin
    
    if (rst) begin
      round = 0;
      state = IDLE;
      Wtmp = 0;
      Wtmp128i=0;
      
    end
    else
      state = next_state;
  end
  
  always @(*) begin
    case(state)
  	  
      IDLE: begin
        next_state = addRoundKey;
      end
       
      
      addRoundKey: begin
         if(round==0)
         	Wtmp128i = plain_text;
         else
           Wtmp128i = Wtmp;
         aRK(Wtmp128i, {W[(round*4)],W[(round*4)+1],W[(round*4)+2],W[(round*4)+3]}, Wtmp);
         next_state = subBytes;
        
         round = round+1;
      end
      
     
      subBytes: begin
        if(round < 11) begin
        for(i=0;i<16;i=i+1) begin
          j= 8*i;
          Wtmp8i[i] = Wtmp[i*8 +: 8]; 
          /////Wtmp[i*8 +: 8], where i*8 specifies the starting bit, and +: 8 specifies the width of the slice.
          sB(Wtmp8i[i],Wtmp8o[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
          Wtmp[i*8 +: 8] = Wtmp8o[i];
        end
        next_state = shiftRows;
      end
        else
          next_state = subBytes;
      end
      
      shiftRows: begin
        sR(Wtmp,Wtmp128o);
        Wtmp = Wtmp128o;
        if(round<10)
        	next_state = mixColumns;
      	else
          	next_state = addRoundKey;
      end
      
      mixColumns: begin
        mix_columns(Wtmp,Wtmp128o);
        Wtmp = Wtmp128o;
        next_state = addRoundKey;
      end
      
      default: 
        next_state = IDLE;
    endcase
    if(round==11)
    	out = Wtmp;
  end  
endmodule
