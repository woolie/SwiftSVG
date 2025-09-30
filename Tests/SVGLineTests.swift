//
//  SVGLineTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGLineTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGLine.elementName == "line", "Expected \"line\", got \(SVGLine.elementName)")
	}
}
