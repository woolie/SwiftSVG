//
//  SVGPathTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGPathTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGPath.elementName == "path", "Expected \"path\", got \(SVGPath.elementName)")
	}
}
