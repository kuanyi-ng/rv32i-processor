module if_flush_picker (
    input e_raised,
    input flush_from_flush_u,

    output flush_out
);
    // e_raised flush_u flush
    // 0        0       0
    // 0        1       1
    // 1        0       1
    // 1        1       1
    assign flush_out = (e_raised || flush_from_flush_u);

endmodule
