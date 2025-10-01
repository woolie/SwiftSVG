//
//  SVGPolygonTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGPolygonTests {
	@Test func testElementName() async throws {
		#expect(SVGPolygon.elementName == "polygon", "Expected \"polygon\", got \(SVGPolygon.elementName)")
	}
}
