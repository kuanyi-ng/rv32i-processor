module id_flush_picker (
    input flush_from_if,
    input flush_from_flush_u,

    output flush
);
    // if   flush_u flush
    // 0    0       0
    // 0    1       1
    // 1    0       1
    // 1    1       1
    assign flush = (flush_from_if || flush_from_flush_u);

endmodule