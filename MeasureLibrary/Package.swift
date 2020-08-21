// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeasureLibrary",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MeasureLibrary",
            targets: ["MeasureLibrary"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MeasureLibrary",
            dependencies: []),
        .testTarget(
            name: "MeasureLibraryTests",
            dependencies: ["MeasureLibrary"]),
    ]
)
