module m_trap_setup_regs (
    output [31:0] misa,
    output [31:0] mtvec,
    output [31:0] mcounteren
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

    // Machine Trap Vector Register
    // might need to allow setup of mtvec value on boot ...

    // Base Address
    // TODO: need to confirm the Base Address value
    localparam [31:0] trap_vector_base_addr = 32'h4;    // 0000_0004
    // Trap Vector Mode
    // 0    : Direct    : pc = trap_vector_base_addr
    // 1    : Vectored  : pc = trap_vector_base_addr + 4 * cause
    // >= 2 : Reserved
    localparam [1:0] trap_vector_mode = 2'b00;
    // mtvec: { BASE, MODE }
    assign mtvec = { trap_vector_base_addr[31:2], trap_vector_mode };

    // Machine Counter-Enable Register
    // don't allow for the moment
    assign mcounteren = 32'b0;
    
endmodule
