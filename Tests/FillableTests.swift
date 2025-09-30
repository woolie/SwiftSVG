//
//  FillableTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

@testable import SwiftSVG
import XCTest

class FillableTests: XCTestCase {
	func testFillOpacity() {
		let testShapeElement = TestShapeElement()
		testShapeElement.fill(fillColor: "#00FF33")
		testShapeElement.fillOpacity(opacity: "0.5")
		XCTAssert(testShapeElement.svgLayer.opacity == 1.0, "Fill opacity should be set on the CAShapelayer's fill color and not on the layer's overall opacity.")
		
		guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
			XCTFail("Fill opacity should set the fill color")
			return
		}
		XCTAssert(fillComponents[3] == 0.5, "Expected 0.5, got \(fillComponents[3])")
	}
	
	func testFillOpacityOrder() {
		let testShapeElement = TestShapeElement()
		testShapeElement.fillOpacity(opacity: "0.5")
		testShapeElement.fill(fillColor: "#00FF00")
		
		guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
			XCTFail("Fill should return color components")
			return
		}
		XCTAssert(fillComponents[3] == 0.5, "Fill color should preserve any existing fill opacity. Expected 0.5, got \(fillComponents[3])")
	}
	
	func testFillOpacityColorComponents() {
		let testShapeElement = TestShapeElement()
		testShapeElement.fill(fillColor: "#33FF66")
		testShapeElement.fillOpacity(opacity: "0.5")
		guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
			XCTFail("Fill opacity should set the fill color")
			return
		}
		XCTAssert(testShapeElement.svgLayer.fillColor?.components![0] == 0.2, "Expected 0.0, got \(fillComponents[0])")
		XCTAssert(testShapeElement.svgLayer.fillColor?.components![1] == 1.0, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![1])")
		XCTAssert(testShapeElement.svgLayer.fillColor?.components![2] == 0.4, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![2])")
		XCTAssert(testShapeElement.svgLayer.fillColor?.components![3] == 0.5, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![3])")
	}
}
