//
//  SVGRectangleTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGRectangleTests {
	@Test func elementName() async throws {
		#expect(SVGRectangle.elementName == "rect", "Expected \"rect\", got \(SVGRectangle.elementName)")
	}
}
