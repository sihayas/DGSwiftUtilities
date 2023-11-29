//
//  Route.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit

enum Route: String, CaseIterable {
  
  static var allRoutes: [Self] {
    let toBeRemoved: [Self] = [
      .RouteListNavigator,
    ];
    
    return Self.allCases.filter {
      !toBeRemoved.contains($0)
    };
  };

  static let rootRoute: Self = .RouteListNavigator;
  
  static var rootRouteIndex: Int {
    let match = Self.allCases.enumerated().first {
      $0.element == Self.rootRoute;
    };
    
    return match?.offset ?? 0;
  };
  
  case RouteListNavigator;
  
  case RouteList;
  case Test01;
  
  var rawViewController: UIViewController {
    switch self {
      case .RouteListNavigator:
        let navigationController = UINavigationController();
        
        let rootVC = Self.RouteList.viewController;
        navigationController.viewControllers = [rootVC];
        
        return navigationController;
        
      case .RouteList:
        return RouteListViewController();
      
      case .Test01:
        return Test01ViewController();
    };
  };
  
  var viewController: UIViewController {
    let controller = self.rawViewController;
    controller.title = self.rawValue;
    return controller;
  };
};

