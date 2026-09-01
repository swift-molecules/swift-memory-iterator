public import Iterable
public import Iterator_Chunk
public import Iterator_Protocol
public import Span_Protocol

extension Span.`Protocol` where Self: Iterable, Self: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Primitive.Iterator.Chunk<Element> {
        Iterator_Primitive.Iterator.Chunk(span)
    }
}
