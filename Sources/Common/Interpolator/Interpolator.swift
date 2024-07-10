//
//  Interpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation

public struct Interpolator {
  
  public var valueStart: CGFloat;
  public var valueEnd: CGFloat;
  
  func lerp(
    percent: CGFloat,
    easing: InterpolationEasing? = nil
  ) -> CGFloat {
    
    if let easing = easing {
      return Self.lerp(
        valueStart: self.valueStart,
        valueEnd: self.valueEnd,
        percent: percent,
        easing: easing
      );
    };
    
    return Self.lerp(
      valueStart: self.valueStart,
      valueEnd: self.valueEnd,
      percent: percent
    );
  };
};

