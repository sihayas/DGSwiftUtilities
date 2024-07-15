//
//  RangeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct RangeInterpolator {

  public typealias RangeItem = IndexValuePair<CGFloat>;
  
  private enum InterpolationMode {
    case extrapolateLeft;
    case extrapolateRight;
    case interpolate(interpolatorIndex: Int);
  };
  
  // MARK: - Properties
  // ------------------

  public let rangeInput: [CGFloat];
  public let rangeOutput: [CGFloat];
  
  public var shouldClampMin: Bool;
  public var shouldClampMax: Bool;
  
  private(set) public var rangeInputMin: RangeItem;
  private(set) public var rangeInputMax: RangeItem;
  
  private(set) public var rangeOutputMin: RangeItem;
  private(set) public var rangeOutputMax: RangeItem;
  
  private(set) public var inputValuePrev: CGFloat?;
  private(set) public var inputValueCurrent: CGFloat?;
  
  private(set) public var interpolators: [Interpolator];
  private(set) public var extrapolatorLeft: Interpolator;
  private(set) public var extrapolatorRight: Interpolator;
  
  private var interpolationModePrevious: InterpolationMode?;
  private var interpolationModeCurrent: InterpolationMode? {
    willSet {
      self.interpolationModePrevious = newValue;
    }
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var currentInterpolator: Interpolator? {
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
    
    self.rangeInput = rangeInput;
    self.rangeOutput = rangeOutput;
    self.shouldClampMin = shouldClampMin;
    self.shouldClampMax = shouldClampMax;
    
    self.rangeInputMin = rangeInput.indexedMin!;
    self.rangeInputMax = rangeInput.indexedMax!;
    
    self.rangeOutputMin = rangeOutput.indexedMin!;
    self.rangeOutputMax = rangeOutput.indexedMax!;
    
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
    
    self.interpolators = interpolators;
    
    self.extrapolatorLeft = .init(
      inputValueStart: rangeInput[1],
      inputValueEnd: rangeInput[0],
      outputValueStart: rangeOutput[1],
      outputValueEnd: rangeOutput[0],
      easing: .linear
    );
    
    self.extrapolatorRight = .init(
      inputValueStart: rangeInput.secondToLast!,
      inputValueEnd: rangeInput.last!,
      outputValueStart: rangeOutput.secondToLast!,
      outputValueEnd: rangeOutput.last!,
      easing: .linear
    );
  };
  
  // MARK: Functions
  // ---------------
  
  public func createDirectInterpolator(
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
  
  public mutating func interpolate(inputValue: CGFloat) -> CGFloat {
    let inputValuePrev = self.inputValueCurrent;
    
    self.inputValuePrev = inputValuePrev;
    self.inputValueCurrent = inputValue;
  
    let interpolator =
      self.interpolators.getInterpolator(forInputValue: inputValue);
    
    if let (interpolatorIndex, interpolator) = matchInterpolator {
      self.interpolationModeCurrent =
        .interpolate(interpolatorIndex: interpolatorIndex);
        
      return interpolator.interpolate(inputValue: inputValue);
    };
    
    // extrapolate left
    if inputValue < rangeInput.first! {
      self.interpolationModeCurrent = .extrapolateLeft;
    
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
      self.interpolationModeCurrent = .extrapolateRight;
      
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

public extension Array where Element == Interpolator {

  func getInterpolator(forInputValue inputValue: CGFloat) -> Interpolator? {
    self.first {
         inputValue >= $0.inputValueStart
      && inputValue <= $0.inputValueEnd
    };
  };
};
