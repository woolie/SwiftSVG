//
//  SVGCircleTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Foundation
import Testing

@Suite final class SVGCircleTests {
	@Test func testElementName() async throws {
		#expect(SVGCircle.elementName == "circle", "Expected \"circle\", got \(SVGCircle.elementName)")
	}

	@Test func testSettingValues() async throws {
		let testCircle = SVGCircle()
		testCircle.xCenter(x: "40.3")
		testCircle.yCenter(y: "108.254")

		#expect(testCircle.circleCenter == CGPoint(x: 40.3, y: 108.254), "Expected {40.3, 108.254}, got \(testCircle.circleCenter)")

		testCircle.radius(r: "435.10")
		#expect(testCircle.circleRadius == 435.1, "Expected 435.1, got \(testCircle.circleRadius)")

		testCircle.radius(r: "1e3")
		#expect(testCircle.circleRadius == 1_000, "Expected 1000, got \(testCircle.circleRadius)")
	}
}
