// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-memory-iterator-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Memory Iterator Primitives",
            targets: ["Memory Iterator Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-memory-primitives"),
        .package(path: "../swift-iterator-primitives"),
    ],
    targets: [
        .target(
            name: "Memory Iterator Primitives",
            dependencies: [
                .product(name: "Memory Contiguous Primitives", package: "swift-memory-primitives"),
                .product(name: "Iterator Primitive", package: "swift-iterator-primitives"),
                .product(name: "Iterable", package: "swift-iterator-primitives"),
                .product(name: "Iterator Chunk Primitives", package: "swift-iterator-primitives"),
            ]
        ),
        .testTarget(
            name: "Memory Iterator Primitives Tests",
            dependencies: ["Memory Iterator Primitives"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
