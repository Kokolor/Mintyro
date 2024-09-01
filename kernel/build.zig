const std = @import("std");

pub fn build(b: *std.Build) void {
    const arch = .x86_64;

    const code_model: std.builtin.CodeModel = .kernel;
    const linker_script_path = b.path("linker.ld");

    var target_query: std.Target.Query = .{
        .cpu_arch = arch,
        .os_tag = .freestanding,
        .abi = .none,
    };

    const Feature = std.Target.x86.Feature;

    target_query.cpu_features_add.addFeature(@intFromEnum(Feature.soft_float));
    target_query.cpu_features_sub.addFeature(@intFromEnum(Feature.mmx));
    target_query.cpu_features_sub.addFeature(@intFromEnum(Feature.sse));
    target_query.cpu_features_sub.addFeature(@intFromEnum(Feature.sse2));
    target_query.cpu_features_sub.addFeature(@intFromEnum(Feature.avx));
    target_query.cpu_features_sub.addFeature(@intFromEnum(Feature.avx2));

    const target = b.resolveTargetQuery(target_query);
    const optimize = b.standardOptimizeOption(.{});
    const limine = b.dependency("limine", .{});

    const kernel = b.addExecutable(.{
        .name = "kernel",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .code_model = code_model,
    });

    kernel.want_lto = false;
    kernel.root_module.addImport("limine", limine.module("limine"));
    kernel.addAssemblyFile(b.path("src/gdt.s"));
    kernel.addAssemblyFile(b.path("src/idt.s"));
    kernel.setLinkerScriptPath(linker_script_path);
    b.installArtifact(kernel);
}
