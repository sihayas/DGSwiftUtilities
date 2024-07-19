//
//  InterpolatorHelpers.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


public struct InterpolatorHelpers {

  public static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat
  ) -> CGFloat {
  
    let valueDelta = valueEnd - valueStart;
    let valueProgress = valueDelta * percent
    let result = valueStart + valueProgress;
    return result;
  };

  public static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat,
    easingFunction: (CGFloat) -> CGFloat
  ) -> CGFloat {
  
    let percentWithEasing = easingFunction(percent);
    return lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percentWithEasing
    );
  };
  
  public static func lerp(
    valueStart: CGFloat,
    valueEnd: CGFloat,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> CGFloat {
  
    let percentWithEasing = easing?.compute(inputValue: percent) ?? percent;
    return lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percentWithEasing
    );
  };
  
  public static func lerp<T: UniformInterpolatable, U>(
    valueStart: T,
    valueEnd: U,
    percent: CGFloat,
    easing: InterpolationEasing
  ) -> T? {
  
    guard let valueEnd = valueEnd as? T else {
      return nil
    };
    
    return T.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easing: easing
    );
  };
  
  public static func lerp<T, U: UniformInterpolatable>(
    type: U.Type = U.self,
    keyPath: PartialKeyPath<T>,
    valueStart: T,
    valueEnd: T,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> U? {
  
    guard let keyPath = keyPath as? KeyPath<T, U> else {
      return nil;
    };
    
    let valueStart = valueStart[keyPath: keyPath];
    let valueEnd   = valueEnd  [keyPath: keyPath];
    
    return U.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easing: easing
    );
  };
  
  public static func lerp<T, U: UniformInterpolatable>(
    type: U.Type = U.self,
    keyPath: PartialKeyPath<T>,
    valueStart: T,
    valueEnd: T,
    percent: CGFloat,
    easing: InterpolationEasing?,
    writeTo target: inout T
  ) -> Bool {
  
    guard let keyPath = keyPath as? WritableKeyPath<T, U> else {
      return false;
    };
    
    let valueStart = valueStart[keyPath: keyPath];
    let valueEnd   = valueEnd  [keyPath: keyPath];
    
    let interpolatedValue = U.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easing: easing
    );
    
    target[keyPath: keyPath] = interpolatedValue;
    return true;
  };
  
  public static func lerp<T, U: CompositeInterpolatable>(
    type: U.Type = U.self,
    keyPath: PartialKeyPath<T>,
    valueStart: T,
    valueEnd: T,
    percent: CGFloat,
    easingMap: [AnyKeyPath: InterpolationEasing],
    writeTo target: inout T
  ) -> Bool {
  
    guard let keyPath = keyPath as? WritableKeyPath<T, U> else {
      return false;
    };
    
    let test: [AnyKeyPath: InterpolationEasing] = [
      \CGPoint.x: .linear,
      \CGPoint.y: .linear,
      
      \CGSize.width : .linear,
      \CGSize.height: .linear,
      
      \CGRect.size  : .linear,
      \CGRect.origin: .linear,
    ];
    
    let test2 = test as? [PartialKeyPath<CGPoint>: InterpolationEasing];
    let test3 = test as? [PartialKeyPath<T>: InterpolationEasing];
    
    let test4 = {
      var result: [PartialKeyPath<CGPoint>: InterpolationEasing] = [:];
      
      for (key, value) in test {
        if let key2 = key as? PartialKeyPath<CGPoint> {
          result[key2] = value;
        };
      };
      
      return result;
    }();
    
    let test5 = {
      var result: [PartialKeyPath<T>: InterpolationEasing] = [:];
      
      for (key, value) in test {
        if let key2 = key as? PartialKeyPath<T> {
          result[key2] = value;
        };
      };
      
      return result;
    }();
    
    let test6 = {
      var result: [PartialKeyPath<T>: InterpolationEasing] = test.reduce(into: [:]){
        guard let newKey = $1.key as? PartialKeyPath<T> else { return };
        $0[newKey] = $1.value;
      };
      
      test.compactMapValues(<#T##transform: (InterpolationEasing) throws -> T?##(InterpolationEasing) throws -> T?#>)
    }();
    
    
    
    let valueStart = valueStart[keyPath: keyPath];
    let valueEnd   = valueEnd  [keyPath: keyPath];
    
    let interpolatedValue = U.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easingMap: [:]
    );
    
    target[keyPath: keyPath] = interpolatedValue;
    return true;
  };
  
  public static func interpolate(
    inputValue: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: CGFloat,
    outputValueEnd: CGFloat,
    easing: InterpolationEasing = .linear
  ) -> CGFloat {

    let inputValueAdj   = inputValue    - inputValueStart;
    let inputRangeDelta = inputValueEnd - inputValueStart;

    let progressRaw = inputValueAdj / inputRangeDelta;
    let progress = progressRaw.isFinite ? progressRaw : 0;
          
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : progress
    );
  };
  
  public static func interpolate(
    relativePercent: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: CGFloat,
    outputValueEnd: CGFloat,
    easing: InterpolationEasing = .linear
  ) -> CGFloat {
    
    let rangeDelta = abs(inputValueStart - inputValueEnd);
    let inputValue = rangeDelta * relativePercent;
    
    let percentRaw = inputValue / rangeDelta;
    let percent = percentRaw.isFinite ? percentRaw : 0;
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : percent
    );
  };

  public static func interpolate(
    inputValue: CGFloat,
    rangeInput: [CGFloat],
    rangeOutput: [CGFloat],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false,
    easing: InterpolationEasing = .linear
  ) -> CGFloat? {
  
    guard rangeInput.count == rangeOutput.count,
          rangeInput.count >= 2
    else { return nil };
    
    if shouldClampMin, inputValue < rangeInput.first! {
      return rangeOutput.first!;
    };
    
    if shouldClampMax, inputValue > rangeInput.last! {
      return rangeOutput.last!;
    };
    
    // A - Extrapolate Left
    if inputValue < rangeInput.first! {
      let rangeInputStart  = rangeInput.first!;
      let rangeInputEnd = rangeInput[1];
      
      let rangeOutputStart = rangeOutput.first!;
      let rangeOutputEnd = rangeOutput[1];
      
      return Self.interpolate(
        inputValue: inputValue,
        inputValueStart: rangeInputEnd,
        inputValueEnd: rangeInputStart,
        outputValueStart: rangeOutputEnd,
        outputValueEnd: rangeOutputStart,
        easing: easing
      );
    };
    
    let (rangeStartIndex, rangeEndIndex): (Int, Int) = {
      let rangeInputEnumerated = rangeInput.enumerated();
      
      let match = rangeInputEnumerated.first {
        guard let nextValue = rangeInput[safeIndex: $0.offset + 1]
        else { return false };
        
        return inputValue >= $0.element && inputValue < nextValue;
      };
      
      // B - Interpolate Between
      if let match = match {
        let rangeStartIndex = match.offset;
        return (rangeStartIndex, rangeStartIndex + 1);
      };
        
      let lastIndex         = rangeInput.count - 1;
      let secondToLastIndex = rangeInput.count - 2;
      
      // C - Extrapolate Right
      return (secondToLastIndex, lastIndex);
    }();
    
    guard let rangeInputStart  = rangeInput [safeIndex: rangeStartIndex],
          let rangeInputEnd    = rangeInput [safeIndex: rangeEndIndex  ],
          let rangeOutputStart = rangeOutput[safeIndex: rangeStartIndex],
          let rangeOutputEnd   = rangeOutput[safeIndex: rangeEndIndex  ]
    else { return nil };
    
    return Self.interpolate(
      inputValue      : inputValue,
      inputValueStart : rangeInputStart,
      inputValueEnd   : rangeInputEnd,
      outputValueStart: rangeOutputStart,
      outputValueEnd  : rangeOutputEnd,
      easing          : easing
    );
  };
};

