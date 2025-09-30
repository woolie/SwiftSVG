//
//  SVGPolygonTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGPolygonTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGPolygon.elementName == "polygon", "Expected \"polygon\", got \(SVGPolygon.elementName)")
	}
}
