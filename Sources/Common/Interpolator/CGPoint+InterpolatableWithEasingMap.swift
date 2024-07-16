//
//  CGPoint+InterpolatableWithEasingMap.swift
//
//
//  Created by Dominic Go on 7/17/24.
//

import Foundation
import CoreGraphics


extension CGPoint: InterpolatableWithEasingMap {
  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.x: CGFloat.self,
    \.y: CGFloat.self,
  ];
};
