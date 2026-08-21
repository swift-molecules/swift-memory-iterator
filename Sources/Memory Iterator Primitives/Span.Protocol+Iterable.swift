public import Iterable
public import Iterator_Chunk_Primitives
public import Iterator_Primitive
public import Span_Protocol_Primitives

extension Span.`Protocol` where Self: Iterable, Self: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Primitive.Iterator.Chunk<Element> {
        Iterator_Primitive.Iterator.Chunk(span)
    }
}
