// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SwiftSVG",
    platforms: [.macOS(.v14), .iOS(.v15), .tvOS(.v15)],
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
            path: "Source"
        ),
        .testTarget(
            name: "SwiftSVGTests",
            dependencies: ["SwiftSVG"],
            path: "Tests",
			resources: [.copy("TestFiles")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
