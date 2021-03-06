# Instruction Execution Table

## Execution Phase
1. IF: Instruction Fetch
2. ID: Instruction Decode
3. EX: Execution
4. MEM: Memory Access
5. WB: Writeback

## Instruction Execution Table

### U-Type
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>lui [U]</td>
            <!-- IF -->
            <td rowspan=2>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=2>
                U_imm ← sext(IR[31:12] << 12) <!-- sext: sign-extend-->
                <br />
                rd ← IR[11:7]
            </td>
            <!-- EX -->
            <td>
                C ← U_imm
            </td>
            <!-- MEM -->
            <td rowspan=2></td>
            <!-- WB -->
            <td rowspan=2>
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>auipc [U]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + U_imm
            </td>           
            <!-- MEM -->
            <!-- WB -->
        </tr>
    </tbody>
</table>

### I-Type
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>addi [I]</td>
            <!-- IF -->
            <td rowspan=9>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=6>
                rs1 ← IR[19:15]
                <br />
                A ← x[rs1]
                <br />
                I_imm ← sext(IR[31:20])
                <br />
                rd ← IR[11:7]
            </td>
            <!-- EX -->
            <td>
                C ← A + I_imm
            </td>
            <!-- MEM -->
            <td rowspan=9></td>
            <!-- WB -->
            <td rowspan=9>
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>slti [I]</td>   
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← (A < I_imm) ... signed
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>sltiu [I]</td>  
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A < I_imm) ... unsigned
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>xori [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A ^ I_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>ori [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A | I_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>andi [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A & I_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>slli [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=3>
                shamt_imm ← ext(IR[24:20])
                <br />
                rd ← IR[11:7]
            </td>
            <!-- EX -->
            <td>
                C ← A << shamt_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>srli [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A >>u shamt_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>srai [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A >>s shamt_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
    </tbody>
</table>

### R-Type
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>add [R]</td>
            <!-- IF -->
            <td rowspan=10>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=10>
                A ← x[rs1]
                <br />
                B ← x[rs2]
            </td>
            <!-- EX -->
            <td>
                C ← A + B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td rowspan=10>
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sub [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A - B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>sll [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A << B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>slt [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← (A < B) ... signed
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>sltu [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← (A < B) ... unsigned
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>xor [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A ^ B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>srl [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A >>u B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>sra [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A >>s B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>or [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A | B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>and [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A & B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
    </tbody>
</table>

### Load Instructions
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>lb [I]</td>
            <!-- IF -->
            <td rowspan=5>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=5>
                A ← x[rs1]
                <br />
                imm ← sext(IR[31:20])
            </td>
            <!-- EX -->
            <td rowspan=5>
                C ← A + imm
            </td>
            <!-- MEM -->
            <td>
                D ← sext(M[C][7:0])
            </td>
            <!-- WB -->
            <td rowspan=5>
                x[rd] ← D
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>lh [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                D ← sext(M[C][15:0])
            </td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>lw [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                D ← sext(M[C][31:0])
            </td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>lbu [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                D ← uext(M[C][7:0])
            </td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>lhu [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                D ← uext(M[C][15:0])
            </td>
            <!-- WB -->
        </tr>
    </tbody>
</table>

### S-Type
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>sb [S]</td>
            <!-- IF -->
            <td rowspan=3>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=3>
                A ← x[rs1]
                <br />
                B ← x[rs2]
                <br />
                S_imm = sext({ IR[31:25], IR[11:7] })
            </td>
            <!-- EX -->
            <td rowspan=3>
                C ← A + S_imm
            </td>
            <!-- MEM -->
            <td>
                M[C] ← B[7:0]
            </td>
            <!-- WB -->
            <td rowspan=3></td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sh [S]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                M[C] ← B[15:0]
            </td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>sw [S]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td>
                M[C] ← B[31:0]
            </td>
            <!-- WB -->
        </tr>
    </tbody>
</table>

### Jump Instructions
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>jal [J]</td>
            <!-- IF -->
            <td rowspan=2>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td>
                J_imm ← sext({ IR[31], IR[19:12], IR[20], IR[30:21], 0 })
            </td>
            <!-- EX -->
            <td>
                C ← PC + J_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                x[rd] ← PC + 4 <!-- need to make sure PC is not add by 4 twice (once from IF stage) -->
                <br />
                PC ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>jalr [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
                A ← x[rs1]
                <br />
                I_imm ← sext(IR[31:20])
            </td>
            <!-- EX -->
            <td>
                C ← (A + I_imm) & ~1
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                x[rd] ← PC + 4 <!-- need to make sure PC is not add by 4 twice (once from IF stage) -->
                <br />
                PC ← C
            </td>
        </tr>
    </tbody>
</table>

### B-Type
<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>beq [B]</td>
            <!-- IF -->
            <td rowspan=6>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td rowspan=6>
                A ← x[rs1]
                <br />
                B ← x[rs2]
                <br />
                B_imm ← sext({ IR[31], IR[7], IR[30:25], IR[11:8], 0 })
            </td>
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A == B)
            </td>
            <!-- MEM -->
            <td rowspan=6></td>
            <!-- WB -->
            <td rowspan=6>
                if (jump) PC ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>bne [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A != B)
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>blt [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A < B) ... signed
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>bge [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A >= B) ... signed
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>bltu [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A < B) ... unsigned
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>bgeu [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← PC + B_imm
                <br />
                jump = (A >= B) ... signed
            </td>
            <!-- MEM -->
            <!-- WB -->
        </tr>
    </tbody>
</table>

## Extra Instruction
> NOTE: These instructions are not required for a basic processor (running MiBench).

<table>
    <thead>
        <tr>
            <th>Instruction</th>
            <th>IF</th>
            <th>ID</th>
            <th>EX</th>
            <th>MEM</th>
            <th>WB</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!-- instruction -->
            <td>csrrw [I]</td>
            <!-- IF -->
            <td rowspan=6>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td>
                A ← x[rs1]
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- EX -->
            <td>
                C ← A
            </td>
            <!-- MEM -->
            <td rowspan=6></td>
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>csrrs [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
                A ← x[rs1]
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- EX -->
            <td>
                C ← Z | A
            </td>
            <!-- MEM -->
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>csrrc [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
                A ← x[rs1]
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- EX -->
            <td>
                C ← Z &~ A
            </td>
            <!-- MEM -->
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>csrrwi [U]</td>
            <!-- IF -->
            <td>
                Z_imm ← ext(ir[19:15])
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← Z_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>csrrsi [U]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
                Z_imm ← ext(ir[19:15])
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- EX -->
            <td>
                C ← Z | Z_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>csrrci [U]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
                Z_imm ← ir[19:15]
                <br />
                Z ← CSRs[csr]
            </td>
            <!-- EX -->
            <td>
                C ← Z &~ Z_imm
            </td>
            <!-- MEM -->
            <!-- WB -->
            <td>
                x[rd] ← Z
                <br />
                CSRs[csr] ← C
            </td>
        </tr>
        <tr>
            <!-- TODO: what does ecall do? -->
            <!-- instruction -->
            <td>ecall [?]</td>
            <!-- IF -->
            <td>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td>
                RaiseException
                <br />
                PC ← trap_vector_addr
            </td>
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does ebreak do? -->
            <!-- instruction -->
            <td>ebreak [?]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does uret do? -->
            <!-- instruction -->
            <td>uret [?]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does sret do? -->
            <!-- instruction -->
            <td>sret [?]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- Return from Machine-Mode Exception Handler -->
            <!-- instruction -->
            <td>mret [?]</td>
            <!-- IF -->
            <td>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td>
                Z ← CSRs[mpec]
                <br />
                Imm ← (cause == ecall) ? 32'h4 : 32'h0
                <br />
                mstatus.mie ← mstatus.mpie
                <br />
                mstatus.mpie ← 1
            </td>
            <!-- EX -->
            <td>
                C ← Z + Imm
                <br />
                jump ← 1
                <br />
                PC ← C
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does wfi do? -->
            <!-- instruction -->
            <td>wfi [?]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
    </tobdy>
</table>

## Source
https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html
