const limine = @import("limine");
const io = @import("io.zig");
const fmt = @import("std").fmt;
const Writer = @import("std").io.Writer;

var module_request: limine.ModuleRequest = .{};
pub export var framebuffer_request: limine.FramebufferRequest = .{};
pub var framebuffer: *const limine.Framebuffer = undefined;

pub var text_cursor_x: u32 = 0;
pub var text_cursor_y: u32 = 0;
var text_cursor_color: u32 = @intFromEnum(Colors.White);

var font: [256][16]u8 = undefined;

const PSF1_HEADER = extern struct {
    magic: u16,
    mode: u8,
    charsize: u8,
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

    if (module_request.response) |mod_resp| {
        const modules = mod_resp.modules();
        if (modules.len > 0) {
            const font_module = modules[0];
            const font_data = font_module.data();

            const header = @as(*const PSF1_HEADER, @ptrCast(@alignCast(font_data.ptr)));
            if (header.magic == 0x0436) {
                const glyph_data = font_data[@sizeOf(PSF1_HEADER)..];
                const charsize = @as(usize, @intCast(header.charsize));

                for (0..256) |char_index| {
                    for (0..charsize) |row| {
                        font[char_index][row] = glyph_data[char_index * charsize + row];
                    }
                }
            }
        } else {
            return;
        }
    }
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
        text_cursor_y += 16;
        text_cursor_x = 0;

        io.outb(0xE9, '\n');

        return;
    }

    io.outb(0xE9, c);

    for (0..16) |i| {
        for (0..8) |j| {
            if (font[c][i] & (@as(u8, 1) << @intCast(7 - j)) != 0) {
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
