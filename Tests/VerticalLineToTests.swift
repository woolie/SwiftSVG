//
//  VerticalLineToTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class VerticalLineToTests {
	@Test func absoluteVerticalLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = VerticalLineTo(parameters: [-128], pathType: .absolute, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[1].x == 10 && points[1].y == -128, "Expected {10, -128}, got \(points[1])")
	}
	
	@Test func relativeVerticalLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = VerticalLineTo(parameters: [-128], pathType: .relative, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[1].x == 10 && points[1].y == -148, "Expected {10, -148}, got \(points[1])")
	}
}
