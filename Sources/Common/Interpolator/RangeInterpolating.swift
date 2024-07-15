//
//  RangeInterpolating.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation

public protocol RangeInterpolating {

  typealias RangeItem = IndexValuePair<CGFloat>;

  var rangeInput: [CGFloat] { get };
  var rangeOutput: [CGFloat] { get };
  
  var shouldClampMin: Bool { get set };
  var shouldClampMax: Bool { get set };
  
  var rangeInputMin: RangeItem { get };
  var rangeInputMax: RangeItem { get };
  
  var rangeOutputMin: RangeItem { get };
  var rangeOutputMax: RangeItem { get };

  var interpolators: [Interpolator] { get };
  var extrapolatorLeft: Interpolator { get };
  var extrapolatorRight: Interpolator { get };
  
  init(
    rangeInput: [CGFloat],
    rangeOutput: [CGFloat],
    shouldClampMin: Bool,
    shouldClampMax: Bool,
    rangeInputMin: RangeItem,
    rangeInputMax: RangeItem,
    rangeOutputMin: RangeItem,
    rangeOutputMax: RangeItem,
    interpolators: [Interpolator],
    extrapolatorLeft: Interpolator,
    extrapolatorRight: Interpolator
  );
};

public extension RangeInterpolating {
  
  static func interpolate(
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
          
    return Interpolator.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : progress
    );
  };
  
  static func interpolate(
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
    
    return Interpolator.lerp(
      valueStart: outputValueStart,
      valueEnd  : outputValueEnd,
      percent   : percent
    );
  };

  static func interpolate(
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

public extension RangeInterpolating {

  init(
    rangeInput: [CGFloat],
    rangeOutput: [CGFloat],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) throws {
  
    guard rangeInput.count == rangeOutput.count else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "count of rangeInput and rangeOutput are different"
      );
    };
    
    guard rangeInput.count >= 2 else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "rangeInput and rangeOutput must have at least contain 2 items"
      );
    };
    
    var interpolators: [Interpolator] = [];
    
    for index in 0..<rangeInput.count - 1 {
      let inputStart = rangeInput[index];
      let inputEnd   = rangeInput[index + 1];
      
      let outputStart = rangeOutput[index];
      let outputEnd   = rangeOutput[index + 1];
      
      let interpolator = Interpolator(
        inputValueStart : inputStart ,
        inputValueEnd   : inputEnd   ,
        outputValueStart: outputStart,
        outputValueEnd  : outputEnd
      );
      
      interpolators.append(interpolator);
    };
  
    self = .init(
      rangeInput: rangeInput,
      rangeOutput: rangeOutput,
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax,
      rangeInputMin: rangeInput.indexedMin!,
      rangeInputMax: rangeInput.indexedMax!,
      rangeOutputMin: rangeOutput.indexedMin!,
      rangeOutputMax: rangeOutput.indexedMax!,
      interpolators: interpolators,
      extrapolatorLeft: .init(
        inputValueStart: rangeInput[1],
        inputValueEnd: rangeInput[0],
        outputValueStart: rangeOutput[1],
        outputValueEnd: rangeOutput[0],
        easing: .linear
      ),
      extrapolatorRight: .init(
        inputValueStart: rangeInput.secondToLast!,
        inputValueEnd: rangeInput.last!,
        outputValueStart: rangeOutput.secondToLast!,
        outputValueEnd: rangeOutput.last!,
        easing: .linear
      )
    );
  };
  
  func createDirectInterpolator(
    fromStartIndex startIndex: Int,
    toEndIndex endIndex: Int
  ) throws -> Interpolator {
    
    guard startIndex >= 0 && startIndex < self.rangeInput.count else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "startIndex out of bounds"
      );
    };
    
    guard endIndex >= 0 && endIndex < self.rangeInput.count else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "endIndex out of bounds"
      );
    };
    
    guard startIndex != endIndex else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "startIndex and endIndex cannot be the same"
      );
    };
    
    let inputStart = rangeInput[startIndex];
    let inputEnd   = rangeInput[startIndex];
    
    let outputStart = rangeOutput[endIndex];
    let outputEnd   = rangeOutput[endIndex];
    
    let interpolator = Interpolator(
      inputValueStart : inputStart ,
      inputValueEnd   : inputEnd   ,
      outputValueStart: outputStart,
      outputValueEnd  : outputEnd
    );
    
    return interpolator;
  };
  
  func interpolate(
    inputValue: CGFloat,
    currentInterpolationIndex: Int? = nil,
    interpolationModeChangeBlock: ((RangeInterpolationMode) -> Void)? = nil
  ) -> CGFloat {
  
    let matchInterpolator = self.interpolators.getInterpolator(
      forInputValue: inputValue,
      withStartIndex: currentInterpolationIndex
    );
    
    if let (interpolatorIndex, interpolator) = matchInterpolator {
      interpolationModeChangeBlock?(
        .interpolate(interpolatorIndex: interpolatorIndex)
      );
      
      return interpolator.interpolate(inputValue: inputValue);
    };
    
    // extrapolate left
    if inputValue < self.rangeInput.first! {
      interpolationModeChangeBlock?(.extrapolateLeft);
      
      guard !self.shouldClampMin else {
        return rangeOutput.first!;
      };
      
      return self.extrapolatorLeft.interpolate(
        inputValue: inputValue,
        easingOverride: .linear
      );
    };
    
    // extrapolate right
    if inputValue > rangeInput.last! {
      interpolationModeChangeBlock?(.extrapolateRight);
      
      guard !self.shouldClampMax else {
        return rangeOutput.last!;
      };
        
      return self.extrapolatorRight.interpolate(
        inputValue: inputValue,
        easingOverride: .linear
      );
    };
    
    // this shouldn't be called
    return Self.interpolate(
      inputValue: inputValue,
      inputValueStart: self.rangeInput.first!,
      inputValueEnd: self.rangeInput.last!,
      outputValueStart: self.rangeOutput.first!,
      outputValueEnd: self.rangeOutput.last!,
      easing: .linear
    );
  };
};
