//
//  RangeInterpolatorStateTracking.swift
//  
//
//  Created by Dominic Go on 7/20/24.
//

import Foundation

public protocol RangeInterpolatorStateTracking {

  associatedtype InterpolatableValue: UniformInterpolatable;
  
  var interpolationModePrevious: RangeInterpolationMode? { get set };
  var interpolationModeCurrent: RangeInterpolationMode? { get set };
};

public extension RangeInterpolatorStateTracking where Self: RangeInterpolating {
  
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
  
  mutating func interpolate(inputValue: CGFloat) -> InterpolatableValue {
    let result = self.interpolate(
      inputValue: inputValue,
      currentInterpolationIndex: self.currentInterpolationIndex
    );
    
    self.interpolationModePrevious = self.interpolationModeCurrent;
    self.interpolationModeCurrent = result.interpolationMode;
    
    return result.result;
  };
  
  mutating func interpolate(inputPercent: CGFloat) -> InterpolatableValue {
    let result = self.interpolate(
      inputPercent: inputPercent,
      currentInterpolationIndex: self.currentInterpolationIndex
    );
    
    self.interpolationModePrevious = self.interpolationModeCurrent;
    self.interpolationModeCurrent = result.interpolationMode;
    
    return result.result;
  };
};
