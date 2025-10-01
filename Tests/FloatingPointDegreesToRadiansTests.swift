//
//  FloatingPointDegreesToRadiansTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

import Testing

@Suite final class FloatingPointDegreesToRadiansTests {
	@Test func toRadians() async throws {
		let degrees = 180.0
		#expect(degrees.toRadians == Double.pi, "Expected pi, got \(degrees.toRadians)")
	}
	
	@Test func toDegrees() async throws {
		let radians = Double.pi
		#expect(radians.toDegrees == 180, "Expected 180, got \(radians.toDegrees)")
	}
}
