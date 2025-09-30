//
//  CrossPlatform.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit

	public typealias UIView = NSView
	public typealias UIBezierPath = NSBezierPath
	public typealias UIColor = NSColor
#endif

extension UIView {
	var nonOptionalLayer: CALayer {
		#if os(iOS) || os(tvOS)
		return layer
		#elseif os(OSX)
		if let thisLayer = layer {
			let transform = CGAffineTransform(
				a: 1.0, b: 0.0,
				c: 0.0, d: -1.0,
				tx: 0.0, ty: bounds.size.height
			)
			thisLayer.setAffineTransform(transform)
			return thisLayer
		} else {
			layer = CALayer()
			let transform = CGAffineTransform(
				a: 1.0, b: 0.0,
				c: 0.0, d: -1.0,
				tx: 0.0, ty: bounds.size.height
			)
			layer?.setAffineTransform(transform)
			wantsLayer = true
			return layer!
		}
		#endif
	}
}
