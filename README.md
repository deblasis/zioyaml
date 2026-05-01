# zioyaml

YAML parsing utilities for Zig. Key-value extraction, indentation tracking, list items, type inference.

Parse YAML line-by-line. Extract key-value pairs, track indentation levels, detect list items and document separators, infer value types.

## Quick start

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

## Example output

`zig build run-example` produces:

```
=== zioyaml example ===

Parsing YAML lines:
  name: Alice (string, indent=0)
  age: 30 (integer, indent=0)
  active: true (boolean, indent=0)
  score: 95.5 (float, indent=0)
  address: null (null, indent=0)
  - item one (list item)
  --- (DOC SEPARATOR)
```

See [examples/example.zig](examples/example.zig) for the source.

## API

- `parseKeyValue(line)` — extract key and value from a YAML line
- `indentLevel(line)` — count leading spaces
- `isListItem(line)` — detect `- item` syntax
- `parseListItem(line)` — extract list item value
- `inferType(value)` — detect string/integer/float/boolean/null
- `isComment(line)` / `isDocumentSeparator(line)` — detect special lines

## Compatibility

- **Zig**: 0.16.0
- **Platforms**: Linux, macOS, Windows
- **Breaking changes**: follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions add features, patch versions fix bugs.

## License

MIT. Copyright (c) 2026 Alessandro De Blasis.
