const std = @import("std");
const framebuffer = @import("framebuffer.zig");
const io = @import("io.zig");

const IdtEntry = packed struct {
    offset_low: u16,
    selector: u16,
    ist: u8,
    type_attributes: u8,
    offset_middle: u16,
    offset_high: u32,
    zero: u32,
};

const Idtr = packed struct {
    size: u16,
    offset: u64,
};

pub fn initialize() void {
    pic_remap();

    var idt_entries = [_]IdtEntry{set_entry(0, 0, 0)} ** 256;

    idt_entries[0] = set_entry(@intFromPtr(&isr0), 0x08, 0x8e);
    idt_entries[1] = set_entry(@intFromPtr(&isr1), 0x08, 0x8e);
    idt_entries[2] = set_entry(@intFromPtr(&isr2), 0x08, 0x8e);
    idt_entries[3] = set_entry(@intFromPtr(&isr3), 0x08, 0x8e);
    idt_entries[4] = set_entry(@intFromPtr(&isr4), 0x08, 0x8e);
    idt_entries[5] = set_entry(@intFromPtr(&isr5), 0x08, 0x8e);
    idt_entries[6] = set_entry(@intFromPtr(&isr6), 0x08, 0x8e);
    idt_entries[7] = set_entry(@intFromPtr(&isr7), 0x08, 0x8e);
    idt_entries[8] = set_entry(@intFromPtr(&isr8), 0x08, 0x8e);
    idt_entries[9] = set_entry(@intFromPtr(&isr9), 0x08, 0x8e);
    idt_entries[10] = set_entry(@intFromPtr(&isr10), 0x08, 0x8e);
    idt_entries[11] = set_entry(@intFromPtr(&isr11), 0x08, 0x8e);
    idt_entries[12] = set_entry(@intFromPtr(&isr12), 0x08, 0x8e);
    idt_entries[13] = set_entry(@intFromPtr(&isr13), 0x08, 0x8e);
    idt_entries[14] = set_entry(@intFromPtr(&isr14), 0x08, 0x8e);
    idt_entries[15] = set_entry(@intFromPtr(&isr15), 0x08, 0x8e);
    idt_entries[16] = set_entry(@intFromPtr(&isr16), 0x08, 0x8e);
    idt_entries[17] = set_entry(@intFromPtr(&isr17), 0x08, 0x8e);
    idt_entries[18] = set_entry(@intFromPtr(&isr18), 0x08, 0x8e);
    idt_entries[19] = set_entry(@intFromPtr(&isr19), 0x08, 0x8e);
    idt_entries[20] = set_entry(@intFromPtr(&isr20), 0x08, 0x8e);
    idt_entries[21] = set_entry(@intFromPtr(&isr21), 0x08, 0x8e);
    idt_entries[22] = set_entry(@intFromPtr(&isr22), 0x08, 0x8e);
    idt_entries[23] = set_entry(@intFromPtr(&isr23), 0x08, 0x8e);
    idt_entries[24] = set_entry(@intFromPtr(&isr24), 0x08, 0x8e);
    idt_entries[25] = set_entry(@intFromPtr(&isr25), 0x08, 0x8e);
    idt_entries[26] = set_entry(@intFromPtr(&isr26), 0x08, 0x8e);
    idt_entries[27] = set_entry(@intFromPtr(&isr27), 0x08, 0x8e);
    idt_entries[28] = set_entry(@intFromPtr(&isr28), 0x08, 0x8e);
    idt_entries[29] = set_entry(@intFromPtr(&isr29), 0x08, 0x8e);
    idt_entries[30] = set_entry(@intFromPtr(&isr30), 0x08, 0x8e);
    idt_entries[31] = set_entry(@intFromPtr(&isr31), 0x08, 0x8e);

    const idtr = Idtr{
        .size = @sizeOf(IdtEntry) * 256 - 1,
        .offset = @intFromPtr(&idt_entries),
    };

    asm volatile ("lidt (%[value])"
        :
        : [value] "r" (&idtr),
    );

    asm volatile ("sti");
}

fn set_entry(address: u64, selector: u16, type_attributes: u8) IdtEntry {
    return IdtEntry{
        .offset_low = @truncate(address),
        .selector = selector,
        .ist = 0,
        .type_attributes = type_attributes,
        .offset_middle = @truncate(address >> 16),
        .offset_high = @truncate(address >> 32),
        .zero = 0,
    };
}

pub export fn isr_handler(interrupt_number: u64) callconv(.C) void {
    switch (interrupt_number) {
        0 => panic("Division by Zero"),
        1 => panic("Debug Exception"),
        2 => panic("Non-maskable Interrupt"),
        3 => panic("Breakpoint"),
        4 => panic("Overflow"),
        5 => panic("Bound Range Exceeded"),
        6 => panic("Invalid Opcode"),
        7 => panic("Device Not Available"),
        8 => panic("Double Fault"),
        9 => panic("Coprocessor Segment Overrun"),
        10 => panic("Invalid TSS"),
        11 => panic("Segment Not Present"),
        12 => panic("Stack-Segment Fault"),
        13 => panic("General Protection Fault"),
        14 => panic("Page Fault"),
        15 => panic("Reserved"),
        16 => panic("x87 Floating-Point Exception"),
        17 => panic("Alignment Check"),
        18 => panic("Machine Check"),
        19 => panic("SIMD Floating-Point Exception"),
        20 => panic("Virtualization Exception"),

        else => {
            framebuffer.write_formatted("Unknown Interrupt: {}\n", .{interrupt_number});
        },
    }
}

pub fn panic(msg: []const u8) void {
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.White));
    framebuffer.write_rectangle(0, framebuffer.text_cursor_y, @intCast(framebuffer.framebuffer.width), 8, @intFromEnum(framebuffer.Colors.Red));
    framebuffer.write_formatted("Fatal Error: {s}\n", .{msg});

    while (true) {
        asm volatile ("cli; hlt");
    }
}

extern fn pic_remap() void;
extern fn isr0() void;
extern fn isr1() void;
extern fn isr2() void;
extern fn isr3() void;
extern fn isr4() void;
extern fn isr5() void;
extern fn isr6() void;
extern fn isr7() void;
extern fn isr8() void;
extern fn isr9() void;
extern fn isr10() void;
extern fn isr11() void;
extern fn isr12() void;
extern fn isr13() void;
extern fn isr14() void;
extern fn isr15() void;
extern fn isr16() void;
extern fn isr17() void;
extern fn isr18() void;
extern fn isr19() void;
extern fn isr20() void;
extern fn isr21() void;
extern fn isr22() void;
extern fn isr23() void;
extern fn isr24() void;
extern fn isr25() void;
extern fn isr26() void;
extern fn isr27() void;
extern fn isr28() void;
extern fn isr29() void;
extern fn isr30() void;
extern fn isr31() void;
