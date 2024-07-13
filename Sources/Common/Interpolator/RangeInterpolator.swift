//
//  RangeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation



public struct RangeInterpolator {

  public typealias RangeItem = IndexValuePair<CGFloat>;
  
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
  
  private(set) public var prevInputValue: CGFloat?;
  var currentInterpolatorIndex: Int?;
  
  private(set) public var interpolators: [Interpolator];
  private(set) public var extrapolatorLeft: Interpolator;
  private(set) public var extrapolatorRight: Interpolator;
  
  // MARK: - Computed Properties
  // ---------------------------

  
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
  
  public func getInputOutputRange(forInputValue inputValue: CGFloat) -> (
    rangeInputStart: RangeItem,
    rangeInputEnd: RangeItem,
    rangeOutputStart: RangeItem,
    rangeOutputEnd: RangeItem
  )? {
    return nil;
  };
  
  public func interpolate(inputValue: CGFloat) -> CGFloat {
  
    let interpolator =
      self.interpolators.getInterpolator(forInputValue: inputValue);
    
    if let interpolator = interpolator {
      return interpolator.interpolate(inputValue: inputValue);
    };
    
    // extrapolate left
    if inputValue < rangeInput.first! {
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

extension Array where Element == Interpolator {

  func getInterpolator(forInputValue inputValue: CGFloat) -> Interpolator? {
    self.first {
         inputValue >= $0.inputValueStart
      && inputValue <= $0.inputValueEnd
    };
  };
};


