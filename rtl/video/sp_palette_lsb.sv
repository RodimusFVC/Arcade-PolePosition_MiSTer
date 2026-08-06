//============================================================================
//  sp_palette_lsb.sv -- 1:1 transliteration of rtl/sp_palette_lsb.vhd
//  (Pole Position palette PROM, LSB nibble).
//
//  Mechanical VHDL -> SystemVerilog port, 2026-08-05. This is a plain ROM/LUT
//  init wrapper: a hardcoded 512x8 lookup table with a single synchronous
//  (registered) read port, no write port, no byteena, no reset. addr is 9-bit
//  (0..511), matching the array bounds exactly -- no out-of-range case exists.
//  Read latency is 1 clock (data <= rom_data[addr], registered same as the VHDL
//  process). Data values below are transcribed byte-for-byte from the VHDL
//  positional aggregate, same 16-values-per-line grouping, for easy line-by-line
//  audit against the .vhd (source of truth; do not edit that file).
//============================================================================
`default_nettype none

module sp_palette_lsb (
    input  wire       clk,
    input  wire [8:0] addr,
    output logic [7:0] data
);

    logic [7:0] rom_data [0:511];

    initial begin
        rom_data[0]=8'h00; rom_data[1]=8'h00; rom_data[2]=8'h00; rom_data[3]=8'h00; rom_data[4]=8'h00; rom_data[5]=8'h00; rom_data[6]=8'h00; rom_data[7]=8'h00; rom_data[8]=8'h00; rom_data[9]=8'h09; rom_data[10]=8'h05; rom_data[11]=8'h05; rom_data[12]=8'h01; rom_data[13]=8'h04; rom_data[14]=8'h06; rom_data[15]=8'h05;
        rom_data[16]=8'h00; rom_data[17]=8'h06; rom_data[18]=8'h00; rom_data[19]=8'h06; rom_data[20]=8'h07; rom_data[21]=8'h04; rom_data[22]=8'h08; rom_data[23]=8'h09; rom_data[24]=8'h00; rom_data[25]=8'h0F; rom_data[26]=8'h00; rom_data[27]=8'h06; rom_data[28]=8'h07; rom_data[29]=8'h04; rom_data[30]=8'h08; rom_data[31]=8'h09;
        rom_data[32]=8'h00; rom_data[33]=8'h07; rom_data[34]=8'h00; rom_data[35]=8'h06; rom_data[36]=8'h07; rom_data[37]=8'h04; rom_data[38]=8'h08; rom_data[39]=8'h09; rom_data[40]=8'h00; rom_data[41]=8'h08; rom_data[42]=8'h00; rom_data[43]=8'h06; rom_data[44]=8'h07; rom_data[45]=8'h04; rom_data[46]=8'h08; rom_data[47]=8'h09;
        rom_data[48]=8'h00; rom_data[49]=8'h00; rom_data[50]=8'h00; rom_data[51]=8'h06; rom_data[52]=8'h07; rom_data[53]=8'h04; rom_data[54]=8'h08; rom_data[55]=8'h09; rom_data[56]=8'h00; rom_data[57]=8'h0D; rom_data[58]=8'h05; rom_data[59]=8'h05; rom_data[60]=8'h01; rom_data[61]=8'h04; rom_data[62]=8'h00; rom_data[63]=8'h06;
        rom_data[64]=8'h00; rom_data[65]=8'h0D; rom_data[66]=8'h05; rom_data[67]=8'h05; rom_data[68]=8'h01; rom_data[69]=8'h04; rom_data[70]=8'h00; rom_data[71]=8'h0F; rom_data[72]=8'h00; rom_data[73]=8'h0D; rom_data[74]=8'h05; rom_data[75]=8'h05; rom_data[76]=8'h01; rom_data[77]=8'h04; rom_data[78]=8'h00; rom_data[79]=8'h07;
        rom_data[80]=8'h00; rom_data[81]=8'h0D; rom_data[82]=8'h05; rom_data[83]=8'h05; rom_data[84]=8'h01; rom_data[85]=8'h04; rom_data[86]=8'h00; rom_data[87]=8'h09; rom_data[88]=8'h00; rom_data[89]=8'h0D; rom_data[90]=8'h05; rom_data[91]=8'h05; rom_data[92]=8'h01; rom_data[93]=8'h04; rom_data[94]=8'h00; rom_data[95]=8'h00;
        rom_data[96]=8'h00; rom_data[97]=8'h05; rom_data[98]=8'h01; rom_data[99]=8'h0D; rom_data[100]=8'h06; rom_data[101]=8'h04; rom_data[102]=8'h06; rom_data[103]=8'h07; rom_data[104]=8'h00; rom_data[105]=8'h09; rom_data[106]=8'h0A; rom_data[107]=8'h0B; rom_data[108]=8'h0D; rom_data[109]=8'h09; rom_data[110]=8'h00; rom_data[111]=8'h06;
        rom_data[112]=8'h00; rom_data[113]=8'h06; rom_data[114]=8'h06; rom_data[115]=8'h00; rom_data[116]=8'h00; rom_data[117]=8'h00; rom_data[118]=8'h00; rom_data[119]=8'h00; rom_data[120]=8'h00; rom_data[121]=8'h0D; rom_data[122]=8'h00; rom_data[123]=8'h00; rom_data[124]=8'h00; rom_data[125]=8'h00; rom_data[126]=8'h00; rom_data[127]=8'h00;
        rom_data[128]=8'h00; rom_data[129]=8'h06; rom_data[130]=8'h00; rom_data[131]=8'h0D; rom_data[132]=8'h00; rom_data[133]=8'h00; rom_data[134]=8'h00; rom_data[135]=8'h00; rom_data[136]=8'h00; rom_data[137]=8'h0F; rom_data[138]=8'h00; rom_data[139]=8'h0D; rom_data[140]=8'h00; rom_data[141]=8'h00; rom_data[142]=8'h00; rom_data[143]=8'h00;
        rom_data[144]=8'h00; rom_data[145]=8'h07; rom_data[146]=8'h00; rom_data[147]=8'h0D; rom_data[148]=8'h00; rom_data[149]=8'h00; rom_data[150]=8'h00; rom_data[151]=8'h00; rom_data[152]=8'h00; rom_data[153]=8'h08; rom_data[154]=8'h00; rom_data[155]=8'h0D; rom_data[156]=8'h00; rom_data[157]=8'h00; rom_data[158]=8'h00; rom_data[159]=8'h00;
        rom_data[160]=8'h00; rom_data[161]=8'h00; rom_data[162]=8'h00; rom_data[163]=8'h0D; rom_data[164]=8'h00; rom_data[165]=8'h00; rom_data[166]=8'h00; rom_data[167]=8'h00; rom_data[168]=8'h00; rom_data[169]=8'h06; rom_data[170]=8'h07; rom_data[171]=8'h07; rom_data[172]=8'h09; rom_data[173]=8'h09; rom_data[174]=8'h00; rom_data[175]=8'h06;
        rom_data[176]=8'h00; rom_data[177]=8'h04; rom_data[178]=8'h0F; rom_data[179]=8'h0F; rom_data[180]=8'h00; rom_data[181]=8'h00; rom_data[182]=8'h00; rom_data[183]=8'h04; rom_data[184]=8'h00; rom_data[185]=8'h06; rom_data[186]=8'h01; rom_data[187]=8'h01; rom_data[188]=8'h02; rom_data[189]=8'h02; rom_data[190]=8'h00; rom_data[191]=8'h06;
        rom_data[192]=8'h00; rom_data[193]=8'h0C; rom_data[194]=8'h03; rom_data[195]=8'h03; rom_data[196]=8'h03; rom_data[197]=8'h03; rom_data[198]=8'h00; rom_data[199]=8'h0C; rom_data[200]=8'h00; rom_data[201]=8'h05; rom_data[202]=8'h04; rom_data[203]=8'h04; rom_data[204]=8'h05; rom_data[205]=8'h05; rom_data[206]=8'h00; rom_data[207]=8'h05;
        rom_data[208]=8'h00; rom_data[209]=8'h0C; rom_data[210]=8'h06; rom_data[211]=8'h06; rom_data[212]=8'h07; rom_data[213]=8'h07; rom_data[214]=8'h00; rom_data[215]=8'h0C; rom_data[216]=8'h00; rom_data[217]=8'h0D; rom_data[218]=8'h08; rom_data[219]=8'h08; rom_data[220]=8'h09; rom_data[221]=8'h09; rom_data[222]=8'h00; rom_data[223]=8'h0D;
        rom_data[224]=8'h00; rom_data[225]=8'h0E; rom_data[226]=8'h0A; rom_data[227]=8'h0A; rom_data[228]=8'h0B; rom_data[229]=8'h0B; rom_data[230]=8'h00; rom_data[231]=8'h0E; rom_data[232]=8'h00; rom_data[233]=8'h0D; rom_data[234]=8'h00; rom_data[235]=8'h06; rom_data[236]=8'h07; rom_data[237]=8'h04; rom_data[238]=8'h08; rom_data[239]=8'h09;
        rom_data[240]=8'h00; rom_data[241]=8'h00; rom_data[242]=8'h00; rom_data[243]=8'h00; rom_data[244]=8'h00; rom_data[245]=8'h00; rom_data[246]=8'h00; rom_data[247]=8'h00; rom_data[248]=8'h00; rom_data[249]=8'h00; rom_data[250]=8'h00; rom_data[251]=8'h00; rom_data[252]=8'h00; rom_data[253]=8'h00; rom_data[254]=8'h00; rom_data[255]=8'h00;
        rom_data[256]=8'h00; rom_data[257]=8'h09; rom_data[258]=8'h06; rom_data[259]=8'h09; rom_data[260]=8'h00; rom_data[261]=8'h00; rom_data[262]=8'h00; rom_data[263]=8'h00; rom_data[264]=8'h00; rom_data[265]=8'h09; rom_data[266]=8'h00; rom_data[267]=8'h09; rom_data[268]=8'h00; rom_data[269]=8'h00; rom_data[270]=8'h00; rom_data[271]=8'h00;
        rom_data[272]=8'h00; rom_data[273]=8'h04; rom_data[274]=8'h00; rom_data[275]=8'h00; rom_data[276]=8'h00; rom_data[277]=8'h00; rom_data[278]=8'h00; rom_data[279]=8'h00; rom_data[280]=8'h00; rom_data[281]=8'h0D; rom_data[282]=8'h06; rom_data[283]=8'h06; rom_data[284]=8'h00; rom_data[285]=8'h00; rom_data[286]=8'h00; rom_data[287]=8'h00;
        rom_data[288]=8'h00; rom_data[289]=8'h05; rom_data[290]=8'h06; rom_data[291]=8'h06; rom_data[292]=8'h00; rom_data[293]=8'h00; rom_data[294]=8'h00; rom_data[295]=8'h00; rom_data[296]=8'h00; rom_data[297]=8'h0D; rom_data[298]=8'h06; rom_data[299]=8'h00; rom_data[300]=8'h00; rom_data[301]=8'h00; rom_data[302]=8'h00; rom_data[303]=8'h00;
        rom_data[304]=8'h00; rom_data[305]=8'h06; rom_data[306]=8'h0D; rom_data[307]=8'h00; rom_data[308]=8'h00; rom_data[309]=8'h00; rom_data[310]=8'h00; rom_data[311]=8'h00; rom_data[312]=8'h00; rom_data[313]=8'h0D; rom_data[314]=8'h06; rom_data[315]=8'h00; rom_data[316]=8'h00; rom_data[317]=8'h00; rom_data[318]=8'h00; rom_data[319]=8'h00;
        rom_data[320]=8'h00; rom_data[321]=8'h06; rom_data[322]=8'h0D; rom_data[323]=8'h00; rom_data[324]=8'h00; rom_data[325]=8'h00; rom_data[326]=8'h00; rom_data[327]=8'h00; rom_data[328]=8'h00; rom_data[329]=8'h09; rom_data[330]=8'h06; rom_data[331]=8'h06; rom_data[332]=8'h00; rom_data[333]=8'h00; rom_data[334]=8'h00; rom_data[335]=8'h00;
        rom_data[336]=8'h00; rom_data[337]=8'h09; rom_data[338]=8'h00; rom_data[339]=8'h06; rom_data[340]=8'h00; rom_data[341]=8'h00; rom_data[342]=8'h00; rom_data[343]=8'h00; rom_data[344]=8'h00; rom_data[345]=8'h05; rom_data[346]=8'h01; rom_data[347]=8'h03; rom_data[348]=8'h00; rom_data[349]=8'h00; rom_data[350]=8'h00; rom_data[351]=8'h00;
        rom_data[352]=8'h00; rom_data[353]=8'h05; rom_data[354]=8'h04; rom_data[355]=8'h00; rom_data[356]=8'h00; rom_data[357]=8'h00; rom_data[358]=8'h00; rom_data[359]=8'h00; rom_data[360]=8'h00; rom_data[361]=8'h0D; rom_data[362]=8'h09; rom_data[363]=8'h05; rom_data[364]=8'h05; rom_data[365]=8'h01; rom_data[366]=8'h04; rom_data[367]=8'h09;
        rom_data[368]=8'h00; rom_data[369]=8'h0D; rom_data[370]=8'h09; rom_data[371]=8'h05; rom_data[372]=8'h0C; rom_data[373]=8'h0D; rom_data[374]=8'h09; rom_data[375]=8'h00; rom_data[376]=8'h00; rom_data[377]=8'h0D; rom_data[378]=8'h0C; rom_data[379]=8'h0D; rom_data[380]=8'h0B; rom_data[381]=8'h0C; rom_data[382]=8'h0E; rom_data[383]=8'h06;
        rom_data[384]=8'h00; rom_data[385]=8'h0D; rom_data[386]=8'h06; rom_data[387]=8'h0F; rom_data[388]=8'h05; rom_data[389]=8'h05; rom_data[390]=8'h01; rom_data[391]=8'h04; rom_data[392]=8'h00; rom_data[393]=8'h08; rom_data[394]=8'h0C; rom_data[395]=8'h0F; rom_data[396]=8'h04; rom_data[397]=8'h0E; rom_data[398]=8'h01; rom_data[399]=8'h00;
        rom_data[400]=8'h00; rom_data[401]=8'h0F; rom_data[402]=8'h0F; rom_data[403]=8'h00; rom_data[404]=8'h0C; rom_data[405]=8'h08; rom_data[406]=8'h01; rom_data[407]=8'h00; rom_data[408]=8'h00; rom_data[409]=8'h0D; rom_data[410]=8'h0F; rom_data[411]=8'h08; rom_data[412]=8'h0F; rom_data[413]=8'h05; rom_data[414]=8'h05; rom_data[415]=8'h01;
        rom_data[416]=8'h00; rom_data[417]=8'h0F; rom_data[418]=8'h07; rom_data[419]=8'h08; rom_data[420]=8'h0D; rom_data[421]=8'h0F; rom_data[422]=8'h05; rom_data[423]=8'h05; rom_data[424]=8'h00; rom_data[425]=8'h0D; rom_data[426]=8'h0F; rom_data[427]=8'h05; rom_data[428]=8'h05; rom_data[429]=8'h04; rom_data[430]=8'h06; rom_data[431]=8'h0F;
        rom_data[432]=8'h00; rom_data[433]=8'h0F; rom_data[434]=8'h05; rom_data[435]=8'h05; rom_data[436]=8'h01; rom_data[437]=8'h04; rom_data[438]=8'h06; rom_data[439]=8'h0F; rom_data[440]=8'h00; rom_data[441]=8'h00; rom_data[442]=8'h00; rom_data[443]=8'h00; rom_data[444]=8'h00; rom_data[445]=8'h00; rom_data[446]=8'h00; rom_data[447]=8'h00;
        rom_data[448]=8'h00; rom_data[449]=8'h00; rom_data[450]=8'h00; rom_data[451]=8'h00; rom_data[452]=8'h00; rom_data[453]=8'h00; rom_data[454]=8'h00; rom_data[455]=8'h00; rom_data[456]=8'h00; rom_data[457]=8'h00; rom_data[458]=8'h00; rom_data[459]=8'h00; rom_data[460]=8'h00; rom_data[461]=8'h00; rom_data[462]=8'h00; rom_data[463]=8'h00;
        rom_data[464]=8'h00; rom_data[465]=8'h00; rom_data[466]=8'h00; rom_data[467]=8'h00; rom_data[468]=8'h00; rom_data[469]=8'h00; rom_data[470]=8'h00; rom_data[471]=8'h00; rom_data[472]=8'h00; rom_data[473]=8'h00; rom_data[474]=8'h00; rom_data[475]=8'h00; rom_data[476]=8'h00; rom_data[477]=8'h00; rom_data[478]=8'h00; rom_data[479]=8'h00;
        rom_data[480]=8'h00; rom_data[481]=8'h00; rom_data[482]=8'h00; rom_data[483]=8'h00; rom_data[484]=8'h00; rom_data[485]=8'h00; rom_data[486]=8'h00; rom_data[487]=8'h00; rom_data[488]=8'h00; rom_data[489]=8'h00; rom_data[490]=8'h00; rom_data[491]=8'h00; rom_data[492]=8'h00; rom_data[493]=8'h00; rom_data[494]=8'h00; rom_data[495]=8'h00;
        rom_data[496]=8'h00; rom_data[497]=8'h00; rom_data[498]=8'h00; rom_data[499]=8'h00; rom_data[500]=8'h00; rom_data[501]=8'h00; rom_data[502]=8'h00; rom_data[503]=8'h00; rom_data[504]=8'h00; rom_data[505]=8'h00; rom_data[506]=8'h00; rom_data[507]=8'h00; rom_data[508]=8'h00; rom_data[509]=8'h00; rom_data[510]=8'h00; rom_data[511]=8'h00;
    end

    always_ff @(posedge clk) begin
        data <= rom_data[addr];
    end

endmodule

`default_nettype wire
