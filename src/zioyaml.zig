//! YAML parsing utilities for Zig.
//!
//! Line-by-line parsing with key-value extraction, indentation tracking,
//! and basic type inference.

const std = @import("std");

/// YAML value types.
pub const ValueType = enum { string, integer, float, boolean, null_, list, map };

/// Parse a YAML key-value line (e.g., 'name: Alice').
/// Handles quoted strings, null, and inline comments.
pub fn parseKeyValue(line: []const u8) ?struct { key: []const u8, value: []const u8 } {
    const trimmed = std.mem.trim(u8, line, " \t");
    if (trimmed.len == 0 or trimmed[0] == '#') return null;

    const colon_pos = std.mem.indexOfScalar(u8, trimmed, ':') orelse return null;
    const key = std.mem.trim(u8, trimmed[0..colon_pos], " \t\"'");
    var value = std.mem.trimStart(u8, trimmed[colon_pos + 1 ..], " \t");

    // Handle empty value (key with no value or just a comment)
    if (value.len == 0) return .{ .key = key, .value = "" };

    // Strip inline comments
    if (std.mem.indexOfScalar(u8, value, '#')) |comment_pos| {
        value = std.mem.trimEnd(u8, value[0..comment_pos], " \t");
    }

    // Strip quotes
    if (value.len >= 2 and ((value[0] == '"' and value[value.len - 1] == '"') or
        (value[0] == '\'' and value[value.len - 1] == '\'')))
    {
        value = value[1 .. value.len - 1];
    }

    return .{ .key = key, .value = value };
}

/// Count indentation level (number of leading spaces).
pub fn indentLevel(line: []const u8) usize {
    var count: usize = 0;
    for (line) |ch| {
        if (ch == ' ') count += 1
        else if (ch == '\t') count += 2
        else break;
    }
    return count;
}

/// Check if a line is a list item (starts with '- ').
pub fn isListItem(line: []const u8) bool {
    const trimmed = std.mem.trimStart(u8, line, " \t");
    return trimmed.len >= 2 and trimmed[0] == '-' and trimmed[1] == ' ';
}

/// Parse a list item, returning the value after the dash.
pub fn parseListItem(line: []const u8) ?[]const u8 {
    if (!isListItem(line)) return null;
    const trimmed = std.mem.trimStart(u8, line, " \t");
    return std.mem.trim(u8, trimmed[2..], " \t");
}

/// Infer the YAML value type.
pub fn inferType(value: []const u8) ValueType {
    if (value.len == 0 or std.mem.eql(u8, value, "~") or std.mem.eql(u8, value, "null")) return .null_;
    if (std.mem.eql(u8, value, "true") or std.mem.eql(u8, value, "false")) return .boolean;
    if (std.fmt.parseInt(i64, value, 10) catch null) |_| return .integer;
    if (std.fmt.parseFloat(f64, value) catch null) |_| return .float;
    return .string;
}

/// Check if a line is a YAML comment.
pub fn isComment(line: []const u8) bool {
    const trimmed = std.mem.trimStart(u8, line, " \t");
    return trimmed.len > 0 and trimmed[0] == '#';
}

/// Check if a line is a document separator (--- or ...).
pub fn isDocumentSeparator(line: []const u8) bool {
    const trimmed = std.mem.trim(u8, line, " \t");
    return std.mem.eql(u8, trimmed, "---") or std.mem.eql(u8, trimmed, "...");
}

/// Parse a YAML boolean.
pub fn parseBool(value: []const u8) ?bool {
    if (std.mem.eql(u8, value, "true")) return true;
    if (std.mem.eql(u8, value, "false")) return false;
    return null;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

test "parseKeyValue basic" {
    const kv = parseKeyValue("name: Alice").?;
    try std.testing.expectEqualStrings("name", kv.key);
    try std.testing.expectEqualStrings("Alice", kv.value);
}

test "parseKeyValue quoted value" {
    const kv = parseKeyValue("title: \"Hello World\"").?;
    try std.testing.expectEqualStrings("title", kv.key);
    try std.testing.expectEqualStrings("Hello World", kv.value);
}

test "parseKeyValue empty value" {
    const kv = parseKeyValue("key:").?;
    try std.testing.expectEqualStrings("key", kv.key);
    try std.testing.expectEqualStrings("", kv.value);
}

test "parseKeyValue comment" {
    try std.testing.expect(parseKeyValue("# comment") == null);
    try std.testing.expect(parseKeyValue("") == null);
}

test "parseKeyValue inline comment" {
    const kv = parseKeyValue("port: 8080 # HTTP port").?;
    try std.testing.expectEqualStrings("port", kv.key);
    try std.testing.expectEqualStrings("8080", kv.value);
}

test "indentLevel" {
    try std.testing.expectEqual(@as(usize, 0), indentLevel("hello"));
    try std.testing.expectEqual(@as(usize, 2), indentLevel("  hello"));
    try std.testing.expectEqual(@as(usize, 4), indentLevel("    hello"));
    try std.testing.expectEqual(@as(usize, 2), indentLevel("\thello"));
}

test "isListItem" {
    try std.testing.expect(isListItem("- item"));
    try std.testing.expect(!isListItem("not an item"));
    try std.testing.expect(!isListItem("--flag"));
}

test "parseListItem" {
    try std.testing.expectEqualStrings("item", parseListItem("- item").?);
    try std.testing.expectEqualStrings("hello world", parseListItem("  - hello world").?);
}

test "inferType" {
    try std.testing.expectEqual(ValueType.integer, inferType("42"));
    try std.testing.expectEqual(ValueType.float, inferType("3.14"));
    try std.testing.expectEqual(ValueType.boolean, inferType("true"));
    try std.testing.expectEqual(ValueType.null_, inferType("null"));
    try std.testing.expectEqual(ValueType.null_, inferType("~"));
    try std.testing.expectEqual(ValueType.string, inferType("hello"));
}

test "isComment" {
    try std.testing.expect(isComment("# comment"));
    try std.testing.expect(isComment("  # indented comment"));
    try std.testing.expect(!isComment("not a comment"));
}

test "isDocumentSeparator" {
    try std.testing.expect(isDocumentSeparator("---"));
    try std.testing.expect(isDocumentSeparator("..."));
    try std.testing.expect(!isDocumentSeparator("not a separator"));
}

test "parseBool" {
    try std.testing.expectEqual(true, parseBool("true").?);
    try std.testing.expectEqual(false, parseBool("false").?);
    try std.testing.expect(parseBool("yes") == null);
}
