.global gdt_load

.section .text

gdt_load:
	lgdt (%rdi)

	push $0x8
	movabs $reload_segments, %rax
	push %rax
	lretq
reload_segments:
	mov $0x10, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss

	ret

