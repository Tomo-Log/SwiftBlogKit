// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftBlogKit",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"), //MySQL
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"), // Leaf
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"), //Auth
        
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),//Commands
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Authentication", "Leaf", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

