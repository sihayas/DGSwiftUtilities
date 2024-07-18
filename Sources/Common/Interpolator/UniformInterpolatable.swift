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

  typealias Interpolator = DGSwiftUtilities.UniformInterpolator<Self>;

  typealias RangeInterpolator = DGSwiftUtilities.RangeInterpolator<Self>;
  
  // MARK: - Helper Functions
  // ------------------------
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easing: InterpolationEasing?,
    shouldClampLeft: Bool,
    shouldClampRight: Bool
  ) -> Self {
  
    let percentClamped = percent.clamped(
      min: shouldClampLeft  ? 0 : nil,
      max: shouldClampRight ? 1 : nil
    );
  
    return Self.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percentClamped,
      easing: easing
    );
  };
  
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
  
    let inputValueClamped = inputValue.clamped(
      min: shouldClampLeft  ? inputValueStart : nil,
      max: shouldClampRight ? inputValueEnd   : nil
    );

    let inputValueAdj   = inputValueClamped - inputValueStart;
    let inputRangeDelta = inputValueEnd     - inputValueStart;

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
    easing: InterpolationEasing? = nil,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) -> Self {
    
    let rangeDelta = abs(inputValueStart - inputValueEnd);
    let inputValue = rangeDelta * relativePercent;
    
    let inputValueClamped = inputValue.clamped(
      min: shouldClampLeft  ? inputValueStart : nil,
      max: shouldClampRight ? inputValueEnd   : nil
    );
    
    let percentRaw = inputValueClamped / rangeDelta;
    let percent = percentRaw.isFinite ? percentRaw : 0;
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : percent,
      easing    : easing
    );
  };
};

