# zioyaml

## Overview

Small YAML line parsing helpers for Zig. It works one line at a time: key/value extraction, indentation counting, list items, comments, document separators and simple type inference. It is not a full YAML parser. There is no document tree, no anchors or aliases, and no schema validation.

## Project Structure

```
src/
  zioyaml.zig    - Main library source
examples/
  example.zig    - Runnable example
build.zig        - Build configuration
```

## Commands

```bash
zig build test          # Run tests
zig build run-example   # Run the example
zig build               - Build the library
```

## Architecture

Single-file library with no external dependencies. All public symbols have doc comments.

## Testing

Tests are inline in `src/zioyaml.zig`. Run with `zig build test`.
