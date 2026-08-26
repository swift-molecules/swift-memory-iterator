import Testing

@testable import Memory_Iterator

extension Iterator {
    @Suite struct Tests {
        @Test func `namespace is available`() {

            #expect(Bool(true))
        }
    }
}
