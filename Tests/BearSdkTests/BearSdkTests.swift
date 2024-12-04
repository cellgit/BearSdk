import Testing
@testable import BearSdk

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    debugPrint("test example")
    
    BearSdk.makeRequest()
    
}
