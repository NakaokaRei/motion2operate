// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "motion2operate-shared",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "motion2operate-shared",
            targets: ["motion2operate-shared"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "motion2operate-shared",
            dependencies: []),
        .testTarget(
            name: "motion2operate-sharedTests",
            dependencies: ["motion2operate-shared"]),
    ]
)
