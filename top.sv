module top(
    input  logic        clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic        MemWrite
);

    logic [31:0] ReadData;

    riscvmulti rvmulti(
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .Adr(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    mem mem1(
        .clk(clk),
        .we(MemWrite),
        .a(DataAdr),
        .wd(WriteData),
        .rd(ReadData)
    );

endmodule