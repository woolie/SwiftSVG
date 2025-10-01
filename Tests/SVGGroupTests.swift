//
//  SVGGroupTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGGroupTests {
	@Test func testElementName() async throws {
		#expect(SVGGroup.elementName == "g", "Expected \"g\", got \(SVGGroup.elementName)")
	}
}
