//
//  UIUserInterfaceStyle+CaseIterable.swift
//
//
//  Created by Dominic Go on 12/17/23.
//

import UIKit


extension UIUserInterfaceStyle: CaseIterable {
  
  public static var allCases: [Self] {
    [
      .unspecified,
      .light,
      .dark,
    ];
  };
};

