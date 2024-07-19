//
//  RangeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct RangeInterpolator<T: UniformInterpolatable> {

  public typealias RangeItemInput = IndexValuePair<CGFloat>;
  public typealias RangeItemOutput = IndexValuePair<T>;
  
  public typealias TargetBlock = (
    _ sender: Self,
    _ interpolatedValue: T
  ) -> Void;
  
  public typealias EasingProviderBlock = (
    _ rangeIndex: Int,
    _ interpolatorType: InterpolationMode,
    _ inputValueStart: CGFloat,
    _ inputValueEnd: CGFloat,
    _ outputValueStart: T,
    _ outputValueEnd: T
  ) -> InterpolationEasing;
  
  public enum InterpolationMode {
    case extrapolateLeft;
    case extrapolateRight;
    case interpolate(interpolatorIndex: Int);
  };
  
  public static var genericType: T.Type {
    return T.self;
  };
  
  // MARK: - Properties
  // ------------------

  public let rangeInput: [CGFloat];
  public let rangeOutput: [T];
  
  private(set) public var rangeInputMin: RangeItemInput;
  private(set) public var rangeInputMax: RangeItemInput;
  
  private(set) public var inputValuePrev: CGFloat?;
  private(set) public var inputValueCurrent: CGFloat?;
  
  private(set) public var interpolators: [Interpolator<T>];
  private(set) public var extrapolatorLeft: Interpolator<T>;
  private(set) public var extrapolatorRight: Interpolator<T>;
  
  private var interpolationModePrevious: InterpolationMode?;
  private var interpolationModeCurrent: InterpolationMode? {
    willSet {
      self.interpolationModePrevious = newValue;
    }
  };
  
  public var targetBlock: TargetBlock?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var currentInterpolator: Interpolator<T>? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return self.extrapolatorLeft;
        
      case .extrapolateRight:
        return self.extrapolatorRight;
        
      case let .interpolate(interpolatorIndex):
        return self.interpolators[interpolatorIndex];
    };
  };
  
  public var currentInterpolationIndex: Int? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return 0;
        
      case .extrapolateRight:
        return self.rangeInput.count - 1;
        
      case let .interpolate(interpolatorIndex):
        return interpolatorIndex;
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    rangeInput: [CGFloat],
    rangeOutput: [T],
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
    
    self.rangeInput = rangeInput;
    self.rangeOutput = rangeOutput;
    self.targetBlock = targetBlock;
    
    self.rangeInputMin = rangeInput.indexedMin!;
    self.rangeInputMax = rangeInput.indexedMax!;
    
    var interpolators: [Interpolator<T>] = [];
    
    for index in 0..<rangeInput.count - 1 {
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
      
      let interpolator = Interpolator<T>(
        inputValueStart: inputStart,
        inputValueEnd: inputEnd,
        outputValueStart: outputStart,
        outputValueEnd: outputEnd,
        easing: easing
      );
      
      interpolators.append(interpolator);
    };
    
    self.interpolators = interpolators;
    
    self.extrapolatorLeft = .init(
      inputValueStart: rangeInput[1],
      inputValueEnd: rangeInput[0],
      outputValueStart: rangeOutput[1],
      outputValueEnd: rangeOutput[0],
      easing: .linear, // TODO: Impl. custom easing
      clampingOptions: clampingOptions.shouldClampLeft ? .left : .none
    );
    
    self.extrapolatorRight = .init(
      inputValueStart: rangeInput.secondToLast!,
      inputValueEnd: rangeInput.last!,
      outputValueStart: rangeOutput.secondToLast!,
      outputValueEnd: rangeOutput.last!,
      easing: .linear, // TODO: Impl. custom easing
      clampingOptions: clampingOptions.shouldClampRight ? .right : .none
    );
  };
  
  // MARK: Functions
  // ---------------
  
  public func createDirectInterpolator(
    fromStartIndex startIndex: Int,
    toEndIndex endIndex: Int
  ) throws -> Interpolator<T> {
    
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
  
  public mutating func interpolate(inputValue: CGFloat) -> T {
    let inputValuePrev = self.inputValueCurrent;
    
    self.inputValuePrev = inputValuePrev;
    self.inputValueCurrent = inputValue;
  
    let matchInterpolator = self.interpolators.getInterpolator(
      forInputValue: inputValue,
      withStartIndex: self.currentInterpolationIndex
    );
    
    if let (interpolatorIndex, interpolator) = matchInterpolator {
      self.interpolationModeCurrent =
        .interpolate(interpolatorIndex: interpolatorIndex);
        
      return interpolator.interpolate(inputValue: inputValue);
    };
    
    // extrapolate left
    if inputValue < rangeInput.first! {
      self.interpolationModeCurrent = .extrapolateLeft;
      return self.extrapolatorLeft.interpolate(inputValue: inputValue);
    };
    
    // extrapolate right
    if inputValue > rangeInput.last! {
      self.interpolationModeCurrent = .extrapolateRight;
      return self.extrapolatorRight.interpolate(inputValue: inputValue);
    };
    
    // this shouldn't be called
    return T.interpolate(
      inputValue: inputValue,
      inputValueStart: self.rangeInput.first!,
      inputValueEnd: self.rangeInput.last!,
      outputValueStart: self.rangeOutput.first!,
      outputValueEnd: self.rangeOutput.last!,
      easing: .linear
    );
  };
  
  @discardableResult
  public mutating func interpolateAndApplyToTarget(inputValue: CGFloat) -> T {
    let result = self.interpolate(inputValue: inputValue);
    
    if let targetBlock = self.targetBlock {
      targetBlock(self, result);
    };
    
    return result;
  };
};

// MARK: - Array+UniformInterpolator
// --------------------------

fileprivate extension Array {

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
