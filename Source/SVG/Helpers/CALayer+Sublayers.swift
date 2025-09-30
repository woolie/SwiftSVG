//
//  CALayer+Sublayers.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Helper functions that make it easier to find and work with sublayers
public extension CALayer {
	/// Helper function that applies the given closure on all sublayers of a given type
	func applyOnSublayers<T: CALayer>(ofType: T.Type, closure: (T) -> Void) {
		_ = sublayers(in: self).map(closure)
	}

	/// Helper function that returns an array of all sublayers of a given type
	func sublayers<U>(in layer: some CALayer) -> [U] {
		var sublayers = [U]()

		guard let allSublayers = layer.sublayers else { return sublayers }

		for thisSublayer in allSublayers {
			sublayers += self.sublayers(in: thisSublayer)
			if let thisSublayer = thisSublayer as? U {
				sublayers.append(thisSublayer)
			}
		}
		return sublayers
	}
}
