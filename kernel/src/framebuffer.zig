const limine = @import("limine");
const io = @import("io.zig");
const fmt = @import("std").fmt;
const Writer = @import("std").io.Writer;

pub export var framebuffer_request: limine.FramebufferRequest = .{};
pub var framebuffer: *const limine.Framebuffer = undefined;

pub var text_cursor_x: u32 = 0;
pub var text_cursor_y: u32 = 0;
var text_cursor_color: u32 = @intFromEnum(Colors.White);

pub export var font: [128][8]u8 = [128][8]u8{
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        24,
        60,
        60,
        24,
        24,
        0,
        24,
        0,
    },
    [8]u8{
        54,
        54,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        54,
        54,
        127,
        54,
        127,
        54,
        54,
        0,
    },
    [8]u8{
        12,
        62,
        3,
        30,
        48,
        31,
        12,
        0,
    },
    [8]u8{
        0,
        99,
        51,
        24,
        12,
        102,
        99,
        0,
    },
    [8]u8{
        28,
        54,
        28,
        110,
        59,
        51,
        110,
        0,
    },
    [8]u8{
        6,
        6,
        3,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        24,
        12,
        6,
        6,
        6,
        12,
        24,
        0,
    },
    [8]u8{
        6,
        12,
        24,
        24,
        24,
        12,
        6,
        0,
    },
    [8]u8{
        0,
        102,
        60,
        255,
        60,
        102,
        0,
        0,
    },
    [8]u8{
        0,
        12,
        12,
        63,
        12,
        12,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        12,
        12,
        6,
    },
    [8]u8{
        0,
        0,
        0,
        63,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        12,
        12,
        0,
    },
    [8]u8{
        96,
        48,
        24,
        12,
        6,
        3,
        1,
        0,
    },
    [8]u8{
        62,
        99,
        115,
        123,
        111,
        103,
        62,
        0,
    },
    [8]u8{
        12,
        14,
        12,
        12,
        12,
        12,
        63,
        0,
    },
    [8]u8{
        30,
        51,
        48,
        28,
        6,
        51,
        63,
        0,
    },
    [8]u8{
        30,
        51,
        48,
        28,
        48,
        51,
        30,
        0,
    },
    [8]u8{
        56,
        60,
        54,
        51,
        127,
        48,
        120,
        0,
    },
    [8]u8{
        63,
        3,
        31,
        48,
        48,
        51,
        30,
        0,
    },
    [8]u8{
        28,
        6,
        3,
        31,
        51,
        51,
        30,
        0,
    },
    [8]u8{
        63,
        51,
        48,
        24,
        12,
        12,
        12,
        0,
    },
    [8]u8{
        30,
        51,
        51,
        30,
        51,
        51,
        30,
        0,
    },
    [8]u8{
        30,
        51,
        51,
        62,
        48,
        24,
        14,
        0,
    },
    [8]u8{
        0,
        12,
        12,
        0,
        0,
        12,
        12,
        0,
    },
    [8]u8{
        0,
        12,
        12,
        0,
        0,
        12,
        12,
        6,
    },
    [8]u8{
        24,
        12,
        6,
        3,
        6,
        12,
        24,
        0,
    },
    [8]u8{
        0,
        0,
        63,
        0,
        0,
        63,
        0,
        0,
    },
    [8]u8{
        6,
        12,
        24,
        48,
        24,
        12,
        6,
        0,
    },
    [8]u8{
        30,
        51,
        48,
        24,
        12,
        0,
        12,
        0,
    },
    [8]u8{
        62,
        99,
        123,
        123,
        123,
        3,
        30,
        0,
    },
    [8]u8{
        12,
        30,
        51,
        51,
        63,
        51,
        51,
        0,
    },
    [8]u8{
        63,
        102,
        102,
        62,
        102,
        102,
        63,
        0,
    },
    [8]u8{
        60,
        102,
        3,
        3,
        3,
        102,
        60,
        0,
    },
    [8]u8{
        31,
        54,
        102,
        102,
        102,
        54,
        31,
        0,
    },
    [8]u8{
        127,
        70,
        22,
        30,
        22,
        70,
        127,
        0,
    },
    [8]u8{
        127,
        70,
        22,
        30,
        22,
        6,
        15,
        0,
    },
    [8]u8{
        60,
        102,
        3,
        3,
        115,
        102,
        124,
        0,
    },
    [8]u8{
        51,
        51,
        51,
        63,
        51,
        51,
        51,
        0,
    },
    [8]u8{
        30,
        12,
        12,
        12,
        12,
        12,
        30,
        0,
    },
    [8]u8{
        120,
        48,
        48,
        48,
        51,
        51,
        30,
        0,
    },
    [8]u8{
        103,
        102,
        54,
        30,
        54,
        102,
        103,
        0,
    },
    [8]u8{
        15,
        6,
        6,
        6,
        70,
        102,
        127,
        0,
    },
    [8]u8{
        99,
        119,
        127,
        127,
        107,
        99,
        99,
        0,
    },
    [8]u8{
        99,
        103,
        111,
        123,
        115,
        99,
        99,
        0,
    },
    [8]u8{
        28,
        54,
        99,
        99,
        99,
        54,
        28,
        0,
    },
    [8]u8{
        63,
        102,
        102,
        62,
        6,
        6,
        15,
        0,
    },
    [8]u8{
        30,
        51,
        51,
        51,
        59,
        30,
        56,
        0,
    },
    [8]u8{
        63,
        102,
        102,
        62,
        54,
        102,
        103,
        0,
    },
    [8]u8{
        30,
        51,
        7,
        14,
        56,
        51,
        30,
        0,
    },
    [8]u8{
        63,
        45,
        12,
        12,
        12,
        12,
        30,
        0,
    },
    [8]u8{
        51,
        51,
        51,
        51,
        51,
        51,
        63,
        0,
    },
    [8]u8{
        51,
        51,
        51,
        51,
        51,
        30,
        12,
        0,
    },
    [8]u8{
        99,
        99,
        99,
        107,
        127,
        119,
        99,
        0,
    },
    [8]u8{
        99,
        99,
        54,
        28,
        28,
        54,
        99,
        0,
    },
    [8]u8{
        51,
        51,
        51,
        30,
        12,
        12,
        30,
        0,
    },
    [8]u8{
        127,
        99,
        49,
        24,
        76,
        102,
        127,
        0,
    },
    [8]u8{
        30,
        6,
        6,
        6,
        6,
        6,
        30,
        0,
    },
    [8]u8{
        3,
        6,
        12,
        24,
        48,
        96,
        64,
        0,
    },
    [8]u8{
        30,
        24,
        24,
        24,
        24,
        24,
        30,
        0,
    },
    [8]u8{
        8,
        28,
        54,
        99,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        255,
    },
    [8]u8{
        12,
        12,
        24,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        30,
        48,
        62,
        51,
        110,
        0,
    },
    [8]u8{
        7,
        6,
        6,
        62,
        102,
        102,
        59,
        0,
    },
    [8]u8{
        0,
        0,
        30,
        51,
        3,
        51,
        30,
        0,
    },
    [8]u8{
        56,
        48,
        48,
        62,
        51,
        51,
        110,
        0,
    },
    [8]u8{
        0,
        0,
        30,
        51,
        63,
        3,
        30,
        0,
    },
    [8]u8{
        28,
        54,
        6,
        15,
        6,
        6,
        15,
        0,
    },
    [8]u8{
        0,
        0,
        110,
        51,
        51,
        62,
        48,
        31,
    },
    [8]u8{
        7,
        6,
        54,
        110,
        102,
        102,
        103,
        0,
    },
    [8]u8{
        12,
        0,
        14,
        12,
        12,
        12,
        30,
        0,
    },
    [8]u8{
        48,
        0,
        48,
        48,
        48,
        51,
        51,
        30,
    },
    [8]u8{
        7,
        6,
        102,
        54,
        30,
        54,
        103,
        0,
    },
    [8]u8{
        14,
        12,
        12,
        12,
        12,
        12,
        30,
        0,
    },
    [8]u8{
        0,
        0,
        51,
        127,
        127,
        107,
        99,
        0,
    },
    [8]u8{
        0,
        0,
        31,
        51,
        51,
        51,
        51,
        0,
    },
    [8]u8{
        0,
        0,
        30,
        51,
        51,
        51,
        30,
        0,
    },
    [8]u8{
        0,
        0,
        59,
        102,
        102,
        62,
        6,
        15,
    },
    [8]u8{
        0,
        0,
        110,
        51,
        51,
        62,
        48,
        120,
    },
    [8]u8{
        0,
        0,
        59,
        110,
        102,
        6,
        15,
        0,
    },
    [8]u8{
        0,
        0,
        62,
        3,
        30,
        48,
        31,
        0,
    },
    [8]u8{
        8,
        12,
        62,
        12,
        12,
        44,
        24,
        0,
    },
    [8]u8{
        0,
        0,
        51,
        51,
        51,
        51,
        110,
        0,
    },
    [8]u8{
        0,
        0,
        51,
        51,
        51,
        30,
        12,
        0,
    },
    [8]u8{
        0,
        0,
        99,
        107,
        127,
        127,
        54,
        0,
    },
    [8]u8{
        0,
        0,
        99,
        54,
        28,
        54,
        99,
        0,
    },
    [8]u8{
        0,
        0,
        51,
        51,
        51,
        62,
        48,
        31,
    },
    [8]u8{
        0,
        0,
        63,
        25,
        12,
        38,
        63,
        0,
    },
    [8]u8{
        56,
        12,
        12,
        7,
        12,
        12,
        56,
        0,
    },
    [8]u8{
        24,
        24,
        24,
        0,
        24,
        24,
        24,
        0,
    },
    [8]u8{
        7,
        12,
        12,
        56,
        12,
        12,
        7,
        0,
    },
    [8]u8{
        110,
        59,
        0,
        0,
        0,
        0,
        0,
        0,
    },
    [8]u8{
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    },
};

pub const Colors = enum(u32) {
    Black = 0x001F1F,
    Blue = 0x003F4F,
    Green = 0x3EB489,
    Cyan = 0x3FB4AF,
    Red = 0x7F0000,
    Magenta = 0x7F3F6F,
    Brown = 0x5F4F3F,
    LightGray = 0xBFBFBF,
    DarkGray = 0x5F5F5F,
    LightBlue = 0x4FCFCF,
    LightGreen = 0x90EE90,
    LightCyan = 0xAFEEEE,
    LightRed = 0xFF7F7F,
    LightMagenta = 0xFF77FF,
    Yellow = 0xEECF90,
    White = 0xFFFFFF,
};

pub fn initialize() void {
    const framebuffer_response = framebuffer_request.response orelse unreachable;
    framebuffer = framebuffer_response.framebuffers()[0];
    text_cursor_x = 0;
    text_cursor_y = 0;
}

pub fn write_pixel(x: u32, y: u32, color: u32) void {
    const pixel_offset = y * framebuffer.pitch + x * 4;
    @as(*u32, @ptrCast(@alignCast(framebuffer.address + pixel_offset))).* = color;
}

pub fn write_rectangle(x: u32, y: u32, w: u32, h: u32, color: u32) void {
    for (x..x + w) |i| {
        for (y..y + h) |j| {
            write_pixel(@intCast(i), @intCast(j), color);
        }
    }
}

pub fn set_color(color: u32) void {
    text_cursor_color = color;
}

pub fn write_character(c: u8) void {
    if (c == '\n') {
        text_cursor_y += 8;
        text_cursor_x = 0;

        io.outb(0xE9, '\n');

        return;
    }

    io.outb(0xE9, c);

    for (0..8) |i| {
        for (0..8) |j| {
            if (font[c][i] & (@as(u8, 1) << @intCast(j)) != 0) {
                write_pixel(@intCast(text_cursor_x + j), @intCast(text_cursor_y + i), text_cursor_color);
            }
        }
    }

    text_cursor_x += 8;
}

pub fn write_string(str: []const u8) void {
    for (0..str.len) |i| {
        write_character(str[i]);
    }
}

pub const writer = Writer(void, error{}, callback){ .context = {} };

fn callback(_: void, str: []const u8) error{}!usize {
    write_string(str);
    return str.len;
}

pub fn write_formatted(comptime format: []const u8, args: anytype) void {
    fmt.format(writer, format, args) catch unreachable;
}
