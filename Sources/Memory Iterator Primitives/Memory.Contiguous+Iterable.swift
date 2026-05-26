//
//  Memory.Contiguous+Iterable.swift
//  swift-memory-iterator-primitives
//

public import Memory_Contiguous_Primitives
public import Iterator_Primitive
public import Iterator_Chunk_Primitives
public import Iterable

// The contiguous ⇄ iteration bridge.
//
// `extension Memory.Contiguous.Protocol: Iterable` is impossible from a separate package (a
// protocol cannot gain a refinement via a retroactive extension), and the declaration-site form
// would force an iterator dependency onto swift-memory-primitives — refused so iteration stays
// out of memory's identity ([MOD-035]). So iteration is opt-in per conformer: these constrained
// extensions supply the default `makeIterator()` for any contiguous type that declares
// `: Iterable`, vending the bulk `Iterator.Chunk` over the conformer's span. We define no iterator
// of our own — `Iterator.Chunk` is the canonical span-backed iterator; a second would duplicate it.
//
// `Self: ~Copyable` suppresses the protocol-extension default `Self: Copyable`
// (`feedback_extension_implies_copyable` / [MEM-COPY-004]); without it the default would not
// witness the `~Copyable` `Memory.Contiguous`. The return type is module-qualified
// (`Iterator_Primitive.Iterator.Chunk`) because the `Iterable` associated type `Iterator`
// shadows the `Iterator` namespace inside the extension.

// Owned bridge — `Memory.Contiguous.Protocol` (`Memory.ContiguousProtocol`) is owned + Escapable.
extension Memory.ContiguousProtocol where Self: Iterable, Self: ~Copyable, Element: BitwiseCopyable {
    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Primitive.Iterator.Chunk<Element> {
        Iterator_Primitive.Iterator.Chunk(span)
    }
}

// Borrowed bridge — the ~Escapable counterpart for borrowed views (`Memory.Contiguous.Borrowed`,
// `Byte.Borrowed`, `Binary.Borrowed`), which conform to the sibling borrowed protocol. Extends the
// hoisted `__Memory_Contiguous_Borrowed_Protocol` directly: the nested
// `Memory.Contiguous.Borrowed.Protocol` alias can't be named without the outer generic argument.
// Together with the owned bridge this gives maximum ~Copyable / ~Escapable container support.
extension __Memory_Contiguous_Borrowed_Protocol
where Self: Iterable, Self: ~Copyable & ~Escapable, Element: BitwiseCopyable {
    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Primitive.Iterator.Chunk<Element> {
        Iterator_Primitive.Iterator.Chunk(span)
    }
}

// Canonical opt-in: the owned contiguous region is itself iterable, inheriting the owned bridge.
extension Memory.Contiguous: @retroactive Iterable {}
