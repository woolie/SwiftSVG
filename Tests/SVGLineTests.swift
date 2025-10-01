//
//  SVGLineTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGLineTests {
	@Test func testElementName() async throws {
		#expect(SVGLine.elementName == "line", "Expected \"line\", got \(SVGLine.elementName)")
	}
}
