//
//  RangeInterpolatorStateTracking.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


public protocol RangeInterpolatorStateTracking {
  
  var interpolationModePrevious: RangeInterpolationMode? { get set };
  var interpolationModeCurrent: RangeInterpolationMode? { get set };
};

public extension RangeInterpolatorStateTracking where Self: RangeInterpolating {
  
  var currentInterpolator: Interpolator? {
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
  
  mutating func interpolate(inputValue: CGFloat) -> CGFloat {
    var tempCopy = self;
    
    let result = self.interpolate(
      inputValue: inputValue,
      currentInterpolationIndex: self.currentInterpolationIndex,
      interpolationModeChangeBlock: {
        let prev = tempCopy.interpolationModeCurrent;
        
        tempCopy.interpolationModeCurrent = $0;
        tempCopy.interpolationModePrevious = prev;
      }
    );
    
    self = tempCopy;
    return result;
  };
};

