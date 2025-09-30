//
//  SVGRootElementTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import XCTest

class SVGRootElementTests: XCTestCase {
	func testWidthParse() {
		let testElement = SVGRootElement()
		testElement.parseWidth(lengthString: "103px")
		XCTAssertTrue(testElement.containerLayer.frame.size.width == 103, "Expected width to be 103, got \(testElement.containerLayer.frame.size.width)")
	}
	
	func testHeightParse() {
		let testElement = SVGRootElement()
		testElement.parseHeight(lengthString: "271px")
		XCTAssertTrue(testElement.containerLayer.frame.size.height == 271, "Expected width to be 271, got \(testElement.containerLayer.frame.size.height)")
	}
}
