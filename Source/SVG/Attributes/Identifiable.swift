//
//  Identifiable
//  SwiftSVG
//
//  Thanks to Oliver Jones (@orj) for adding this.
//  Copyright (c) 2017 Michael Choe
//

import Foundation

public protocol Identifiable {}

extension Identifiable where Self: SVGShapeElement {
	///
	/// The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var identityAttributes: [String: (String) -> Void] {
		[
			"id": identify
		]
	}

	///
	/// Sets the identifier of the underlying `SVGLayer`.
	/// - SeeAlso: CALayer's [`name`](https://developer.apple.com/documentation/quartzcore/calayer/1410879-name) property
	///
	func identify(identifier: String) {
		svgLayer.name = identifier
	}
}

extension Identifiable where Self: SVGGroup {
	///
	/// The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var identityAttributes: [String: (String) -> Void] {
		[
			"id": unown(self, SVGGroup.identify)
		]
	}
}

extension Identifiable where Self: SVGContainerElement {
	///
	/// The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var identityAttributes: [String: (String) -> Void] {
		[
			"id": identify
		]
	}

	///
	/// Sets the identifier of the underlying `SVGLayer`.
	/// - SeeAlso: CALayer's [`name`](https://developer.apple.com/documentation/quartzcore/calayer/1410879-name) property
	///
	func identify(identifier: String) {
		containerLayer.name = identifier
	}
}
