module riscvmulti(
    input  logic        clk, reset,
    output logic        MemWrite,
    output logic [31:0] Adr, WriteData,
    input  logic [31:0] ReadData
);

    logic [6:0] op;
    logic [2:0] funct3;
    logic       funct7b5;
    logic       Zero;

    logic [1:0] ImmSrc;
    logic [1:0] ALUSrcA, ALUSrcB;
    logic [1:0] ResultSrc;
    logic       AdrSrc;
    logic [2:0] ALUControl;
    logic       IRWrite, PCWrite, RegWrite;

    logic [31:0] Instr;

    controller c(
        .clk(clk),
        .reset(reset),
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .zero(Zero),
        .immsrc(ImmSrc),
        .alusrca(ALUSrcA),
        .alusrcb(ALUSrcB),
        .resultsrc(ResultSrc),
        .adrsrc(AdrSrc),
        .alucontrol(ALUControl),
        .irwrite(IRWrite),
        .pcwrite(PCWrite),
        .regwrite(RegWrite),
        .memwrite(MemWrite)
    );

    datapath dp(
        .clk(clk),
        .reset(reset),
        .ImmSrc(ImmSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .AdrSrc(AdrSrc),
        .ALUControl(ALUControl),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .ReadData(ReadData),
        .Zero(Zero),
        .Adr(Adr),
        .WriteData(WriteData),
        .Instr(Instr)
    );

    assign op       = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7b5 = Instr[30];

endmodule