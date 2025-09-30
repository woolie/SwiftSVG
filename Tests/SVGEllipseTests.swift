//
//  SVGEllipseTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGEllipseTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGEllipse.elementName == "ellipse", "Expected \"ellipse\", got \(SVGEllipse.elementName)")
	}
}
