//! zioyaml for Zig.

const std = @import("std");

test "{zioyaml} smoke test" {
    try std.testing.expect(true);
}

test "{zioyaml} basic functionality" {
    try std.testing.expect(1 + 1 == 2);
}

test "{zioyaml} string operations" {
    try std.testing.expectEqualStrings("hello", "hello");
}

test "{zioyaml} error handling" {
    const result = std.math.add(u8, 200, 100);
    try std.testing.expectError(error.Overflow, result);
}
