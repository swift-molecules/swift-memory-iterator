//
//  Memory.Contiguous Iterable Tests.swift
//  swift-memory-iterator-primitives
//

import Testing
import Memory_Iterator_Primitives

// A minimal ~Escapable borrowed contiguous view — conforms to the borrowed sibling protocol
// (the hoisted `__Memory_Contiguous_Borrowed_Protocol`) and opts into Iterable, exercising the
// borrowed bridge.
private struct FixtureBorrowed: ~Copyable, ~Escapable {
    let _span: Span<Int>

    @_lifetime(copy span)
    init(_ span: Span<Int>) {
        self._span = span
    }

    var span: Span<Int> {
        @_lifetime(copy self)
        get { _span }
    }
}

extension FixtureBorrowed: __Memory_Contiguous_Borrowed_Protocol {}
extension FixtureBorrowed: Iterable {}

@Suite("Memory.Contiguous Iterable bridge")
struct MemoryContiguousIterableTests {
    @Test("owned region iterates element by element via Iterator.Chunk, then exhausts")
    func iteratesOwned() {
        let count = 4
        let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
        for offset in 0..<count { unsafe pointer[offset] = (offset + 1) * 10 }
        let region = unsafe Memory.Contiguous(adopting: pointer, count: count)

        var collected: [Int] = []
        var iterator = region.makeIterator()
        while let element = iterator.next() {
            collected.append(element)
        }

        #expect(collected == [10, 20, 30, 40])
    }

    @Test("borrowed view iterates via the borrowed bridge")
    func iteratesBorrowedView() {
        let backing = [11, 22, 33]
        var collected: [Int] = []
        let view = FixtureBorrowed(backing.span)
        var iterator = view.makeIterator()
        while let element = iterator.next() {
            collected.append(element)
        }

        #expect(collected == [11, 22, 33])
    }
}
