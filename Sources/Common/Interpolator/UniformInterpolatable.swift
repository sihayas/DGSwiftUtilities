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
    easing: InterpolationEasing? = nil,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) -> Self {

    let inputValueAdj   = inputValue    - inputValueStart;
    let inputRangeDelta = inputValueEnd - inputValueStart;

    let progressRaw = inputValueAdj / inputRangeDelta;
    let progress = progressRaw.isFinite ? progressRaw : 0;
    
    let progressClamped = progress.clamped(
      min: shouldClampLeft  ? inputValueStart : nil,
      max: shouldClampRight ? inputValueEnd   : nil
    );
          
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : progressClamped,
      easing    : easing
    );
  };
  
  static func interpolate(
    relativePercent: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: Self,
    outputValueEnd: Self,
    easing: InterpolationEasing? = nil,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) -> Self {
    
    let rangeDelta = abs(inputValueStart - inputValueEnd);
    let inputValue = rangeDelta * relativePercent;
    
    let percentRaw = inputValue / rangeDelta;
    let percent = percentRaw.isFinite ? percentRaw : 0;
    
    let percentClamped = percent.clamped(
      min: shouldClampLeft  ? 0 : nil,
      max: shouldClampRight ? 1 : nil
    );
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : percentClamped,
      easing    : easing
    );
  };
};

