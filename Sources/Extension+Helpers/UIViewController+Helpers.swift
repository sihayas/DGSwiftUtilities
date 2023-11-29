//
//  UIViewController+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/22.
//

import UIKit

public extension UIViewController {

  // MARK: - Functions
  // -----------------

  func attachChildVC(
    _ child: UIViewController,
    toView targetView: UIView? = nil
  ) {
  
    self.addChild(child);
    
    let targetView = targetView ?? self.view;
    targetView?.addSubview(child.view);
    
    child.didMove(toParent: self);
  };

  func detachFromParentVC() {
    guard self.parent != nil else { return };

    self.willMove(toParent: nil);
    self.view.removeFromSuperview();
    self.removeFromParent();
  };
};
