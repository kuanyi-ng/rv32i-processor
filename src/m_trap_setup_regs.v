module m_trap_setup_regs (
    output [31:0] misa
);

    // Machine ISA Register
    // [31:30]  : length of instruction, MXL = { 1: 32, 2: 64, 3: 128 }
    // [29:26]  : ??
    // [25:0]   : Extensions
    // [8]      : RV32I/64I/128I base ISA
    // [18]     : Supervisor Mode implemented
    // [20]     : User Model implemented
    //
    // the current implementation doesn't allow software to change the ISA supported,
    // so misa will be a read-only register in this implementation.
    assign misa = { 2'b01, 4'b0, 26'b00_00_00_00_00_00_00_00_01_00_00_00_00 };
    
endmodule