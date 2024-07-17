//
//  CGSize+CompositeInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/17/24.
//

import Foundation
import CoreGraphics

extension CGSize: CompositeInterpolatable {
  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.width: CGFloat.self,
    \.height: CGFloat.self,
  ];
};
