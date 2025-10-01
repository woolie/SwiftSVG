//
//  MoveToTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

@testable import SwiftSVG
import Testing

@Suite final class MoveToTests {
	@Test func absoluteMoveTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [20, -30], pathType: .absolute, path: testPath)
		#expect(testPath.currentPoint.x == 20 && testPath.currentPoint.y == -30, "Expected {20, -30}, got \(testPath.currentPoint)")

		let firstPoint = testPath.cgPath.points[0]
		#expect(firstPoint.x == 20 && firstPoint.y == -30, "Expected {20, -30}, got \(firstPoint)")
	}

	@Test func relativeMoveTo() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [20, -30], pathType: .absolute, path: testPath)
		_ = LineTo(parameters: [55, -20], pathType: .absolute, path: testPath)
		_ = MoveTo(parameters: [50, -10], pathType: .relative, path: testPath)
		#expect(testPath.currentPoint.x == 105 && testPath.currentPoint.y == -30, "Expected {105, -30}, got \(testPath.currentPoint)")
	}

	@Test func relativeFirstMoveToTreatedAsAbsolute() async throws {
		let testPath = UIBezierPath()
		_ = MoveTo(parameters: [50, 30], pathType: .relative, path: testPath, previousCommand: nil)
		#expect(testPath.currentPoint.x == 50 && testPath.currentPoint.y == 30, "Expected {50, 30}, got \(testPath.currentPoint)")
	}

	@Test func multipleMoveToCommands() async throws {
		let testPath = UIBezierPath()
		let moveTo1 = MoveTo(parameters: [10, 20], pathType: .relative, path: testPath)
		let moveTo2 = MoveTo(parameters: [30, 40], pathType: .relative, path: testPath, previousCommand: moveTo1)
		_ = MoveTo(parameters: [70, 80], pathType: .absolute, path: testPath, previousCommand: moveTo2)
		
		let pointsAndTypes = testPath.cgPath.pointsAndTypes
		#expect(pointsAndTypes[0].1 == .moveToPoint, "Expected .moveToPoint, got \(pointsAndTypes[0].1)")
		#expect(pointsAndTypes[1].1 == .addLineToPoint, "Expected .addLineToPoint, got \(pointsAndTypes[1].1)")
		#expect(pointsAndTypes[2].1 == .addLineToPoint, "Expected .addLineToPoint, got \(pointsAndTypes[2].1)")

		#expect(pointsAndTypes[0].0.x == 10 && pointsAndTypes[0].0.y == 20, "Expected {10, 20}, got \(pointsAndTypes[0].0)")
		#expect(pointsAndTypes[1].0.x == 40 && pointsAndTypes[1].0.y == 60, "Expected {40, 60}, got \(pointsAndTypes[1].0)")
		#expect(pointsAndTypes[2].0.x == 70 && pointsAndTypes[2].0.y == 80, "Expected {70, 80}, got \(pointsAndTypes[2].0)")
	}
}
