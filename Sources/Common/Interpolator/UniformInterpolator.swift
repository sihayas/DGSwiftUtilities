//
//  UniformInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct UniformInterpolator<T: UniformInterpolatable>: Interpolator {
  
  public var inputValueStart: CGFloat;
  public var inputValueEnd: CGFloat;
  
  public var outputValueStart: T;
  public var outputValueEnd: T;
  
  public var hasCustomInputRange: Bool;
  
  public var easing: InterpolationEasing? = nil;
  
  public var shouldClampLeft: Bool = false;
  public var shouldClampRight: Bool = false;
  
  // MARK: - Init
  // ------------
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T,
    outputValueEnd: T,
    hasCustomInputRange: Bool
  ) {
    self.inputValueStart = inputValueStart;
    self.inputValueEnd = inputValueEnd;
    self.outputValueStart = outputValueStart;
    self.outputValueEnd = outputValueEnd;
    self.hasCustomInputRange = hasCustomInputRange;
  };
  
  public init(
    valueStart: T,
    valueEnd: T,
    easing: InterpolationEasing,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
    self.init(valueStart: valueStart, valueEnd: valueEnd);
    
    self.easing = easing;
    self.shouldClampLeft = shouldClampLeft;
    self.shouldClampRight = shouldClampRight;
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T,
    outputValueEnd: T,
    easing: InterpolationEasing,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
    
    self.init(
      inputValueStart: inputValueStart,
      inputValueEnd: inputValueEnd,
      outputValueStart: outputValueStart,
      outputValueEnd: outputValueEnd
    );
  
    self.easing = easing;
    self.shouldClampLeft = shouldClampLeft;
    self.shouldClampRight = shouldClampRight;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func interpolate(
    percent: CGFloat,
    easingOverride: InterpolationEasing? = nil,
    shouldClampLeftOverride: Bool? = nil,
    shouldClampRightOverride: Bool? = nil
  ) -> T {
    
    self.interpolate(
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
  
    return self.interpolate(
      inputValue: inputValue,
      easing: easingOverride ?? self.easing,
      shouldClampLeft: shouldClampLeftOverride ?? self.shouldClampLeft,
      shouldClampRight: shouldClampRightOverride ?? self.shouldClampRight
    );
  };
};

