//
//  CGFloat+Interpolatable.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


extension CGFloat: Interpolatable {

  public static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> Self {
    
    return InterpolatorHelpers.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easing: easing
    );
  };
};



