// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "Networkstack",
    platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [
        .library(name: "NetworkStack", targets: ["NetworkStack"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.1.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.2")
    ],
    targets: [
      .target(
        name: "NetworkStack",
        dependencies: [
          .product(name: "Alamofire", package: "Alamofire"),
          "KeychainAccess",
          "RxSwift"
        ],
        path: "Sources"
      )
    ],
    swiftLanguageVersions: [.v4, .v5]
)
