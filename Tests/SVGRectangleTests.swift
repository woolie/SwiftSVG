//
//  SVGRectangleTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGRectangleTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGRectangle.elementName == "rect", "Expected \"rect\", got \(SVGRectangle.elementName)")
	}
}
