//
//  SVGPathTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGPathTests {
	@Test func testElementName() async throws {
		#expect(SVGPath.elementName == "path", "Expected \"path\", got \(SVGPath.elementName)")
	}
}
