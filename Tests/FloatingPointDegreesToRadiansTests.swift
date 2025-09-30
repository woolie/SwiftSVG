//
//  FloatingPointDegreesToRadiansTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

import XCTest

class FloatingPointDegreesToRadiansTests: XCTestCase {
	func testToRadians() {
		let degrees = 180.0
		XCTAssert(degrees.toRadians == Double.pi, "Expected pi, got \(degrees.toRadians)")
	}
	
	func testToDegrees() {
		let radians = Double.pi
		XCTAssert(radians.toDegrees == 180, "Expected 180, got \(radians.toDegrees)")
	}
}
