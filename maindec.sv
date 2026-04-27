module maindec(
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    output logic [1:0] alusrca,
    output logic [1:0] alusrcb,
    output logic [1:0] resultsrc,
    output logic       adrsrc,
    output logic       irwrite,
    output logic       regwrite,
    output logic       memwrite,
    output logic       branch,
    output logic       pcupdate,
    output logic [1:0] aluop
);

    typedef enum logic [3:0] {
        S0_FETCH    = 4'd0,
        S1_DECODE   = 4'd1,
        S2_MEMADR   = 4'd2,
        S3_MEMREAD  = 4'd3,
        S4_MEMWB    = 4'd4,
        S5_MEMWRITE = 4'd5,
        S6_EXECUTER = 4'd6,
        S7_ALUWB    = 4'd7,
        S8_EXECUTEI = 4'd8,
        S9_JAL      = 4'd9,
        S10_BEQ     = 4'd10
    } statetype;

    statetype state, nextstate;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0_FETCH;
        else
            state <= nextstate;
    end

    always_comb begin
        case (state)
            S0_FETCH: nextstate = S1_DECODE;

            S1_DECODE: begin
                case (op)
                    7'b0000011: nextstate = S2_MEMADR;
                    7'b0100011: nextstate = S2_MEMADR;
                    7'b0110011: nextstate = S6_EXECUTER;
                    7'b0010011: nextstate = S8_EXECUTEI;
                    7'b1101111: nextstate = S9_JAL;
                    7'b1100011: nextstate = S10_BEQ;
                    default:    nextstate = S0_FETCH;
                endcase
            end

            S2_MEMADR: begin
                case (op)
                    7'b0000011: nextstate = S3_MEMREAD;
                    7'b0100011: nextstate = S5_MEMWRITE;
                    default:    nextstate = S0_FETCH;
                endcase
            end

            S3_MEMREAD:  nextstate = S4_MEMWB;
            S4_MEMWB:    nextstate = S0_FETCH;
            S5_MEMWRITE: nextstate = S0_FETCH;
            S6_EXECUTER: nextstate = S7_ALUWB;
            S7_ALUWB:    nextstate = S0_FETCH;
            S8_EXECUTEI: nextstate = S7_ALUWB;
            S9_JAL:      nextstate = S7_ALUWB;
            S10_BEQ:     nextstate = S0_FETCH;
            default:     nextstate = S0_FETCH;
        endcase
    end

    always_comb begin
        alusrca   = 2'b00;
        alusrcb   = 2'b00;
        resultsrc = 2'b00;
        adrsrc    = 1'b0;
        irwrite   = 1'b0;
        regwrite  = 1'b0;
        memwrite  = 1'b0;
        branch    = 1'b0;
        pcupdate  = 1'b0;
        aluop     = 2'b00;

        case (state)

            S0_FETCH: begin
                alusrca   = 2'b00; // PC
                alusrcb   = 2'b10; // 4
                resultsrc = 2'b10; // ALUResult
                adrsrc    = 1'b0;  // PC
                irwrite   = 1'b1;
                pcupdate  = 1'b1;
                aluop     = 2'b00; // add
            end

            S1_DECODE: begin
                alusrca = 2'b01; // OldPC
                alusrcb = 2'b01; // ImmExt
                aluop   = 2'b00; // branch/jal target calculate
            end

            S2_MEMADR: begin
                alusrca = 2'b10; // A
                alusrcb = 2'b01; // ImmExt
                aluop   = 2'b00; // add
            end

            S3_MEMREAD: begin
                adrsrc = 1'b1; // Result
            end

            S4_MEMWB: begin
                resultsrc = 2'b01; // Data
                regwrite  = 1'b1;
            end

            S5_MEMWRITE: begin
                adrsrc   = 1'b1;
                memwrite = 1'b1;
            end

            S6_EXECUTER: begin
                alusrca = 2'b10; // A
                alusrcb = 2'b00; // B
                aluop   = 2'b10; // R-type
            end

            S7_ALUWB: begin
                resultsrc = 2'b00; // ALUOut
                regwrite  = 1'b1;
            end

            S8_EXECUTEI: begin
                alusrca = 2'b10; // A
                alusrcb = 2'b01; // ImmExt
                aluop   = 2'b10;
            end

            S9_JAL: begin
                alusrca   = 2'b01; // OldPC
                alusrcb   = 2'b10; // 4
                resultsrc = 2'b00; // ALUOut target to PC
                pcupdate  = 1'b1;
                aluop     = 2'b00;
            end

            S10_BEQ: begin
                alusrca   = 2'b10; // A
                alusrcb   = 2'b00; // B
                resultsrc = 2'b00; // ALUOut target
                branch    = 1'b1;
                aluop     = 2'b01; // sub
            end

        endcase
    end

endmodule