//
//  SVGEllipse.swift
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
 Concrete implementation that creates a `CAShapeLayer` from a `<ellipse>` element and its attributes
 */
final class SVGEllipse: SVGShapeElement {
    /// :nodoc:
    static let elementName = "ellipse"

    /**
     The ellipse's center point. Defaults to `CGRect.zero`
     */
    var ellipseCenter = CGPoint.zero

    /**
     The ellipse's x radius. Defaults to `CGRect.zero`
     */
    var xRadius: CGFloat = 0

    /**
     The ellipse's x radius. Defaults to `CGRect.zero`
     */
    var yRadius: CGFloat = 0

    /// :nodoc:
    var svgLayer = CAShapeLayer()

    /// :nodoc:
    var supportedAttributes: [String: (String) -> Void] = [:]

    /**
     Function that parses the number string and sets this instance's x radius
     */
    func xRadius(r: String) {
        guard let r = CGFloat(lengthString: r) else {
            return
        }
        xRadius = r
    }

    /**
     Function that parses the number string and sets this instance's y radius
     */
    func yRadius(r: String) {
        guard let r = CGFloat(lengthString: r) else {
            return
        }
        yRadius = r
    }

    /**
     Function that parses the number string and sets this instance's x center
     */
    func xCenter(x: String) {
        guard let x = CGFloat(lengthString: x) else {
            return
        }
        ellipseCenter.x = x
    }

    /**
     Function that parses the number string and sets this instance's y center
     */
    func yCenter(y: String) {
        guard let y = CGFloat(lengthString: y) else {
            return
        }
        ellipseCenter.y = y
    }

    /**
     Function that is called after the ellipse's center and radius have been parsed and set. This function creates the path and sets the internal `SVGLayer`'s path.
     */
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container else {
            return
        }
        let ellipseRect = CGRect(x: ellipseCenter.x - xRadius, y: ellipseCenter.y - yRadius, width: 2 * xRadius, height: 2 * yRadius)
        let circlePath = UIBezierPath(ovalIn: ellipseRect)
        svgLayer.path = circlePath.cgPath()
        container.containerLayer.addSublayer(svgLayer)
    }
    }
