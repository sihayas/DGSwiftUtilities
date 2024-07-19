//
//  Interpolator.swift
//  
//
//  Created by Dominic Go on 7/18/24.
//

import Foundation






public protocol Interpolator {
  
  associatedtype InterpolatableValue: UniformInterpolatable;
  
  var inputValueStart: CGFloat { get };
  var inputValueEnd: CGFloat { get };
  
  var outputValueStart: InterpolatableValue { get };
  var outputValueEnd: InterpolatableValue { get };
  
  var hasCustomInputRange: Bool { get };
  
  init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: InterpolatableValue,
    outputValueEnd: InterpolatableValue,
    hasCustomInputRange: Bool
  );
};

public extension Interpolator {

  init(
    valueStart: InterpolatableValue,
    valueEnd: InterpolatableValue
  ) {

    self.init(
      inputValueStart: 0,
      inputValueEnd: 1,
      outputValueStart: valueStart,
      outputValueEnd: valueEnd,
      hasCustomInputRange: false
    );
  };

  init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: InterpolatableValue,
    outputValueEnd: InterpolatableValue
  ) {
  
    self.init(
      inputValueStart: inputValueStart,
      inputValueEnd: inputValueEnd,
      outputValueStart: outputValueStart,
      outputValueEnd: outputValueEnd,
      hasCustomInputRange: true
    );
  };
  
  func interpolate(
    percent: CGFloat,
    easing: InterpolationEasing?,
    shouldClampLeft: Bool,
    shouldClampRight: Bool
  ) -> InterpolatableValue {
  
    if self.hasCustomInputRange {
      return InterpolatableValue.interpolate(
        relativePercent: percent,
        inputValueStart: inputValueStart,
        inputValueEnd: inputValueEnd,
        outputValueStart: outputValueStart,
        outputValueEnd: outputValueEnd,
        easing: easing,
        shouldClampLeft: shouldClampLeft,
        shouldClampRight: shouldClampRight
      );
    };
    
    return InterpolatableValue.lerp(
      valueStart: self.outputValueStart,
      valueEnd: self.outputValueEnd,
      percent: percent,
      easing: easing,
      shouldClampLeft: shouldClampLeft,
      shouldClampRight: shouldClampRight
    );
  };
  
  func interpolate(
    inputValue: CGFloat,
    easing: InterpolationEasing?,
    shouldClampLeft: Bool,
    shouldClampRight: Bool
  ) -> InterpolatableValue {
  
    return InterpolatableValue.interpolate(
      inputValue: inputValue,
      inputValueStart: self.inputValueStart,
      inputValueEnd: self.inputValueEnd,
      outputValueStart: self.outputValueStart,
      outputValueEnd: self.outputValueEnd,
      easing: easing,
      shouldClampLeft: shouldClampLeft,
      shouldClampRight: shouldClampRight
    );
  };
};
