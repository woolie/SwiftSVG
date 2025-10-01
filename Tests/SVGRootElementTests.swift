//
//  SVGRootElementTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGRootElementTests {
	@Test func widthParse() async throws {
		let testElement = SVGRootElement()
		testElement.parseWidth(lengthString: "103px")
		#expect(testElement.containerLayer.frame.size.width == 103, "Expected width to be 103, got \(testElement.containerLayer.frame.size.width)")
	}
	
	@Test func testHeightParse() async throws {
		let testElement = SVGRootElement()
		testElement.parseHeight(lengthString: "271px")
		#expect(testElement.containerLayer.frame.size.height == 271, "Expected width to be 271, got \(testElement.containerLayer.frame.size.height)")
	}
}
