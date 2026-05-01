const std = @import("std");
const zioyaml = @import("zioyaml");

pub fn main() !void {
    std.debug.print("=== zioyaml example ===\n\n", .{});

    const lines = [_][]const u8{
        "name: Alice",
        "age: 30",
        "active: true",
        "score: 95.5",
        "address: null",
        "# comment",
        "- item one",
        "---",
    };

    std.debug.print("Parsing YAML lines:\n", .{});
    for (lines) |line| {
        const indent = zioyaml.indentLevel(line);
        if (zioyaml.isComment(line)) {
            std.debug.print("  COMMENT\n", .{});
        } else if (zioyaml.isDocumentSeparator(line)) {
            std.debug.print("  DOC SEPARATOR\n", .{});
        } else if (zioyaml.isListItem(line)) {
            std.debug.print("  LIST: {s}\n", .{zioyaml.parseListItem(line).?});
        } else if (zioyaml.parseKeyValue(line)) |kv| {
            const vtype = zioyaml.inferType(kv.value);
            std.debug.print("  {s}: {s} ({s}, indent={d})\n", .{ kv.key, kv.value, @tagName(vtype), indent });
        }
    }
}
