# zioyaml

## Overview

YAML parser for Zig. Full YAML 1.2 support, streaming parser, and comptime schema validation. Handles anchors, aliases, and multi-document streams.

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
