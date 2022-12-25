// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let loadable: String = "Loadable"
let loadableCombine: String = "CombineLoadable"
let loadableRxSwift: String = "RxSwiftLoadable"
let uikitPreview: String = "UIKitPreview"

func testTargetName(fromTarget originalTarget: String) -> String {
    "\(originalTarget)Tests"
}

let package = Package(
    name: "HoJongUtility",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: loadable,
            type: .static,
            targets: [loadable]),
        .library(
            name: loadableCombine,
            type: .static,
            targets: [loadableCombine]),
        .library(
            name: loadableRxSwift,
            targets: [loadableRxSwift]),
        .library(
            name: uikitPreview,
            type: .static,
            targets: [uikitPreview])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.0.0")
    ],
    targets: [
        .target(
            name: loadable,
            dependencies: []),
        .target(
            name: loadableCombine,
            dependencies: [.init(stringLiteral: loadable)]),
        .target(
            name: loadableRxSwift,
            dependencies: [
                .init(stringLiteral: loadable),
                .product(name: "RxSwift", package: "RxSwift")
            ]),
        .target(name: uikitPreview)
    ]
)
