public import Iterable
public import Iterator
public import Iterator_Chunk
public import Iterator_Protocol
public import Span_Protocol

extension Span.`Protocol` where Self: Iterable, Self: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator::Iterator.Chunk<Element> {
        Iterator::Iterator.Chunk(span)
    }
}
