# Instruction Execution Table

## Execution Phase
1. IF: Instruction Fetch
2. ID: Instruction Decode
3. EX: Execution
4. MEM: Memory Access
5. WB: Writeback

## Instruction Execution Table

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
            <td rowspan=36>
                IR ← mem[PC]
                <br />
                PC ← PC + 4
            </td>
            <!-- ID -->
            <td></td>
            <!-- EX -->
            <td>
                U_imm ← sext(IR[31:12] << 12) <!-- sext: sign-extend-->
                <br />
                C ← U_imm
            </td>
            <!-- MEM -->
            <td rowspan=2></td>
            <!-- WB -->
            <td>
                rd ← IR[11:7]
                <br />
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>auipc [U]</td>
            <!-- IF -->
            <!-- ID -->
            <td></td>
            <!-- EX -->
            <td>
                U_imm ← sext(IR[31:12] << 12)
                <br />
                C ← PC + U_imm
            </td>           
            <!-- MEM -->
            <!-- WB -->
            <td>
                rd ← IR[11:7]
                <br />
                x[rd] ← C
            </td>           
        </tr>
        <tr>
            <!-- instruction -->
            <td>addi [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=9>
                rs1 ← IR[19:15]
                <br />
                A ← x[rs1]
            </td>
            <!-- EX -->
            <td>
                I_imm ← sext(IR[31:20])
                <br />
                C ← A + I_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                rd ← IR[11:7]
                <br />
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>slti [I]</td>   
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td rowspan=2>
                I_imm ← sext(IR[31:20])
                <br />
                C ← A - I_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                rd ← IR[11:7]
                <br />
                x[rd] ← (C < 0) ... signed
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sltiu [I]</td>  
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                rd ← IR[11:7]
                <br />
                x[rd] ← (C < 0) ... unsigned
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>xori [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                I_imm ← sext(IR[31:20])
                <br />
                C ← A ^ I_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td rowspan=9>
                rd ← IR[11:7]
                <br />
                x[rd] ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>ori [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                I_imm ← sext(IR[31:20])
                <br />
                C ← A | I_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>addi [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                I_imm ← sext(IR[31:20])
                <br />
                C ← A & I_imm
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>slli [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                shamt ← IR[24:20]
                <br />
                C ← A << shamt
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>srli [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                shamt ← IR[24:20]
                <br />
                C ← A >>u shamt ... unsigned shift
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>srai [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                shamt ← IR[24:20]
                <br />
                C ← A >>s shamt ... signed shift
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- instruction -->
            <td>add [R]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=9>
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
                C ← A - B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                x[rd] ← (C < 0) ... signed
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sltu [R]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td>
                C ← A - B
            </td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
            <td>
                x[rd] ← (C < 0) ... unsigned
            </td>
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
            <td rowspan=3>
                x[rd] ← C
            </td>
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
            <td>lb [I]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=5>
                A ← x[rs1]
                <br />
                B ← sext(IR[31:20])
            </td>
            <!-- EX -->
            <td rowspan=5>
                C ← A + B
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
        <tr>
            <!-- instruction -->
            <td>sb [S]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=3>
                A ← x[rs1]
                <br />
                B ← x[rs2]
            </td>
            <!-- EX -->
            <td rowspan=3>
                C ← A + sext({ IR[31:25], IR[11:7] })
            </td>
            <!-- MEM -->
            <td rowspan=3></td>
            <!-- WB -->
            <td>
                M[C] ← B[7:0]
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sh [S]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                M[C] ← B[15:0]
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>sw [S]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                M[C] ← B[31:0]
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>jal [J]</td>
            <!-- IF -->
            <!-- ID -->
            <td>
            </td>
            <!-- EX -->
            <td>
                J_imm ← sext({ IR[31], IR[19:12], IR[27], IR[30:28], 0 })
                <br />
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
            </td>
            <!-- EX -->
            <td>
                I_imm ← sext(IR[31:27])
                <br />
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
        <tr>
            <!-- instruction -->
            <td>beq [B]</td>
            <!-- IF -->
            <!-- ID -->
            <td rowspan=6>
                A ← x[rs1]
                <br />
                B ← x[rs2]
            </td>
            <!-- EX -->
            <td rowspan=6>
                B_imm ← sext({ IR[31], IR[7], IR[30:25], IR[11:8], 0 })
                <br />
                C ← PC + B_imm
            </td>
            <!-- MEM -->
            <td rowspan=6></td>
            <!-- WB -->
            <td>
                if (A == B) PC ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>bne [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                if (A != B) PC ← C
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>blt [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                if (A < B) PC ← C ... signed
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>bge [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                if (A >= B) PC ← C ... signed
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>bltu [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                if (A < B) PC ← C ... unsigned
            </td>
        </tr>
        <tr>
            <!-- instruction -->
            <td>bgeu [B]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <!-- MEM -->
            <!-- WB -->
            <td>
                if (A >= B) PC ← C ... unsigned
            </td>
        </tr>
    </tbody>
</table>

## Instruction Execution Table (Extra?)
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
            <!-- TODO: what does fence do? -->
            <!-- instruction -->
            <td>fence []</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does fence.i do? -->
            <!-- instruction -->
            <td>fence.i []</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrw do? -->
            <!-- instruction -->
            <td>csrrw [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrs do? -->
            <!-- instruction -->
            <td>csrrs [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrc do? -->
            <!-- instruction -->
            <td>csrrc [I]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrwi do? -->
            <!-- instruction -->
            <td>csrrwi [U]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrsi do? -->
            <!-- instruction -->
            <td>csrrsi [U]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does csrrci do? -->
            <!-- instruction -->
            <td>csrrci [U]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
            <!-- MEM -->
            <td></td>
            <!-- WB -->
        </tr>
        <tr>
            <!-- TODO: what does ecall do? -->
            <!-- instruction -->
            <td>ecall [?]</td>
            <!-- IF -->
            <!-- ID -->
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
            <!-- TODO: what does mret do? -->
            <!-- instruction -->
            <td>mret [?]</td>
            <!-- IF -->
            <!-- ID -->
            <!-- EX -->
            <td></td>
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
        <tr>
            <!-- TODO: what does sfence.vma do? -->
            <!-- instruction -->
            <td>sfence.vma [?]</td>
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

<style>
table {
    border: 1px solid black;
    border-collapse: collapse;
}

th, td {
    border: 1px solid black;
    padding: 0.5rem;
}
</style>