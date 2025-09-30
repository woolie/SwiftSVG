//
//  SVGPolylineTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGPolylineTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGPolyline.elementName == "polyline", "Expected \"polyline\", got \(SVGPolyline.elementName)")
	}
}
