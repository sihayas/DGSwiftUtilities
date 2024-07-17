//
//  UniformInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


public protocol UniformInterpolatable: Comparable {

  init();
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> Self;
};

public extension UniformInterpolatable {

  typealias Interpolator = DGSwiftUtilities.Interpolator<Self>;

  typealias RangeInterpolator = DGSwiftUtilities.RangeInterpolator<Self>;
  
  static func interpolate(
    inputValue: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: Self,
    outputValueEnd: Self,
    easing: InterpolationEasing? = nil
  ) -> Self {

    let inputValueAdj   = inputValue    - inputValueStart;
    let inputRangeDelta = inputValueEnd - inputValueStart;

    let progressRaw = inputValueAdj / inputRangeDelta;
    let progress = progressRaw.isFinite ? progressRaw : 0;
          
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : progress,
      easing    : easing
    );
  };
  
  static func interpolate(
    relativePercent: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: Self,
    outputValueEnd: Self,
    easing: InterpolationEasing? = nil
  ) -> Self {
    
    let rangeDelta = abs(inputValueStart - inputValueEnd);
    let inputValue = rangeDelta * relativePercent;
    
    let percentRaw = inputValue / rangeDelta;
    let percent = percentRaw.isFinite ? percentRaw : 0;
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : percent,
      easing    : easing
    );
  };
};

