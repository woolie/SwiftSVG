//
//  SVGEllipseTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGEllipseTests {
	@Test func testElementName() async throws {
		#expect(SVGEllipse.elementName == "ellipse", "Expected \"ellipse\", got \(SVGEllipse.elementName)")
	}
}
