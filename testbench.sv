module testbench();

  logic        clk;
  logic        reset;
  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;

  // DUT
  top dut(clk, reset, WriteData, DataAdr, MemWrite);

  // initialize test
  initial begin
    reset <= 1;
    #22;
    reset <= 0;
  end

  // clock
  always begin
    clk <= 1; #5;
    clk <= 0; #5;
  end

  // timeout (çok önemli)
  initial begin
    #2000;
    $display("Simulation timed out");
    $stop;
  end

  // check result
  always @(negedge clk) begin
    if (MemWrite) begin
      if (DataAdr === 32'd100 && WriteData === 32'd25) begin
        $display("Simulation succeeded");
        $stop;
      end
      else begin
        $display("Wrong write:");
        $display("Address = %0d, Data = %0d", DataAdr, WriteData);
      end
    end
  end

endmodule