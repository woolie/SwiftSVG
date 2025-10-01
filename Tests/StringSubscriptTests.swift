//
//  StringSubscriptTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

import Testing

@Suite final class StringSubscriptTests {
	@Test func integerRange() async throws {
		let testString = "1234567890"

		#expect(testString[0 ..< 3] == "123", "Expected \"123\", got \(testString[0 ..< 2])")
		#expect(testString[3 ..< 7] == "4567", "Expected \"4567\", got \(testString[3 ..< 7])")
	}
}
