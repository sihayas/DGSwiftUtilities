//
//  Interpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation

public struct Interpolator {
  
  public var inputValueStart: CGFloat = 0;
  public var inputValueEnd: CGFloat = 1;
  
  public var outputValueStart: CGFloat;
  public var outputValueEnd: CGFloat;
  
  public var easing: InterpolationEasing;
  private var _hasCustomInputRange = false;
  
  // MARK: - Init
  // ------------
  
  public init(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    easing: InterpolationEasing = .linear
  ) {
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    self.easing = easing;
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: CGFloat,
    outputValueEnd: CGFloat,
    easing: InterpolationEasing = .linear
  ) {
    self.inputValueStart = inputValueStart;
    self.inputValueEnd = inputValueEnd;
    self.outputValueStart = outputValueStart;
    self.outputValueEnd = outputValueEnd;
    self.easing = easing;
    
    self._hasCustomInputRange = true;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func interpolate(
    percent: CGFloat,
    easingOverride: InterpolationEasing? = nil
  ) -> CGFloat {
  
    if self._hasCustomInputRange {
      return RangeInterpolator.interpolate(
        relativePercent: percent,
        inputValueStart: inputValueStart,
        inputValueEnd: inputValueEnd,
        outputValueStart: outputValueStart,
        outputValueEnd: outputValueEnd,
        easing: easingOverride ?? self.easing
      );
    };
    
    return Self.lerp(
      valueStart: self.outputValueStart,
      valueEnd: self.outputValueEnd,
      percent: percent,
      easing: easingOverride ?? self.easing
    );
  };
  
  public func interpolate(
    inputValue: CGFloat,
    easingOverride: InterpolationEasing? = nil
  ) -> CGFloat {
  
    return RangeInterpolator.interpolate(
      inputValue: inputValue,
      inputValueStart: self.inputValueStart,
      inputValueEnd: self.inputValueEnd,
      outputValueStart: self.outputValueStart,
      outputValueEnd: self.outputValueEnd,
      easing: easingOverride ?? self.easing
    );
  };
};

