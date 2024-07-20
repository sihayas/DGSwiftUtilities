//
//  AnyRangeInterpolating.swift
//  
//
//  Created by Dominic Go on 7/21/24.
//

import Foundation


public protocol AnyRangeInterpolating {

  typealias RangeItem = IndexValuePair<CGFloat>;
  typealias InputInterpolator = DGSwiftUtilities.Interpolator<CGFloat>;
  
  var rangeInput: [CGFloat] { get };
  
  var rangeInputMin: RangeItem { get };
  var rangeInputMax: RangeItem { get };
  
  var inputInterpolators : [InputInterpolator] { get };
  var inputExtrapolatorLeft : InputInterpolator { get };
  var inputExtrapolatorRight: InputInterpolator { get };
};

public extension AnyRangeInterpolating {
  
  func interpolateRangeInput(
    inputPercent: CGFloat,
    currentInterpolationIndex: Int? = nil
  ) -> CGFloat {
  
    let matchInterpolator = self.inputInterpolators.getInterpolator(
      forInputValue: inputPercent,
      withStartIndex: currentInterpolationIndex
    );
    
    if let (_, interpolator) = matchInterpolator {
      return interpolator.interpolate(inputValue: inputPercent);
    };
    
    // extrapolate left
    if inputPercent < self.rangeInput.first! {
      return self.inputExtrapolatorLeft.interpolate(inputValue: inputPercent);
    };
    
    // extrapolate right
    if inputPercent > self.rangeInput.last! {
      return self.inputExtrapolatorRight.interpolate(inputValue: inputPercent);
    };
    
    // this should never be called
    return InterpolatorHelpers.interpolate(
      inputValue: inputPercent,
      inputValueStart: self.inputInterpolators.first!.inputValueStart,
      inputValueEnd: self.inputInterpolators.last!.inputValueEnd,
      outputValueStart: self.rangeInput.first!,
      outputValueEnd: self.rangeInput.last!
    );
  };
};
