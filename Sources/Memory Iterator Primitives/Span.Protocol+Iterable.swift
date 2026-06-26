//
//  Span.Protocol+Iterable.swift
//  swift-memory-iterator-primitives
//

public import Iterable
public import Iterator_Chunk_Primitives
public import Iterator_Primitive
public import Span_Protocol_Primitives

// The contiguous ⇄ iteration bridge.
//
// `extension Span.\`Protocol\`: Iterable` is impossible from a separate package (a
// protocol cannot gain a refinement via a retroactive extension), and the declaration-site form
// would force an iterator dependency onto swift-span-primitives — refused so iteration stays
// out of the span capability's identity ([MOD-035]). So iteration is opt-in per conformer: this
// constrained extension supplies the default `makeIterator()` for any contiguous type that declares
// `: Iterable`, vending the bulk `Iterator.Chunk` over the conformer's span. We define no iterator
// of our own — `Iterator.Chunk` is the canonical span-backed iterator; a second would duplicate it.
//
// ONE bridge for both lifetime regimes: with the unified `Span.\`Protocol\``
// (post-collapse), the formerly separate owned and borrowed bridges — identical bodies, differing
// only in the `~Escapable` restatement — merge into this single extension. The restated
// `Self: ~Copyable & ~Escapable` is REQUIRED (`feedback_extension_implies_copyable` /
// [MEM-COPY-004]): without it the extension's `Self` is implicitly Escapable/Copyable, so the
// default would witness neither the `~Copyable` owned conformers nor a `~Escapable` borrowed view.
// Owned Escapable conformers satisfy the suppressed constraints (suppression admits, it does not
// require), so the single general form covers the buffer family, a bare `Swift.Span`, and any
// nominal borrowed view alike.
//
// RELAXED (D4) `Element: Copyable → ~Copyable`: under the span-primitive `Iterable`, `Iterator.Chunk`
// admits `~Copyable` and `span[i]` borrows (never moves out), so the bridge vends the bulk iterator
// for BOTH element kinds — `Set.Ordered` + the buffer family get `Iterable` (~Copyable) for free.
// The return type is module-qualified (`Iterator_Primitive.Iterator.Chunk`) because the `Iterable`
// associated type `Iterator` shadows the `Iterator` namespace inside the extension.
extension Span.`Protocol` where Self: Iterable, Self: ~Copyable & ~Escapable {
    /// Returns the canonical span-backed bulk iterator over this contiguous region's elements.
    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Primitive.Iterator.Chunk<Element> {
        Iterator_Primitive.Iterator.Chunk(span)
    }
}

// The bespoke span-lending `forEach` floor that used to live here (a more-specialized
// `extension Iterable where Self: Span.\`Protocol\``) is REMOVED (D4). Under the
// span-primitive `Iterable`, the GENERAL `Iterable.forEach` IS itself the span loop
// (`for i in span.indices { body(span[i]) }`, driven by `makeIterator() -> Iterator.Chunk`),
// so it already carries `~Copyable` elements over the span with no Copyable gate. Keeping the
// bespoke floor would now collide with the general one (both span loops) — the duplication
// dissolves into the general terminal.
