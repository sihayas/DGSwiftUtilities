//
//  Route.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit

enum Route: String, CaseIterable {

  static let rootRoute: Self = .Test01;
  
  static var rootRouteIndex: Int {
    let match = Self.allCases.enumerated().first {
      $0.element == Self.rootRoute;
    };
    
    return match?.offset ?? 0;
  };

  case Test01;
  
  var viewController: UIViewController {
    switch self {
      case .Test01:
        return Test01ViewController();
    };
  };
};

