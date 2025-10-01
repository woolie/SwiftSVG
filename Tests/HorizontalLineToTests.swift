//
//  HorizontalLineToTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

import Testing
@testable import SwiftSVG

@Suite final class HorizontalLineToTests {
	@Test func absoluteHorizontalLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = HorizontalLineTo(parameters: [-128], pathType: .absolute, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[1].x == -128 && points[1].y == -20, "Expected {-128, -20}, got \(points[1])")
	}
	
	@Test func relativeHorizontalLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = HorizontalLineTo(parameters: [-128], pathType: .relative, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[1].x == -118 && points[1].y == -20, "Expected {-118, -20}, got \(points[1])")
	}
}
