let package = Package(
  name: "SwiftUtilities",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "SwiftUtilities",
      targets: ["SwiftUtilities"]
    ),
  ],
  dependencies: [],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "SwiftUtilities",
      path: "Sources",
      linkerSettings: [
				.linkedFramework("UIKit"),
			]
    ),
  ]
)
