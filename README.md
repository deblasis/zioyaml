# zioyaml

YAML parser for Zig

YAML parser for Zig. Full YAML 1.2 support, streaming parser, and comptime schema validation. Handles anchors, aliases, and multi-document streams.

## Features

- YAML 1.2 core schema
- streaming parser
- anchor/alias support
- multi-document streams

## Quick Start

```zig
const zioyaml = @import("zioyaml");

pub fn main() !void {
    // See examples/ for runnable code
}
```

## Installation

Add to your `build.zig.zon`:

```zig
.{
    .dependencies = .{
        .zioyaml = .{ .url = "https://github.com/deblasis/zioyaml/archive/refs/heads/main.tar.gz", .hash = "..." },
    },
}
```

Then in your `build.zig`:

```zig
const zioyaml = b.dependency("zioyaml", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("zioyaml", zioyaml.module("zioyaml"));
```

## Examples

Run the included example:

```bash
zig build run-example
```

## API Reference

See [src/zioyaml.zig](src/zioyaml.zig) for full documentation. All public symbols have doc comments.

## Compatibility

- **Zig:** 0.16.0
- **Platforms:** Linux, macOS, Windows
- **Breaking changes:** Follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions may add features, patch versions fix bugs.

## License

MIT
