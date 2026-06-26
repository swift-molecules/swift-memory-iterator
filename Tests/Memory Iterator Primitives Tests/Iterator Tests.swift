//
//  Iterator Tests.swift
//  swift-memory-iterator-primitives
//

import Testing

@testable import Memory_Iterator_Primitives

// This package owns no namespace of its own — it supplies the contiguous ⇄ iteration
// bridge as a constrained `Span.\`Protocol\`` extension. The smoke suite therefore nests
// under the transitively re-exported `Iterator` namespace ([INST-TEST-013]). The real
// suite is authored during flip-prep.
extension Iterator {
    @Suite struct Tests {
        @Test func `namespace is available`() {
            // Minimal smoke test — the real suite is authored during flip-prep.
            #expect(Bool(true))
        }
    }
}
