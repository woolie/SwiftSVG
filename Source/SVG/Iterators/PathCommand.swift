//
//  PathCommand.swift
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

enum PathType {
    case absolute, relative
}

/**
 A protocol that describes an instance that can process an individual SVG Element
 */
protocol PathCommand: PreviousCommand {
    /**
     An array that stores processed coordinates values
     */
    var coordinateBuffer: [Double] { get set }

    /**
     The minimum number of coordinates needed to process the path command
     */
    var numberOfRequiredParameters: Int { get }

    /**
     The path type, relative or absolute
     */
    var pathType: PathType { get }

    /**
     Designated initializer that creates a relative or absolute `PathCommand`
     */
    init(pathType: PathType)

    /**
     Once the `numberOfRequiredParameters` has been met, this method will append new path to the passed path
     - Parameter path: The path to append a new path to
     - Parameter previousCommand: An optional previous command. Used primarily with the shortcut cubic and quadratic Bezier types
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand?)
}

/**
 A protocol that describes an instance that represents an SVGElement right before the current one
 */
protocol PreviousCommand {
    /**
     An array that stores processed coordinates values
     */
    var coordinateBuffer: [Double] { get }

    /**
     The path type, relative or absolute
     */
    var pathType: PathType { get }
}

extension PathCommand {
    /**
     Default implementation for any `PathCommand` indicating where there are enough coordinates stored to be able to process the `SVGElement`
     */
    var canPushCommand: Bool {
        if numberOfRequiredParameters == 0 {
            return true
        }
        if coordinateBuffer.isEmpty {
            return false
        }
        if coordinateBuffer.count % numberOfRequiredParameters == 0 {
            return true
        }
        return false
    }

    /**
     Function that clears the current number buffer
     */
    mutating func clearBuffer() {
        coordinateBuffer.removeAll()
    }

    /**
     Adds a new coordinate to the buffer
     */
    mutating func pushCoordinate(_ coordinate: Double) {
        coordinateBuffer.append(coordinate)
    }

    /**
     Based on the `PathType` of this PathCommand, this function returns the relative or absolute point
     */
    func pointForPathType(_ point: CGPoint, relativeTo: CGPoint) -> CGPoint {
        switch pathType {
        case .absolute:
            point
        case .relative:
            CGPoint(x: point.x + relativeTo.x, y: point.y + relativeTo.y)
        }
    }
}

/////////////////////////////////////////////////////
//
// MARK: - Implementations

/**
 The `PathCommand` that corresponds to the SVG `M` or `m` command
 */
struct MoveTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 2

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     This will move the current point to `CGPoint(coordinateBuffer[0], coordinateBuffer[1])`.

     Sequential MoveTo commands should be treated as LineTos.

     From Docs (https://www.w3.org/TR/SVG2/paths.html#PathDataMovetoCommands):

     ```
     Start a new sub-path at the given (x,y) coordinates. M (uppercase) indicates that absolute coordinates will follow; m (lowercase) indicates that relative coordinates will follow. If a moveto is followed by multiple pairs of coordinates, the subsequent pairs are treated as implicit lineto commands. Hence, implicit lineto commands will be relative if the moveto is relative, and absolute if the moveto is absolute.
     ```
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        if previousCommand is MoveTo {
            var implicitLineTo = LineTo(pathType: pathType)
            implicitLineTo.coordinateBuffer = [coordinateBuffer[0], coordinateBuffer[1]]
            implicitLineTo.execute(on: path)
            return
        }

		let relativePoint = if path.isEmpty {
			CGPointZero
		} else {
			path.currentPoint
		}
        let point = pointForPathType(CGPoint(x: coordinateBuffer[0],
											 y: coordinateBuffer[1]),
									 relativeTo: relativePoint)
        path.move(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `Z` or `z` command
 */
struct ClosePath: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 0

    /// :nodoc:
    var pathType: PathType = .absolute

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Closes the current path
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        path.close()
    }
}

/**
 The `PathCommand` that corresponds to the SVG `L` or `l` command
 */
struct LineTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 2

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Creates a line from the `path.currentPoint` to point `CGPoint(self.coordinateBuffer[0], coordinateBuffer[1])`
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = pointForPathType(CGPoint(x: coordinateBuffer[0], y: coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `H` or `h` command
 */
struct HorizontalLineTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 1

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Adds a horizontal line from the currentPoint to `CGPoint(self.coordinateBuffer[0], path.currentPoint.y)`
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let x = coordinateBuffer[0]
        let point = (pathType == .absolute ? CGPoint(x: CGFloat(x), y: path.currentPoint.y) : CGPoint(x: path.currentPoint.x + CGFloat(x), y: path.currentPoint.y))
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `V` or `v` command
 */
struct VerticalLineTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 1

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Adds a vertical line from the currentPoint to `CGPoint(path.currentPoint.y, self.coordinateBuffer[0])`
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let y = coordinateBuffer[0]
        let point = (pathType == .absolute ? CGPoint(x: path.currentPoint.x, y: CGFloat(y)) : CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + CGFloat(y)))
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `C` or `c` command
 */
struct CurveTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 6

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Adds a cubic Bezier curve to `path`. The path will end up at `CGPoint(self.coordinateBuffer[4], self.coordinateBuffer[5])`. The control point for `path.currentPoint` will be `CGPoint(self.coordinateBuffer[0], self.coordinateBuffer[1])`. Then controle point for the end point will be CGPoint(self.coordinateBuffer[2], self.coordinateBuffer[3])
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let startControl = pointForPathType(CGPoint(x: coordinateBuffer[0], y: coordinateBuffer[1]), relativeTo: path.currentPoint)
        let endControl = pointForPathType(CGPoint(x: coordinateBuffer[2], y: coordinateBuffer[3]), relativeTo: path.currentPoint)
        let point = pointForPathType(CGPoint(x: coordinateBuffer[4], y: coordinateBuffer[5]), relativeTo: path.currentPoint)
        path.addCurve(to: point, controlPoint1: startControl, controlPoint2: endControl)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `S` or `s` command
 */
struct SmoothCurveTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 4

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /**
     Shortcut cubic Bezier curve to that add a new path ending up at `CGPoint(self.coordinateBuffer[0], self.coordinateBuffer[1])` with a single control point in the middle.
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = pointForPathType(CGPoint(x: coordinateBuffer[2], y: coordinateBuffer[3]), relativeTo: path.currentPoint)
        let controlEnd = pointForPathType(CGPoint(x: coordinateBuffer[0], y: coordinateBuffer[1]), relativeTo: path.currentPoint)

        let controlStart: CGPoint
        if let previousCurveTo = previousCommand as? CurveTo  {
            switch previousCurveTo.pathType {
            case .absolute:
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousCurveTo.coordinateBuffer[2],
                    y: Double(2.0 * path.currentPoint.y) - previousCurveTo.coordinateBuffer[3]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousCurveTo.coordinateBuffer[4],
                    Double(path.currentPoint.y) - previousCurveTo.coordinateBuffer[5]
                )
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - (previousCurveTo.coordinateBuffer[2] + oldCurrentPoint.0),
                    y: Double(2.0 * path.currentPoint.y) - (previousCurveTo.coordinateBuffer[3] + oldCurrentPoint.1)
                )
            }
        } else if let previousSmoothCurveTo = previousCommand as? SmoothCurveTo {
            switch previousSmoothCurveTo.pathType {
            case .absolute:
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousSmoothCurveTo.coordinateBuffer[0],
                    y: Double(2.0 * path.currentPoint.y) - previousSmoothCurveTo.coordinateBuffer[1]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousSmoothCurveTo.coordinateBuffer[2],
                    Double(path.currentPoint.y) - previousSmoothCurveTo.coordinateBuffer[3]
                )
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - (previousSmoothCurveTo.coordinateBuffer[0] + oldCurrentPoint.0),
                    y: Double(2.0 * path.currentPoint.y) - (previousSmoothCurveTo.coordinateBuffer[1] + oldCurrentPoint.1)
                )
            }
        } else {
            controlStart = path.currentPoint
        }
        path.addCurve(to: point, controlPoint1: controlStart, controlPoint2: controlEnd)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `Q` or `q` command
 */
struct QuadraticCurveTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 4

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let controlPoint = pointForPathType(CGPoint(x: coordinateBuffer[0], y: coordinateBuffer[1]), relativeTo: path.currentPoint)
        let point = pointForPathType(CGPoint(x: coordinateBuffer[2], y: coordinateBuffer[3]), relativeTo: path.currentPoint)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `T` or `t` command
 */
struct SmoothQuadraticCurveTo: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 2

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    var previousControlPoint: CGPoint?

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = pointForPathType(CGPoint(x: coordinateBuffer[0], y: coordinateBuffer[1]), relativeTo: path.currentPoint)

        var controlPoint: CGPoint
        if let previousQuadraticCurveTo = previousCommand as? QuadraticCurveTo  {
            switch previousQuadraticCurveTo.pathType {
            case .absolute:
                controlPoint = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[0],
                    y: Double(2.0 * path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[1]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[2],
                    Double(path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[3]
                )
                controlPoint = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[0] + oldCurrentPoint.0,
                    y: Double(2.0 * path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[1] + oldCurrentPoint.1
                )
            }
        } else {
            controlPoint = path.currentPoint
        }
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `A` or `a` command
 - TODO: Still needs an implementation
 */
struct EllipticalArc: PathCommand {
    /// :nodoc:
    var coordinateBuffer = [Double]()

    /// :nodoc:
    let numberOfRequiredParameters = 2

    /// :nodoc:
    let pathType: PathType

    /// :nodoc:
    init(pathType: PathType) {
        self.pathType = pathType
    }

    /// :nodoc:
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        assertionFailure("Needs Implementation")
    }
}
