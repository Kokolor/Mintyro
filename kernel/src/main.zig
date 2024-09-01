const limine = @import("limine");
const framebuffer = @import("framebuffer.zig");
const gdt = @import("gdt.zig");
const idt = @import("idt.zig");

pub export var base_revision: limine.BaseRevision = .{ .revision = 2 };

export fn _start() callconv(.C) noreturn {
    framebuffer.initialize();
    framebuffer.write_formatted("Initializing GDT... ", .{});
    gdt.initialize();
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("OK\n\n", .{});

    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Yellow));
    framebuffer.write_formatted("GDT Segments:\n", .{});

    framebuffer.write_formatted("\t\tNull        Segment:\t\t0x{x}\n", .{gdt.gdt_entries.null});
    framebuffer.write_formatted("\t\tKernel Code Segment:\t\t0x{x}\n", .{gdt.gdt_entries.kernel_code});
    framebuffer.write_formatted("\t\tKernel Data Segment:\t\t0x{x}\n", .{gdt.gdt_entries.kernel_data});
    framebuffer.write_formatted("\t\tUser   Code Segment:\t\t0x{x}\n", .{gdt.gdt_entries.user_code});
    framebuffer.write_formatted("\t\tUser   Data Segment:\t\t0x{x}\n\n", .{gdt.gdt_entries.user_data});

    framebuffer.set_color(@intFromEnum(framebuffer.Colors.White));

    framebuffer.write_formatted("Initializing IDT... ", .{});
    idt.initialize();
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("OK\n\n", .{});

    framebuffer.set_color(@intFromEnum(framebuffer.Colors.White));

    framebuffer.write_formatted("Welcome to ", .{});
    framebuffer.set_color(@intFromEnum(framebuffer.Colors.Green));
    framebuffer.write_formatted("Mintyro!\n\n", .{});

    while (true) {
        asm volatile ("hlt");
    }
}
