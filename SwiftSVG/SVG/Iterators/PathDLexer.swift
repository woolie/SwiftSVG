//
//  PathDLexer.swift
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
 A struct that maps `<path>` d commands to `SVGElement`s
 */
enum PathDConstants {
    /**
     Valid path letters that can be used in the path d string
     */
    enum DCharacter: CChar {
        case A = 65
        case a = 97
        case C = 67
        case c = 99
        case H = 72
        case h = 104
        case L = 76
        case l = 108
        case M = 77
        case m = 109
        case Q = 81
        case q = 113
        case S = 83
        case s = 115
        case T = 84
        case t = 116
        case V = 86
        case v = 118
        case Z = 90
        case z = 122
        case comma = 44
        case sign = 45
        case space = 32
        case point = 46
    }

    /**
     A dictionary that generates a new `PathCommand` based on the `CChar` value of the SVG path letter
     */
    static let characterDictionary: [CChar: PathCommand] = [
        DCharacter.M.rawValue: MoveTo(pathType: .absolute),
        DCharacter.m.rawValue: MoveTo(pathType: .relative),
        DCharacter.C.rawValue: CurveTo(pathType: .absolute),
        DCharacter.c.rawValue: CurveTo(pathType: .relative),
        DCharacter.Z.rawValue: ClosePath(pathType: .absolute),
        DCharacter.z.rawValue: ClosePath(pathType: .absolute),
        DCharacter.S.rawValue: SmoothCurveTo(pathType: .absolute),
        DCharacter.s.rawValue: SmoothCurveTo(pathType: .relative),
        DCharacter.L.rawValue: LineTo(pathType: .absolute),
        DCharacter.l.rawValue: LineTo(pathType: .relative),
        DCharacter.H.rawValue: HorizontalLineTo(pathType: .absolute),
        DCharacter.h.rawValue: HorizontalLineTo(pathType: .relative),
        DCharacter.V.rawValue: VerticalLineTo(pathType: .absolute),
        DCharacter.v.rawValue: VerticalLineTo(pathType: .relative),
        DCharacter.Q.rawValue: QuadraticCurveTo(pathType: .absolute),
        DCharacter.q.rawValue: QuadraticCurveTo(pathType: .relative),
        DCharacter.T.rawValue: SmoothQuadraticCurveTo(pathType: .absolute),
        DCharacter.t.rawValue: SmoothQuadraticCurveTo(pathType: .relative),
    ]
    }

/**
 A struct that conforms to the `Sequence` protocol that takes a `<path>` `d` string and returns `SVGElement` instances
 */
struct PathDLexer: IteratorProtocol, Sequence {
    /**
     Generates a `PathCommand`
     */
    typealias Element = PathCommand

    /// :nodoc:
    private var currentCharacter: CChar {
        workingString[iteratorIndex]
    }

    /// :nodoc:
    private var currentCommand: PathCommand?

    /// :nodoc:
    private var iteratorIndex: Int = 0

    /// :nodoc:
    private var numberArray = [CChar]()

    /// :nodoc:
    private let pathString: String

    /// :nodoc:
    private let workingString: ContiguousArray<CChar>

    /**
     Initializer for creating a new `PathDLexer` from a path d string
     */
    init(pathString: String) {
        self.pathString = pathString
        workingString = self.pathString.utf8CString
    }

    /**
     Required by Swift's `IteratorProtocol` that returns a new `PathDLexer`
     */
    func makeIterator() -> PathDLexer {
        PathDLexer(pathString: pathString)
    }

    /**
     Required by Swift's `IteratorProtocol` that returns the next `PathCommand` or nil if it's at the end of the sequence
     */
    mutating func next() -> Element? {
        currentCommand?.clearBuffer()

        while iteratorIndex < workingString.count - 1 {
            if let command = PathDConstants.characterDictionary[currentCharacter] {
                pushCoordinateIfPossible(numberArray)
                iteratorIndex += 1

                if currentCommand != nil, currentCommand!.canPushCommand {
                    let returnCommand = currentCommand
                    currentCommand = command
                    return returnCommand
                } else {
                    currentCommand = command
                    numberArray.removeAll()
                }
            }

            switch currentCharacter {
            case PathDConstants.DCharacter.comma.rawValue, PathDConstants.DCharacter.space.rawValue:
                pushCoordinateIfPossible(numberArray)
                while currentCharacter == PathDConstants.DCharacter.space.rawValue || currentCharacter == PathDConstants.DCharacter.comma.rawValue, iteratorIndex < workingString.count {
                    iteratorIndex += 1
                }
                if currentCommand != nil, currentCommand!.canPushCommand {
                    numberArray.removeAll()
                    return currentCommand
                }

            case PathDConstants.DCharacter.sign.rawValue,
                PathDConstants.DCharacter.point.rawValue where numberArray.contains(PathDConstants.DCharacter.point.rawValue):
                pushCoordinateIfPossible(numberArray)
                if currentCommand != nil, currentCommand!.canPushCommand {
                    numberArray.removeAll()
                    numberArray.append(currentCharacter)
                    iteratorIndex += 1
                    return currentCommand
                }

            default:
                break
            }

            numberArray.append(currentCharacter)
            iteratorIndex += 1
        }
        if currentCommand != nil {
            pushCoordinateIfPossible(numberArray)
            let returnCommand = currentCommand
            currentCommand = nil
            return returnCommand
        }
        return nil
    }

    /**
     Adds a valid `Double` to the current `PathCommand` if possible
     */
    private mutating func pushCoordinateIfPossible(_ byteArray: [CChar]) {
        if byteArray.isEmpty {
            return
        }
        if let validCoordinate = Double(byteArray: byteArray) {
            currentCommand?.pushCoordinate(validCoordinate)
            numberArray.removeAll()
        }
    }
}
