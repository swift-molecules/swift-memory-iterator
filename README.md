# Memory Iterator

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The bridge from contiguous storage to iteration: gives any `Span.Protocol` conformer a default span-backed iterator the moment it opts into `Iterable`.

---

## Quick Start

Iteration is kept out of the span capability's identity — a contiguous type that vends a `Swift.Span` is not, by that fact alone, iterable. This package supplies the one missing edge: a constrained extension that hands every `Span.Protocol` conformer a default `makeIterator()` as soon as it declares `: Iterable`. The iterator it vends is the canonical bulk `Iterator.Chunk` over the conformer's own span, so iteration is opt-in per type and there is no second iterator to write.

```swift
import Memory_Iterator

// `Swift.Span` is already the canonical `Span.Protocol` conformer — it vends itself.
// Opting it into `Iterable` is the whole ceremony: this package supplies the default
// `makeIterator()`, so every `Iterable` terminal lights up over the span.
extension Swift.Span: @retroactive Iterable {}

let readings = [10, 20, 30, 40]
let span = readings.span            // borrow the array's contiguous storage

var total = 0
span.forEach { total += $0 }        // `forEach` comes from `Iterable`, driven by the
print(total)                        // span-backed `Iterator.Chunk`            →  100
```

`makeIterator()` is `borrowing`, so the container survives the call and can be re-iterated (the multipass contract). Each element is handed to the closure by *borrow* over the iterator's span — never moved out — so the same bridge carries both `Copyable` and `~Copyable` element types, and the buffer family, a bare `Swift.Span`, and any nominal borrowed view all become iterable through the one extension. Once a type is `Iterable`, the full terminal set follows for free: `forEach`, `first`, `reduce`, `contains`, `allSatisfy`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-memory-iterator.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Memory Iterator", package: "swift-memory-iterator"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

One library product. The whole package is a single constrained extension plus the re-exports its consumers need.

| Product | Target | Purpose |
|---------|--------|---------|
| `Memory Iterator` | `Sources/Memory Iterator/` | Supplies the `Span.Protocol where Self: Iterable` default `makeIterator()`, vending `Iterator.Chunk` over the conformer's span; `@_exported`s `Iterable` and `Iterator Chunk` so a single import brings the capability and the iterator into scope. |

Depends only on `Span Protocol`, `Iterable`, `Iterator Primitive`, and `Iterator Chunk`. Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
