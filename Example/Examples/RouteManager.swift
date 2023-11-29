//
//  RouteManager.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit

var RouteManagerShared = RouteManager.sharedInstance;

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var routes: [Route] = .Element.allCases;
  
  var routeCounter = Route.rootRouteIndex;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    guard let window = self.window else { return };
  
    let nextVC = self.currentRoute.viewController;
    window.rootViewController = nextVC;
  };
};
