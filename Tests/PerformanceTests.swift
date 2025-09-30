//
//  PerformanceTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import System
import XCTest

class PerformanceTests: XCTestCase {
	func testSwiftSVG() {
		measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) {
			let filenamePath = FilePath("simple-rectangle.svg")
			guard let filePath = Bundle.module.path(
				forResource: filenamePath.stem,
				ofType: filenamePath.extension,
				inDirectory: "TestFiles"
			) else {
				XCTAssert(false, "Bundle path not found \"simple-rectangle.svg\"")
				return
			}

			let resourceURL = URL(filePath: filePath)

			let asData = try! Data(contentsOf: resourceURL)
			let expect = self.expectation(description: "SwiftSVG expectation")
			_ = UIView(svgData: asData) { svgLayer in
				SVGCache.default.removeObject(key: asData.cacheKey)
				expect.fulfill()
			}

			self.waitForExpectations(timeout: 10) { error in
				self.stopMeasuring()
			}
		}
	}
}
