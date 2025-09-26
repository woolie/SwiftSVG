//
//  UIColorExtensionsTests.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Testing
import Foundation

@testable import SwiftSVG

@Suite final class ColorExtensionsTesting {
	@Test func hexString() async throws {
		var testString = "#FFFF00"
		var testColor = UIColor(hexString: testString)
		var colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")

		testString = "#FffF00"
		testColor = UIColor(hexString: testString)
		colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")

		testString = "00fF00"
		testColor = UIColor(hexString: testString)
		colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
	}

	@Test func testHexStringWithAlpha() async throws {
		var testString = "#fcab1def"
		var testColor = UIColor(hexString: testString)
		var colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 252.0 / 255.0, "Expected \(252.0 / 255.0), got \(colorArray[0])")
		#expect(colorArray[1] == 171.0 / 255.0, "Expected \(171.0 / 255.0), got \(colorArray[1])")
		#expect(colorArray[2] == 29.0 / 255.0, "Expected \(29.0 / 255.0), got \(colorArray[2])")
		#expect(colorArray[3] == 239.0 / 255.0, "Expected \(239.0 / 255.0), got \(colorArray[2])")

		testString = "a6bfc4d0"
		testColor = UIColor(hexString: testString)
		colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 166.0 / 255.0, "Expected \(166 / 255), got \(colorArray[0])")
		#expect(colorArray[1] == 191.0 / 255.0, "Expected \(191 / 255), got \(colorArray[1])")
		#expect(colorArray[2] == 196.0 / 255.0, "Expected \(196 / 255.0), got \(colorArray[2])")
		#expect(colorArray[3] == 208.0 / 255.0, "Expected \(208.0 / 255.0), got \(colorArray[2])")
	}

	@Test func testShortHexStrings() async throws {
		var testString = "#30f"
		var testColor = UIColor(hexString: testString)
		var colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 0.2, "Expected 0.2, got \(colorArray[0])")
		#expect(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
		#expect(colorArray[2] == 1.0, "Expected 1.0, got \(colorArray[2])")

		testString = "f033"
		testColor = UIColor(hexString: testString)
		colorArray = ColorArray(testColor!)
		#expect(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
		#expect(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
		#expect(colorArray[2] == 0.2, "Expected 0.2, got \(colorArray[2])")
		#expect(colorArray[3] == 0.2, "Expected 0.2, got \(colorArray[3])")
	}

	@Test func testRGBString() async throws {
		let testString = "rgb(255, 255, 0)"
		let testColor = UIColor(rgbString: testString)
		let colorArray = ColorArray(testColor)
		#expect(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
	}

	@Test func testNamedColor() async throws {
		let testString = "cyan"
		guard let testColor = UIColor(cssName: testString) else {
			Issue.record("Named color [\(testString)] does not exist")
			return
		}
		let colorArray = ColorArray(testColor)
		#expect(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 1, "Expected 1, got \(colorArray[2])")
	}

	@Test func testClearColors() async throws {
		var testString = "none"
		guard let testColor = UIColor(cssName: testString) else {
			Issue.record("Named color [\(testString)] does not exist")
			return
		}
		var colorArray = ColorArray(testColor)
		#expect(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
		#expect(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
		#expect(colorArray[3] == 0, "Expected 0, got \(colorArray[3])")

		testString = "transparent"
		guard let testColor2 = UIColor(cssName: testString) else {
			Issue.record("Named color [\(testString)] does not exist")
			return
		}
		colorArray = ColorArray(testColor2)
		#expect(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
		#expect(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
		#expect(colorArray[3] == 0, "Expected 0, got \(colorArray[3])")
	}
}

func ColorArray(_ color: UIColor) -> [CGFloat] {
	var red = CGFloat()
	var green = CGFloat()
	var blue = CGFloat()
	var alpha = CGFloat()
	color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
	return [red, green, blue, alpha]
}
