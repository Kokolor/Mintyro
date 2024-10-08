.global isr0, isr1, isr2, isr3, isr4, isr5, isr6, isr7, isr8, isr9, isr10, isr11, isr12, isr13, isr14, isr15, isr16, isr17, isr18, isr19, isr20, isr21, isr22, isr23, isr24, isr25, isr26, isr27, isr28, isr29, isr30, isr31, isr33
.extern isr_handler

.section .text
.align 8

isr0:
    movq $0, %rdi
    jmp isr_handler
    iretq

isr1:
    movq $1, %rdi
    jmp isr_handler
    iretq

isr2:
    movq $2, %rdi
    jmp isr_handler
    iretq

isr3:
    movq $3, %rdi
    jmp isr_handler
    iretq

isr4:
    movq $4, %rdi
    jmp isr_handler
    iretq

isr5:
    movq $5, %rdi
    jmp isr_handler
    iretq

isr6:
    movq $6, %rdi
    jmp isr_handler
    iretq

isr7:
    movq $7, %rdi
    jmp isr_handler
    iretq

isr8:
    movq $8, %rdi
    jmp isr_handler
    iretq

isr9:
    movq $9, %rdi
    jmp isr_handler
    iretq

isr10:
    movq $10, %rdi
    jmp isr_handler
    iretq


isr11:
    movq $11, %rdi
    jmp isr_handler
    iretq


isr12:
    movq $12, %rdi
    jmp isr_handler
    iretq


isr13:
    movq $13, %rdi
    jmp isr_handler
    iretq

isr14:
    movq $14, %rdi
    jmp isr_handler
    iretq

isr15:
    movq $15, %rdi
    jmp isr_handler
    iretq

isr16:
    movq $16, %rdi
    jmp isr_handler
    iretq

isr17:
    movq $17, %rdi
    jmp isr_handler
    iretq

isr18:
    movq $18, %rdi
    jmp isr_handler
    iretq

isr19:
    movq $19, %rdi
    jmp isr_handler
    iretq

isr20:
    movq $20, %rdi
    jmp isr_handler
    iretq

isr21:
    movq $21, %rdi
    jmp isr_handler
    iretq

isr22:
    movq $22, %rdi
    jmp isr_handler
    iretq

isr23:
    movq $23, %rdi
    jmp isr_handler
    iretq

isr24:
    movq $24, %rdi
    jmp isr_handler
    iretq

isr25:
    movq $25, %rdi
    jmp isr_handler
    iretq

isr26:
    movq $26, %rdi
    jmp isr_handler
    iretq

isr27:
    movq $27, %rdi
    jmp isr_handler
    iretq

isr28:
    movq $28, %rdi
    jmp isr_handler
    iretq

isr29:
    movq $29, %rdi
    jmp isr_handler
    iretq

isr30:
    movq $30, %rdi
    jmp isr_handler
    iretq

isr31:
    movq $31, %rdi
    jmp isr_handler
    iretq

isr33:
    movq $33, %rdi
    call isr_handler
    iretq

.global pic_remap

pic_remap:
    movb $0x11, %al
    outb %al, $0x20
    outb %al, $0xA0

    movb $0x20, %al
    outb %al, $0x21
    movb $0x28, %al
    outb %al, $0xA1

    movb $0x04, %al
    outb %al, $0x21
    movb $0x02, %al
    outb %al, $0xA1

    movb $0x01, %al
    outb %al, $0x21
    outb %al, $0xA1

    movb $0xFF, %al
    outb %al, $0x21
    outb %al, $0xA1
    ret
