//
//  ScalarFromByteArrayTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class ScalarFromByteArrayTests {
	@Test func testByteArray() async throws {
		var testArray: [CChar] = [49, 48]
		var asDouble = Double(byteArray: testArray)!
		#expect(asDouble == 10, "Expected 10, got \(asDouble)")

		testArray = [45, 57, 49, 53]
		asDouble = Double(byteArray: testArray)!
		#expect(asDouble == -915, "Expected -915, got \(asDouble)")

		testArray = [45, 54, 46, 51, 56]
		asDouble = Double(byteArray: testArray)!
		#expect(asDouble == -6.38, "Expected -6.38, got \(asDouble)")
	}

	@Test func testInvalidByteArray() async throws {
		var testArray: [CChar] = [65, 48]	   // "A0"
		var asDouble = Double(byteArray: testArray)
		#expect(asDouble == nil, "Expected nil, got \(String(describing: asDouble))")

		testArray = []
		asDouble = Double(byteArray: testArray)
		#expect(asDouble == nil, "Expected nil, got \(String(describing: asDouble))")
	}

	@Test func testENumber() async throws {
		let testArray: [CChar] = [49, 101, 51] // "1e3
		let asDouble = Double(byteArray: testArray)
		#expect(asDouble == 1_000, "Double: \(asDouble!)")
	}

	@Test func testZeroCountArray() async throws {
		let testArray = [CChar]()
		let asDouble = Double(byteArray: testArray)
		#expect(asDouble == nil, "Expected nil, got \(String(describing: asDouble))")
	}
}
