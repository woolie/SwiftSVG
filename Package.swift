// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SwiftSVG",
    platforms: [.macOS(.v14), .iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftSVG",
            dependencies: [],
            path: "SwiftSVG"
        ),
        .testTarget(
            name: "SwiftSVGTests",
            dependencies: ["SwiftSVG"],
            path: "SwiftSVGTests",
			resources: [.copy("TestFiles")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
