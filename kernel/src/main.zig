const limine = @import("limine");
const framebuffer = @import("framebuffer.zig");
const gdt = @import("gdt.zig");
const idt = @import("idt.zig");
const pmm = @import("pmm.zig");

pub export var base_revision: limine.BaseRevision = .{ .revision = 2 };

export fn _start() callconv(.C) noreturn {
    framebuffer.initialize();

    gdt.initialize();
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("GDT Initialized.\n", .{});
    idt.initialize();
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("IDT Initialized.\n", .{});
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.White));
    pmm.initialize();
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("PMM Initialized.\n", .{});

    framebuffer.set_color(@intFromEnum(framebuffer.Colors.White));
    framebuffer.write_formatted("\nWelcome to ", .{});
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("Mintyro!\n", .{});

    while (true) {
        asm volatile ("hlt");
    }
}
