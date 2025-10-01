//
//  StackTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

@testable import SwiftSVG
import Testing

@Suite final class StackTests {
	@Test func count() async throws {
		var testStack = Stack<Int>()
		testStack.push(1)
		testStack.push(10)
		#expect(testStack.count == 2, "Expected 2, got \(testStack.count)")
	}

	@Test func last() async throws {
		var testStack = Stack<Float>()
		testStack.push(1.5)
		testStack.push(8.2)
		testStack.push(40.4)
		#expect(testStack.last == 40.4, "Expected 40.4, got \(testStack.last!)")
	}

	@Test func clear() async throws {
		var testStack = Stack<String>()
		testStack.push("Hello")
		testStack.push("There")
		testStack.clear()
		#expect(testStack.isEmpty, "Expected 0, got \(testStack.count)")
	}

	@Test func isEmpty() async throws {
		let testStack = Stack<String>()
		#expect(testStack.isEmpty == true, "Expected empty stack, got \(testStack.items)")
	}

	@Test func testPush() async throws {
		var testStack = Stack<String>()
		testStack.push("hello")
		#expect(testStack.last == "hello", "Expected \"hello\", got \(testStack.last!)")
	}

	@Test func testPop() async throws {
		var testStack = Stack<Character>()
		testStack.push(Character("a"))
		testStack.push(Character("b"))
		testStack.push(Character("c"))
		testStack.push(Character("d"))
		let poppedItem = testStack.pop()
		#expect(poppedItem == "d", "Expected d, got \(poppedItem!)")
		#expect(testStack.count == 3, "Expected count of 3, got \(testStack.count)")
	}
}
