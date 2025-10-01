//
//  FloatingPointParseLengthStringTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

@testable import SwiftSVG
import Testing

@Suite final class FloatingPointParseLengthTests {
	@Test func straightInteger() async throws {
		let testNumber = Double(lengthString: "78")
		#expect(testNumber == 78, "Expected 78, got \(testNumber!)")
	}

	@Test func pixelAnnotation() async throws {
		let testNumber = Double(lengthString: "890px")
		#expect(testNumber == 890, "Expected 890, got \(testNumber!)")
	}

	@Test func unsupportedSuffix() async throws {
		let testNumber = Float(lengthString: "123em")
		#expect(testNumber == nil, "Expected nil, got \(testNumber!)")
	}
}
