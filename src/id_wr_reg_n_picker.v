module id_wr_reg_n_picker (
    input wr_reg_n_in,
    input flush_id,

    output wr_reg_n_out
);

    // wr_reg_n_in  flush   wr_reg_n_out
    // 0            0       0
    // 0            1       1
    // 1            0       1
    // 1            1       1
assign wr_reg_n_out = (wr_reg_n_in || flush_id);
    
endmodule
