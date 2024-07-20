//
//  RangeInterpolating.swift
//  
//
//  Created by Dominic Go on 7/20/24.
//

import Foundation


public protocol RangeInterpolating {

  associatedtype InterpolatableValue: UniformInterpolatable;

  typealias RangeItem = IndexValuePair<CGFloat>;
  typealias RangeItemOutput = IndexValuePair<InterpolatableValue>;
  
  typealias InputInterpolator = DGSwiftUtilities.Interpolator<CGFloat>;
  typealias OutputInterpolator = DGSwiftUtilities.Interpolator<InterpolatableValue>;
  
  
  typealias TargetBlock = (
    _ sender: Self,
    _ interpolatedValue: InterpolatableValue
  ) -> Void;
  
  typealias EasingProviderBlock = (
    _ rangeIndex: Int,
    _ interpolatorType: RangeInterpolationMode,
    _ inputValueStart: CGFloat,
    _ inputValueEnd: CGFloat,
    _ outputValueStart: InterpolatableValue,
    _ outputValueEnd: InterpolatableValue
  ) -> InterpolationEasing;

  var rangeInput : [CGFloat] { get };
  var rangeOutput: [InterpolatableValue] { get };
  
  var rangeInputMin: RangeItem { get };
  var rangeInputMax: RangeItem { get };
  
  var inputInterpolators : [InputInterpolator ] { get };
  var outputInterpolators: [OutputInterpolator] { get };
  
  var extrapolatorLeft : OutputInterpolator { get };
  var extrapolatorRight: OutputInterpolator { get };
  
  init(
    rangeInput: [CGFloat],
    rangeOutput: [InterpolatableValue],
    targetBlock: TargetBlock?,
    rangeInputMin: RangeItem,
    rangeInputMax: RangeItem,
    interpolators: [OutputInterpolator],
    inputInterpolators: [InputInterpolator],
    extrapolatorLeft: OutputInterpolator,
    extrapolatorRight: OutputInterpolator
  );
};

public extension RangeInterpolating {

  init(
    rangeInput: [CGFloat],
    rangeOutput: [InterpolatableValue],
    clampingOptions: ClampingOptions = .none,
    easingProvider: EasingProviderBlock? = nil,
    targetBlock: TargetBlock? = nil
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
    
    let rangeInputMin = rangeInput.indexedMin!;
    let rangeInputMax = rangeInput.indexedMax!;
    
    var inputInterpolators: [InputInterpolator] = [];
    var outputInterpolators: [OutputInterpolator] = [];
    
    for index in 0..<rangeInput.count - 1 {
      let isFirstIndex = index == 0;
      let isLastIndex  = index == rangeInput.count - 1;
    
      let inputStart = rangeInput[index];
      let inputEnd   = rangeInput[index + 1];
      
      let outputStart = rangeOutput[index];
      let outputEnd   = rangeOutput[index + 1];
      
      let easing = easingProvider?(
        /* rangeIndex      : */ index,
        /* interpolatorType: */ .interpolate(interpolatorIndex: index),
        /* inputValueStart : */ inputStart,
        /* inputValueEnd   : */ inputEnd,
        /* outputValueStart: */ outputStart,
        /* outputValueEnd  : */ outputEnd
      );
      
      let inputInterpolator: InputInterpolator = {
        let inputStart: CGFloat = isFirstIndex
          ? 0
          : CGFloat(index) + 1 / CGFloat(rangeInput.count);
          
        let inputEnd: CGFloat = isLastIndex
          ? 1
          : CGFloat(index) + 2 / CGFloat(rangeInput.count);
        
        return .init(
          inputValueStart: inputStart,
          inputValueEnd: inputEnd,
          outputValueStart: inputStart,
          outputValueEnd: inputEnd,
          easing: easing
        );
      }();
      
      inputInterpolators.append(inputInterpolator);
      
      let outputInterpolator: OutputInterpolator = .init(
        inputValueStart: inputStart,
        inputValueEnd: inputEnd,
        outputValueStart: outputStart,
        outputValueEnd: outputEnd,
        easing: easing
      );
      
      outputInterpolators.append(outputInterpolator);
    };
    
    let extrapolatorLeft: OutputInterpolator = .init(
      inputValueStart: rangeInput[1],
      inputValueEnd: rangeInput[0],
      outputValueStart: rangeOutput[1],
      outputValueEnd: rangeOutput[0],
      easing: .linear, // TODO: Impl. custom easing
      clampingOptions: clampingOptions.shouldClampLeft ? .left : .none
    );
    
    let extrapolatorRight: OutputInterpolator = .init(
      inputValueStart: rangeInput.secondToLast!,
      inputValueEnd: rangeInput.last!,
      outputValueStart: rangeOutput.secondToLast!,
      outputValueEnd: rangeOutput.last!,
      easing: .linear, // TODO: Impl. custom easing
      clampingOptions: clampingOptions.shouldClampRight ? .right : .none
    );
    
    self.init(
      rangeInput: rangeInput,
      rangeOutput: rangeOutput,
      targetBlock: targetBlock,
      rangeInputMin: rangeInputMin,
      rangeInputMax: rangeInputMax,
      interpolators: outputInterpolators,
      inputInterpolators: inputInterpolators,
      extrapolatorLeft: extrapolatorLeft,
      extrapolatorRight: extrapolatorRight
    );
  };
  
  func createDirectInterpolator(
    fromStartIndex startIndex: Int,
    toEndIndex endIndex: Int
  ) throws -> OutputInterpolator {
    
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
    
    let interpolator: OutputInterpolator = .init(
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
  ) -> (
    result: InterpolatableValue,
    interpolationMode: RangeInterpolationMode
  ) {
  
    let matchInterpolator = self.outputInterpolators.getInterpolator(
      forInputValue: inputValue,
      withStartIndex: currentInterpolationIndex
    );
    
    if let (interpolatorIndex, interpolator) = matchInterpolator {
      return (
        result: interpolator.interpolate(inputValue: inputValue),
        interpolationMode: .interpolate(interpolatorIndex: interpolatorIndex)
      );
    };
    
    // extrapolate left
    if inputValue < self.rangeInput.first! {
      interpolationModeChangeBlock?(.extrapolateLeft);
      
      return (
        result: self.extrapolatorLeft.interpolate(inputValue: inputValue),
        interpolationMode: .extrapolateLeft
      );
    };
    
    // extrapolate right
    if inputValue > rangeInput.last! {
      return (
        result: self.extrapolatorRight.interpolate(inputValue: inputValue),
        interpolationMode: .extrapolateRight
      );
    };
    
    // this shouldn't be called
    let result = InterpolatableValue.interpolate(
      inputValue: inputValue,
      inputValueStart: self.rangeInput.first!,
      inputValueEnd: self.rangeInput.last!,
      outputValueStart: self.rangeOutput.first!,
      outputValueEnd: self.rangeOutput.last!
    );
    
    return (result, .interpolate(interpolatorIndex: 0));
  };
};

// MARK: - Array+UniformInterpolator
// --------------------------

extension Array {

  func getInterpolator<T>(
    forInputValue inputValue: CGFloat,
    withStartIndex startIndex: Int? = nil
  ) -> IndexValuePair<Interpolator<T>>? where Element == Interpolator<T> {
    
    let predicate: (_ interpolator: Interpolator<T>) -> Bool = {
         inputValue >= $0.inputValueStart
      && inputValue <= $0.inputValueEnd;
    };
    
    guard let startIndex = startIndex else {
      return self.indexedFirst { _, interpolator in
        predicate(interpolator);
      };
    };
    
    return self.indexedFirstBySeekingForwardAndBackwards(startIndex: startIndex) { item, _ in
      predicate(item.value);
    };
  };
};
