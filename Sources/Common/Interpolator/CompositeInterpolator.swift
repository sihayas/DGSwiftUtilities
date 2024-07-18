//
//  CompositeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/18/24.
//

import Foundation


public struct CompositeInterpolator<T: CompositeInterpolatable>: Interpolator {

  public var inputValueStart: CGFloat;
  public var inputValueEnd: CGFloat;
  
  public var outputValueStart: T;
  public var outputValueEnd: T;
  
  public var hasCustomInputRange = false;
  public var easingMap: T.EasingKeyPathMap = [:];
  
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
    valueStart: InterpolatableValue,
    valueEnd: InterpolatableValue,
    easingMap: T.EasingKeyPathMap
  ) {

    self.init(valueStart: valueStart, valueEnd: valueEnd);
    self.easingMap = easingMap;
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: InterpolatableValue,
    outputValueEnd: InterpolatableValue,
    easingMap: T.EasingKeyPathMap
  ) {
    
    self.init(
      inputValueStart: inputValueStart,
      inputValueEnd: inputValueEnd,
      outputValueStart: outputValueStart,
      outputValueEnd: outputValueEnd
    );
    
    self.easingMap = easingMap;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func interpolate(
    percent: CGFloat,
    easingMapOverride: T.EasingKeyPathMap? = nil
  ) -> T {
  
    if self.hasCustomInputRange {
      return T.interpolate(
        relativePercent: percent,
        inputValueStart: self.inputValueStart,
        inputValueEnd: self.inputValueEnd,
        outputValueStart: self.outputValueStart,
        outputValueEnd: self.outputValueEnd,
        easingMap: easingMapOverride ?? self.easingMap
      );
    };
  
    return T.lerp(
      valueStart: self.outputValueStart,
      valueEnd: self.outputValueEnd,
      percent: percent,
      easingMap: easingMapOverride ?? self.easingMap
    );
  };
  
  public func interpolate(
    inputValue: CGFloat,
    easingOverride: InterpolationEasing? = nil,
    easingMapOverride: T.EasingKeyPathMap? = nil
  ) -> T {
  
    return T.interpolate(
      inputValue: inputValue,
      inputValueStart: self.inputValueStart,
      inputValueEnd: self.inputValueEnd,
      outputValueStart: self.outputValueStart,
      outputValueEnd: self.outputValueEnd,
      easingMap: easingMapOverride ?? self.easingMap
    );
  };
};
