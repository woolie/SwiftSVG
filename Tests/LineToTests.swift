//
//  LineToTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

@testable import SwiftSVG
import Testing

@Suite final class LineToTests {
	@Test func absoluteLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = LineTo(parameters: [66, 37], pathType: .absolute, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
		#expect(points[1].x == 66 && points[1].y == 37, "Expected 66, 37, got \(points[1])")
	}

	@Test func relativeLineTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
		_ = LineTo(parameters: [66, 37], pathType: .relative, path: testPath)
		let points = testPath.cgPath.points
		#expect(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
		#expect(points[1].x == 76 && points[1].y == 17, "Expected 76, 17, got \(points[1])")
	}
}
