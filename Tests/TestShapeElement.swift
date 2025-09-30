//
//  TestShapeElement.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

@testable import SwiftSVG

struct TestShapeElement: SVGShapeElement {
	static let elementName: String = "test"
	var supportedAttributes: [String: (String) -> Void] = [:]
	var svgLayer = CAShapeLayer()
	
	init() {
		let rectPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 200, height: 200))
		svgLayer.path = rectPath.cgPath
	}
	
	func notReal(string: String) {}
	
	func didProcessElement(in container: SVGContainerElement?) {}
}
