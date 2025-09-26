//
//  SVGCircle.swift
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

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

/**
 Concrete implementation that creates a `CAShapeLayer` from a `<circle>` element and its attributes
 */

final class SVGCircle: SVGShapeElement {
    /// :nodoc:
    static let elementName = "circle"

    /**
     The circle's center point. Defaults to `CGRect.zero`
     */
    var circleCenter = CGPoint.zero

    /**
     The circle's radius. Defaults to `0`
     */
    var circleRadius: CGFloat = 0

    /// :nodoc:
    var svgLayer = CAShapeLayer()

    /// :nodoc:
    var supportedAttributes: [String: (String) -> Void] = [:]

    /**
     Function that parses the number string and sets this instance's radius
     */
    func radius(r: String) {
        guard let r = CGFloat(lengthString: r) else {
            return
        }
        circleRadius = r
    }

    /**
     Function that parses the number string and sets this instance's x center
     */
    func xCenter(x: String) {
        guard let x = CGFloat(lengthString: x) else {
            return
        }
        circleCenter.x = x
    }

    /**
     Function that parses the number string and sets this instance's y center
     */
    func yCenter(y: String) {
        guard let y = CGFloat(lengthString: y) else {
            return
        }
        circleCenter.y = y
    }

    /**
     Function that is called after the circle's center and radius have been parsed and set. This function creates the path and sets the internal `SVGLayer`'s path.
     */
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container else {
            return
        }
        #if os(iOS) || os(tvOS)
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        #elseif os(OSX)
        let circleRect = CGRect(x: circleCenter.x - circleRadius, y: circleCenter.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        let circlePath = NSBezierPath(ovalIn: circleRect)
        #endif
        svgLayer.path = circlePath.cgPath()
        container.containerLayer.addSublayer(svgLayer)
    }
}
