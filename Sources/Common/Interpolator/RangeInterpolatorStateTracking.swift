//
//  RangeInterpolatorStateTracking.swift
//  
//
//  Created by Dominic Go on 7/20/24.
//

import Foundation

public protocol RangeInterpolatorStateTracking: RangeInterpolating {
  
  var inputValuePrev: CGFloat? { get set };
  var inputValueCurrent: CGFloat? { get set };
  
  var outputValuePrev: InterpolatableValue? { get set };
  var outputValueCurrent: InterpolatableValue? { get set };
  
  var interpolationModePrevious: RangeInterpolationMode? { get set };
  var interpolationModeCurrent: RangeInterpolationMode? { get set };
};

public extension RangeInterpolatorStateTracking {
  
  var currentInputInterpolator: Self.InputInterpolator? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return self.inputExtrapolatorLeft;
        
      case .extrapolateRight:
        return self.inputExtrapolatorRight;
        
      case let .interpolate(interpolatorIndex):
        return self.inputInterpolators[interpolatorIndex];
    };
  };
  
  var currentOutputInterpolator: Self.OutputInterpolator? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return self.outputExtrapolatorLeft;
        
      case .extrapolateRight:
        return self.outputExtrapolatorRight;
        
      case let .interpolate(interpolatorIndex):
        return self.outputInterpolators[interpolatorIndex];
    };
  };
  
  var currentInterpolationIndex: Int? {
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
  
  mutating func interpolate(
    inputValue: CGFloat,
    shouldUpdateState: Bool = true
  ) -> InterpolatableValue {
  
    let (result, nextInterpolationMode) = self.interpolate(
      inputValue: inputValue,
      currentInterpolationIndex: self.currentInterpolationIndex
    );
    
    if shouldUpdateState {
      self.inputValuePrev = self.inputValueCurrent;
      self.inputValueCurrent = inputValue;
      
      self.outputValuePrev = self.outputValueCurrent;
      self.outputValueCurrent = result;
      
      self.interpolationModePrevious = self.interpolationModeCurrent;
      self.interpolationModeCurrent = nextInterpolationMode;
    };
    
    return result;
  };
  
  mutating func interpolate(
    inputPercent: CGFloat,
    shouldUpdateState: Bool = true
  ) -> InterpolatableValue {
  
    let (result, nextInterpolationMode, inputValue) = self.interpolate(
      inputPercent: inputPercent,
      currentInterpolationIndex: self.currentInterpolationIndex
    );
    
    if shouldUpdateState {
      self.inputValuePrev = self.inputValueCurrent;
      self.inputValueCurrent = inputValue;
      
      self.outputValuePrev = self.outputValueCurrent;
      self.outputValueCurrent = result;
      
      self.interpolationModePrevious = self.interpolationModeCurrent;
      self.interpolationModeCurrent = nextInterpolationMode;
    };
    
    return result;
  };
};
