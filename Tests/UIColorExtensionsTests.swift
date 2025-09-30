//
//  UIColorExtensionsTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

import Foundation
import Testing

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

	@Test func hexStringWithAlpha() async throws {
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

	@Test func shortHexStrings() async throws {
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

	@Test func rGBString() async throws {
		let testString = "rgb(255, 255, 0)"
		let testColor = UIColor(rgbString: testString)
		let colorArray = ColorArray(testColor)
		#expect(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
		#expect(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
		#expect(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
	}

	@Test func namedColor() async throws {
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

	@Test func clearColors() async throws {
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
