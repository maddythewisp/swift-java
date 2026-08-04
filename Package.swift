// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-java",
  platforms: [
    .macOS("27")
  ],
  products: [
    .library(
      name: "SwiftJava",
      type: .dynamic,
      targets: ["SwiftJava", "SwiftJavaRuntimeSupport"]
    )
  ],
  dependencies: [
    .package(path: "../swift-java-jni-core"),
    .package(path: "../swift-syntax"),
  ],
  targets: [
    .macro(
      name: "SwiftJavaMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .target(
      name: "SwiftJava",
      dependencies: [
        .product(name: "SwiftJavaJNICore", package: "swift-java-jni-core"),
        "SwiftJavaMacros",
      ],
      exclude: ["swift-java.config"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .target(
      name: "SwiftJavaRuntimeSupport",
      dependencies: [
        "SwiftJava"
      ],
      exclude: ["swift-java.config"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
  ]
)
