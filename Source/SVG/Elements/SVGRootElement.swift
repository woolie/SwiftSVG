//
//  SVGRootElement.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Concrete implementation that creates a container from a `<svg>` element and its attributes. This will almost always be the root container element that will container all other `SVGElement` layers
struct SVGRootElement: SVGContainerElement {
	/// :nodoc:
	static let elementName = "svg"

	// :nodoc:
	var delayedAttributes = [String: String]()

	// :nodoc:
	var containerLayer = CALayer()

	// :nodoc:
	var supportedAttributes = [String: (String) -> Void]()

	/// Function that parses a number string and sets the `containerLayer`'s width
	func parseWidth(lengthString: String) {
		if let width = CGFloat(lengthString: lengthString) {
			containerLayer.frame.size.width = width
		}
	}

	/// Function that parses a number string and sets the `containerLayer`'s height
	func parseHeight(lengthString: String) {
		if let height = CGFloat(lengthString: lengthString) {
			containerLayer.frame.size.height = height
		}
	}

	/// :nodoc:
	func didProcessElement(in container: SVGContainerElement?) {}

	/// nodoc:
	func viewBox(coordinates: String) {
		let points = coordinates
			.components(separatedBy: CharacterSet(charactersIn: ", "))
			.compactMap { thisString -> Double? in
				return Double(thisString.trimWhitespace())
			}

		guard points.count == 4 else { return }
		containerLayer.frame = CGRect(x: points[0], y: points[1], width: points[2], height: points[3])
	}
}
