module counter_top #(
    parameter MAX_VAL = 15
) (
    input logic i_clk
);

  logic [5:0] count;
  counter #(.MAX_VAL(MAX_VAL)) counter (
      .i_clk,
      .o_count(count)
  );

`ifdef FORMAL
  always_comb begin
    assert(!(count & (1 << 5)));
  end
`endif

endmodule
