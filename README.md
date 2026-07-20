# zioyaml

YAML parsing utilities for Zig. Key-value extraction, indentation tracking, list items, type inference.

## The pitch

Parse YAML line-by-line. Extract key-value pairs, track indentation levels, detect list items.

```zig
const zioyaml = @import("zioyaml");

// Parse key-value pairs
const kv = zioyaml.parseKeyValue("name: Alice").?;
// kv.key == "name", kv.value == "Alice"

// Track indentation
const indent = zioyaml.indentLevel("    nested: true"); // 4

// Detect list items
if (zioyaml.isListItem("- item one")) {
    const val = zioyaml.parseListItem("- item one").?; // "item one"
}

// Infer value types
const t = zioyaml.inferType("30");      // .integer
const t2 = zioyaml.inferType("3.14");   // .float
const t3 = zioyaml.inferType("null");   // .null_

// Detect structure
zioyaml.isComment("# comment");           // true
zioyaml.isDocumentSeparator("---");       // true
```

## Install

```bash
zig fetch --save git+https://github.com/deblasis/zioyaml
```

Then in your `build.zig`:

```zig
const dep = b.dependency("zioyaml", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("zioyaml", dep.module("zioyaml"));
```

Requires Zig 0.16.

## API

- `parseKeyValue(line)` - extract key and value
- `indentLevel(line)` - count leading spaces
- `isListItem(line)` / `parseListItem(line)` - list syntax
- `inferType(value)` - detect string/integer/float/boolean/null
- `isComment(line)` / `isDocumentSeparator(line)`
- `parseBool(value)` - parse "true" or "false", null otherwise

This is not a full YAML parser. It has no document tree, no anchors or aliases and no schema validation.

## Compatibility

- **Zig**: 0.16.0
- **Platforms**: Linux, macOS, Windows
- **Breaking changes**: follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions add features, patch versions fix bugs.

## License

MIT. Copyright (c) 2026 Alessandro De Blasis.
