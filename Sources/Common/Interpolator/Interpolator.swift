//
//  Interpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct Interpolator<T: UniformInterpolatable>  {

  public let inputValueStart: CGFloat;
  public let inputValueEnd: CGFloat;
  
  public var outputValueStart: T;
  public var outputValueEnd: T;
  
  private let interpolatorPercent: (_ self: Self, _ percent   : CGFloat) -> T;
  private let interpolatorValue  : (_ self: Self, _ inputValue: CGFloat) -> T;
  
  // MARK: - Init - UniformInterpolatable
  // ------------------------------------
  
  public init(
    valueStart: T,
    valueEnd: T,
    easing: InterpolationEasing? = nil,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
  
    self.inputValueStart = 0;
    self.inputValueEnd = 1;
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    
    self.interpolatorPercent = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easing: easing,
        shouldClampLeft: shouldClampLeft,
        shouldClampRight: shouldClampRight
      );
    };
    
    self.interpolatorValue = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easing: easing,
        shouldClampLeft: shouldClampLeft,
        shouldClampRight: shouldClampRight
      );
    };
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T,
    outputValueEnd: T,
    easing: InterpolationEasing? = nil,
    shouldClampLeft: Bool = false,
    shouldClampRight: Bool = false
  ) {
  
    self.inputValueStart = inputValueStart
    self.inputValueEnd = inputValueEnd
    self.outputValueStart = outputValueStart
    self.outputValueEnd = outputValueEnd
    
    self.interpolatorPercent = {
      T.interpolate(
        relativePercent: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easing: easing,
        shouldClampLeft: shouldClampLeft,
        shouldClampRight: shouldClampRight
      );
    };
    
    self.interpolatorValue = {
      T.interpolate(
        inputValue: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easing: easing,
        shouldClampLeft: shouldClampLeft,
        shouldClampRight: shouldClampRight
      );
    };
  };
  
  // MARK: - Init - CompositeInterpolatable
  // --------------------------------------
  
  public init(
    valueStart: T,
    valueEnd: T,
    easingMap: T.EasingKeyPathMap = [:] // TODO: Impl. clamping config
  ) where T: CompositeInterpolatable  {
    
    self.inputValueStart = 0;
    self.inputValueEnd = 1;
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    
    self.interpolatorPercent = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easingMap: easingMap
      );
    };
    
    self.interpolatorValue = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easingMap: easingMap
      );
    };
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T,
    outputValueEnd: T,
    easingMap: T.EasingKeyPathMap = [:] // TODO: Impl. clamping config
  ) where T: CompositeInterpolatable {
  
    self.inputValueStart = inputValueStart
    self.inputValueEnd = inputValueEnd
    self.outputValueStart = outputValueStart
    self.outputValueEnd = outputValueEnd
    
    self.interpolatorPercent = {
      T.interpolate(
        relativePercent: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easingMap: easingMap
      );
    };
    
    self.interpolatorValue = {
      T.interpolate(
        inputValue: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easingMap: easingMap
      );
    };
  };
  
  // MARK: - Functions
  // -----------------
  
  public func interpolate(percent: CGFloat) -> T {
    self.interpolatorPercent(self, percent);
  };
  
  public func interpolate(inputValue: CGFloat) -> T {
    self.interpolatorValue(self, inputValue);
  };
};
