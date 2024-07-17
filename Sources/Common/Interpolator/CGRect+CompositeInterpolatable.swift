//
//  CGRect+CompositeInterpolatable.swift
//
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation
import CoreGraphics


extension CGRect: CompositeInterpolatable {

  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.size: CGSize.self,
    \.origin: CGPoint.self,
  ];
};
