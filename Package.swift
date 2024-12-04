// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BearSdk",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "BearSdk",
            targets: ["BearSdk"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.4")
    ],
    targets: [
        .target(
            name: "BearSdk",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "BearSdkTests",
            dependencies: ["BearSdk"]
        )
    ]
)
