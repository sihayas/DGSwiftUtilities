//
//  UniformInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct UniformInterpolator<T: UniformInterpolatable> {

  public var inputValueStart: CGFloat = 0;
  public var inputValueEnd: CGFloat = 1;
  
  public var outputValueStart: T;
  public var outputValueEnd: T;
  
  public var easing: InterpolationEasing;
  
  public var shouldClampLeft: Bool = false;
  public var shouldClampRight: Bool = false;
  
  private var _hasCustomInputRange = false;
  
  // MARK: - Init
  // ------------
  
  public init(
    valueStart: T,
    valueEnd: T,
    easing: InterpolationEasing = .linear,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    self.easing = easing;
    self.shouldClampLeft = shouldClampLeft;
    self.shouldClampRight = shouldClampRight;
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T,
    outputValueEnd: T,
    easing: InterpolationEasing = .linear,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
    self.inputValueStart = inputValueStart;
    self.inputValueEnd = inputValueEnd;
    self.outputValueStart = outputValueStart;
    self.outputValueEnd = outputValueEnd;
    self.easing = easing;
    self.shouldClampLeft = shouldClampLeft;
    self.shouldClampRight = shouldClampRight;
    
    self._hasCustomInputRange = true;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func interpolate(
    percent: CGFloat,
    easingOverride: InterpolationEasing? = nil,
    shouldClampLeftOverride: Bool? = nil,
    shouldClampRightOverride: Bool? = nil
  ) -> T {
  
    if self._hasCustomInputRange {
      return T.interpolate(
        relativePercent: percent,
        inputValueStart: inputValueStart,
        inputValueEnd: inputValueEnd,
        outputValueStart: outputValueStart,
        outputValueEnd: outputValueEnd,
        easing: easingOverride ?? self.easing,
        shouldClampLeft: shouldClampLeftOverride ?? self.shouldClampLeft,
        shouldClampRight: shouldClampRightOverride ?? self.shouldClampRight
      );
    };
    
    return T.lerp(
      valueStart: self.outputValueStart,
      valueEnd: self.outputValueEnd,
      percent: percent,
      easing: easingOverride ?? self.easing,
      shouldClampLeft: shouldClampLeftOverride ?? self.shouldClampLeft,
      shouldClampRight: shouldClampRightOverride ?? self.shouldClampRight
    );
  };
  
  public func interpolate(
    inputValue: CGFloat,
    easingOverride: InterpolationEasing? = nil,
    shouldClampLeftOverride: Bool? = nil,
    shouldClampRightOverride: Bool? = nil
  ) -> T {
  
    return T.interpolate(
      inputValue: inputValue,
      inputValueStart: self.inputValueStart,
      inputValueEnd: self.inputValueEnd,
      outputValueStart: self.outputValueStart,
      outputValueEnd: self.outputValueEnd,
      easing: easingOverride ?? self.easing,
      shouldClampLeft: shouldClampLeftOverride ?? self.shouldClampLeft,
      shouldClampRight: shouldClampRightOverride ?? self.shouldClampRight
    );
  };
};

