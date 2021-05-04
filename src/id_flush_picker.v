module id_flush_picker (
    input flush_from_if,
    input flush_from_flush_u,

    output flush_out
);
    // if   flush_u flush
    // 0    0       0
    // 0    1       1
    // 1    0       1
    // 1    1       1
    assign flush_out = (flush_from_if || flush_from_flush_u);

endmodule
