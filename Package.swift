// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Models",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Models",
            targets: ["Models", "ViewModels"]),
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: []),
        .target(
            name: "ViewModels",
            dependencies: ["Models"]),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models", "ViewModels"]),
    ]
)