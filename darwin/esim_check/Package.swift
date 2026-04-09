// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "esim_check",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "esim-check", targets: ["esim_check"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "esim_check",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
