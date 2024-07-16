//
//  CGRect+InterpolatableWithEasingMap.swift
//
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation
import CoreGraphics


extension CGRect: InterpolatableWithEasingMap {
  public static var interpolatableProperties: [PartialKeyPath<Self>] = [
    \.size.width,
    \.size.height,
    \.origin.x,
    \.origin.y,
  ];
};
