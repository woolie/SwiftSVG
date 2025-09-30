//
//  NSBezierPath+CrossPlatform.swift
//  SwiftSVG
//
//
//  Created by Michael Choe on 1/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(OSX)
import AppKit

public extension NSBezierPath {
	func cgPath() -> CGPath {
		if #available(macOS 14, *) {
			self.cgPath
		} else {
			cgPathPre14
		}
	}

	var cgPathPre14: CGPath {
		let path = CGMutablePath()
		let points = NSPointArray.allocate(capacity: 3)

		for i in 0 ..< elementCount {
			let type: NSBezierPath.ElementType = element(at: i, associatedPoints: points)
			switch type {
			case .moveTo:
				path.move(to: points[0])
			case .lineTo:
				path.addLine(to: points[0])
			case .curveTo, .cubicCurveTo:
				path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .quadraticCurveTo:
				fatalError("Not supported yet")
			case .closePath:
				path.closeSubpath()
			@unknown default:
				fatalError("Not supported yet")
			}
		}
		return path
	}

	func addLine(to point: NSPoint) {
		line(to: point)
	}

	func addCurve(to point: NSPoint, controlPoint1: NSPoint, controlPoint2: NSPoint) {
		curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
	}

	func addQuadCurve(to point: NSPoint, controlPoint: NSPoint) {
		curve(to: point,
			  controlPoint1: NSPoint(
				x: (controlPoint.x - currentPoint.x) * (2.0 / 3.0) + currentPoint.x,
				y: (controlPoint.y - currentPoint.y) * (2.0 / 3.0) + currentPoint.y),
			  controlPoint2: NSPoint(
				x: (controlPoint.x - point.x) * (2.0 / 3.0) +  point.x,
				y: (controlPoint.y - point.y) * (2.0 / 3.0) +  point.y))
	}
}

#elseif os(iOS) || os(tvOS)
import UIKit

public extension UIBezierPath {
	func cgPath() -> CGPath {
		cgPath
	}
}
#endif
