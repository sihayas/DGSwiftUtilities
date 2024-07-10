//
//  Interpolator+StaticHelpers.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation

public extension Interpolator {

  static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat
  ) -> CGFloat {
  
    let valueDelta = valueEnd - valueStart;
    let valueProgress = valueDelta * percent
    let result = valueStart + valueProgress;
    return result;
  };

  static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat,
    easingFunction: (CGFloat) -> CGFloat
  ) -> CGFloat {
  
    let percentWithEasing = easingFunction(percent);
    return lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percentWithEasing
    );
  };
  
  static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat,
    easing: InterpolationEasing
  ) -> CGFloat {
  
    let percentWithEasing = easing.compute(inputValue: percent);
    return lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percentWithEasing
    );
  };
};
