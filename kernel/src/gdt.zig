const std = @import("std");

extern fn gdt_load(gdtr: usize) callconv(.C) void;

const Gdtr = packed struct {
    size: u16,
    offset: usize,
};

pub var gdt_entries: packed struct {
    null: u64 = 0x0000000000000000,
    kernel_code: u64 = 0x00af9b000000ffff,
    kernel_data: u64 = 0x00af93000000ffff,
    user_code: u64 = 0x00affb000000ffff,
    user_data: u64 = 0x00aff3000000ffff,
} = .{};

pub fn initialize() void {
    const gdtr = Gdtr{
        .size = @sizeOf(@TypeOf(gdt_entries)) - 1,
        .offset = @intFromPtr(&gdt_entries),
    };

    gdt_load(@intFromPtr(&gdtr));
}
