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
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3")),
        .package(url: "https://gitee.com/cellgit/Result.git", from: "5.0.0")
//        .package(url: "https://github.com/antitypical/Result.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "BearSdk",
            dependencies: ["Alamofire", "Moya", "Result"]
        ),
        .testTarget(
            name: "BearSdkTests",
            dependencies: ["BearSdk"]
        )
    ]
)
