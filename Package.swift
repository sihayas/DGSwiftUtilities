// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DGSwiftUtilities",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "DGSwiftUtilities",
      targets: ["DGSwiftUtilities"]
    ),
  ],
  dependencies: [],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "DGSwiftUtilities",
      path: "Sources",
      linkerSettings: [
				.linkedFramework("UIKit"),
			]
    ),
  ]
)
