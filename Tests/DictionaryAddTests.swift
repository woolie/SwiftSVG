//
//  DictionaryAddTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

import XCTest

class DictionaryMergeTests: XCTestCase {
	var one = [
		"one": "one",
		"two": "two",
		"three": "three",
		"four": "four",
		"five": "five",
		"six": "six",
		"seven": "seven",
		"eight": "eight",
		"nine": "nine",
		"ten": "ten"
	]
	var two = [
		"eleven": "eleven",
		"twelve": "twelve",
		"thirteen": "thirteen",
		"fourteen": "fourteen",
		"fifteen": "fifteen",
		"sixteen": "sixteen",
		"seventeen": "seventeen",
		"eighteen": "eighteen",
		"nineteen": "nineteen",
		"twenty": "twenty",
	]
	
	func testForEach() {
		measure {
			self.two.forEach {
				self.one[$0] = $1
			}
		}
	}
	
	func testForIn() {
		measure {
			for (key, value) in self.two {
				self.one[key] = value
			}
		}
	}
	
	func testMerge() {
		one.add(two)
		XCTAssert(one.count == 20, "Expected 20, got \(one.count)")
		XCTAssert(one["twenty"] == "twenty", "Expected \"twenty\", got \(one["twenty"]!)")
	}
}
