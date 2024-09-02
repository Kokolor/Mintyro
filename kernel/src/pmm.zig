const limine = @import("limine");
const framebuffer = @import("framebuffer.zig");
const idt = @import("idt.zig");

const PAGE_SIZE = 4096;

pub export var memory_map_request: limine.MemoryMapRequest = .{};
pub export var hhdm_request: limine.HhdmRequest = .{};

var entries: []*const limine.MemoryMapEntry = undefined;
var bitmap: []bool = undefined;
var page_count: usize = 0;

pub fn initialize() void {
    const hhdm_offset: u64 = hhdm_request.response.?.offset;
    entries = memory_map_request.response.?.entries();

    for (entries) |entry| {
        if (entry.kind == limine.MemoryMapEntryType.usable) {
            framebuffer.write_formatted("Found usable entry at: 0x{x}, type: {}\n", .{ entry.base, entry.kind });
            page_count += entry.length / PAGE_SIZE;
        }
    }

    const bitmap_size = page_count / 8;

    var allocated = false;
    for (entries) |entry| {
        if (entry.kind == limine.MemoryMapEntryType.usable and entry.length >= bitmap_size) {
            const bitmap_start_ptr: [*]bool = @ptrFromInt(hhdm_offset + entry.base);
            bitmap = bitmap_start_ptr[0..page_count];
            allocated = true;

            break;
        }
    }

    if (!allocated) {
        idt.panic("PMM: Not enough memory to allocate bitmap\n");
    }

    for (0..page_count) |i| {
        const page_address = i * PAGE_SIZE;

        for (entries) |entry| {
            if (entry.kind != .usable and page_address >= entry.base and page_address <= entry.base + entry.length) {
                bitmap[i] = true;
                break;
            }
        }
    }
}

pub fn allocate_page() ?u64 {
    for (1..page_count) |i| {
        if (!bitmap[i]) {
            bitmap[i] = true;
            return i * PAGE_SIZE;
        }
    }

    return null;
}

pub fn free_page(page_address: u64) void {
    const page_index = page_address / PAGE_SIZE;

    if (page_index >= page_count) {
        idt.panic("PMM: Attempted to free an invalid page address\n");
    }

    bitmap[page_index] = false;
}
