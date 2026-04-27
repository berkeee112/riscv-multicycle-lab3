module alu(
    input  logic [31:0] a, b,
    input  logic [2:0]  alucontrol,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        case (alucontrol)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            default: result = 32'bx;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule