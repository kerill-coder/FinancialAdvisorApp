// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FinancialAdvisorApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FinancialAdvisorApp",
            targets: ["Core", "UI"]
        ),
        .executable(
            name: "AdvisorApp",
            targets: ["AdvisorApp"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "UI",
            dependencies: ["Core"]
        ),
        .target(
            name: "AdvisorApp",
            dependencies: ["Core", "UI"]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        ),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]
        )
    ]
)