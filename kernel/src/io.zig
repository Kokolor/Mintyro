const std = @import("std");

pub fn inb(port: u16) u8 {
    return asm volatile (
        \\inb %[port], %[ret]
        : [ret] "={al}" (-> u8),
        : [port] "N{dx}" (port),
        : "memory"
    );
}

pub fn outb(port: u16, val: u8) void {
    asm volatile (
        \\outb %[val], %[port]
        :
        : [val] "{al}" (val),
          [port] "N{dx}" (port),
        : "memory"
    );
}
