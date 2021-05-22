// Use for
// - wr_reg_n
// - wr_csr_n
module id_wr_n_picker (
    input wr_n_in,
    input flush_id,

    output wr_n_out
);

    // wr_n_in  flush   wr_n_out
    // 0            0       0
    // 0            1       1
    // 1            0       1
    // 1            1       1
assign wr_n_out = (wr_n_in || flush_id);

endmodule
