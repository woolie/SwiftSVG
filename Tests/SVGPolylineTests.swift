//
//  SVGPolylineTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class SVGPolylineTests {
	func elementName() {
		#expect(SVGPolyline.elementName == "polyline", "Expected \"polyline\", got \(SVGPolyline.elementName)")
	}
}
