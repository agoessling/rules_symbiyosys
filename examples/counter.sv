module counter #(
    parameter MAX_VAL = 3
) (
    input logic i_clk,
    output logic [5:0] o_count
);

  initial o_count = 0;

  always_ff @(posedge i_clk) begin
    if (o_count == MAX_VAL) begin
      o_count <= 0;
    end else begin
      o_count <= o_count + 1;
    end
  end

`ifdef FORMAL
  always_ff @(posedge i_clk) begin
    assert(o_count < 10);
  end
`endif

endmodule
