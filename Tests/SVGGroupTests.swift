//
//  SVGGroupTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGGroupTests: XCTestCase {
	func testElementName() {
		XCTAssert(SVGGroup.elementName == "g", "Expected \"g\", got \(SVGGroup.elementName)")
	}
}
