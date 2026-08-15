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
    ),
    .plugin(
      name: "JExtractSwiftPlugin",
      targets: ["JExtractSwiftPlugin"]
    ),
  ],
  traits: [
    .trait(name: "AndroidCoreLibraryDesugaring")
  ],
  dependencies: [
    .package(path: "../swift-java-jni-core"),
    .package(path: "../swift-syntax"),
    .package(path: "../swift-argument-parser"),
    .package(url: "https://github.com/apple/swift-system.git", branch: "nucleus"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.6.4"),
    .package(
      url: "https://github.com/nucleus-os/swift-subprocess.git",
      branch: "nucleus-local-swift-system",
      traits: ["SubprocessFoundation"]
    ),
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
      dependencies: ["SwiftJava"],
      exclude: ["swift-java.config"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .target(
      name: "JavaUtil",
      dependencies: ["SwiftJava"],
      path: "Sources/JavaStdlib/JavaUtil",
      exclude: ["swift-java.config"],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "JavaUtilJar",
      dependencies: ["SwiftJava", "JavaUtil"],
      path: "Sources/JavaStdlib/JavaUtilJar",
      exclude: ["swift-java.config"],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "JavaNet",
      dependencies: ["SwiftJava", "JavaUtil"],
      path: "Sources/JavaStdlib/JavaNet",
      exclude: ["swift-java.config"],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "JavaLangReflect",
      dependencies: ["SwiftJava", "JavaUtil"],
      path: "Sources/JavaStdlib/JavaLangReflect",
      exclude: ["swift-java.config"],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "SwiftExtractConfigurationShared"
    ),
    .target(
      name: "SwiftJavaConfigurationShared",
      dependencies: ["SwiftExtractConfigurationShared"]
    ),
    .target(
      name: "SwiftJavaShared"
    ),
    .target(
      name: "CodePrinting",
      dependencies: ["SwiftJavaConfigurationShared"]
    ),
    .target(
      name: "SwiftJavaToolLib",
      dependencies: [
        .product(name: "Logging", package: "swift-log"),
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        "SwiftJava",
        "JavaUtilJar",
        "JavaLangReflect",
        "JavaNet",
        "SwiftJavaShared",
        "SwiftJavaConfigurationShared",
        "CodePrinting",
        .product(name: "Subprocess", package: "swift-subprocess"),
      ],
      swiftSettings: [
        .swiftLanguageMode(.v5),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
      ]
    ),
    .executableTarget(
      name: "swift-java",
      dependencies: [
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "SystemPackage", package: "swift-system"),
        "SwiftJava",
        "JavaUtilJar",
        "JavaNet",
        "SwiftJavaToolLib",
        "JExtractSwiftLib",
        "SwiftJavaShared",
        "SwiftJavaConfigurationShared",
      ],
      path: "Sources/SwiftJavaTool",
      swiftSettings: [
        .swiftLanguageMode(.v5),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .define(
          "SYSTEM_PACKAGE_DARWIN",
          .when(platforms: [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS, .visionOS])
        ),
        .define("SYSTEM_PACKAGE"),
      ]
    ),
    .target(
      name: "SwiftExtract",
      dependencies: [
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftIfConfig", package: "swift-syntax"),
        .product(name: "SwiftLexicalLookup", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "Logging", package: "swift-log"),
        "SwiftExtractConfigurationShared",
      ],
      path: "Sources/SwiftExtract",
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "JExtractSwiftLib",
      dependencies: [
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftLexicalLookup", package: "swift-syntax"),
        .product(name: "SwiftIfConfig", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "SwiftJavaJNICore", package: "swift-java-jni-core"),
        "SwiftExtract",
        "SwiftJavaShared",
        "SwiftJavaConfigurationShared",
        "CodePrinting",
      ],
      swiftSettings: [
        .swiftLanguageMode(.v5),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
      ]
    ),
    .plugin(
      name: "JExtractSwiftPlugin",
      capability: .buildTool(),
      dependencies: ["swift-java"]
    ),
  ]
)
