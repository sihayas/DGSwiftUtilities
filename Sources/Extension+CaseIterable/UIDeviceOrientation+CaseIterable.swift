//
//  UIDeviceOrientation+CaseIterable.swift
//
//
//  Created by Dominic Go on 12/17/23.
//

import UIKit

extension UIDeviceOrientation: CaseIterable {
  public static var allCases: [Self] {
    [
      .unknown,
      .portrait,
      .portraitUpsideDown,
      .landscapeLeft,
      .landscapeRight,
      .faceUp,
      .faceDown,
    ]
  };
};
