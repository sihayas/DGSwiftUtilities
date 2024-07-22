//
//  Interpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct Interpolator<T: UniformInterpolatable>: AnyInterpolator  {

  //public typealias InterpolatableValue = T.InterpolatableValue;

  public typealias TargetBlock = (
    _ sender: Self,
    _ interpolatedValue: T.InterpolatableValue
  ) -> Void;

  public let inputValueStart: CGFloat;
  public let inputValueEnd: CGFloat;
  
  public var outputValueStart: T.InterpolatableValue;
  public var outputValueEnd: T.InterpolatableValue;
  
  private let interpolatorPercent: (
    _ self: Self,
    _ percent: CGFloat
  ) -> T.InterpolatableValue;
  
  private let interpolatorValue: (
    _ self: Self,
    _ inputValue: CGFloat
  ) -> T.InterpolatableValue;
  
  public var targetBlock: TargetBlock?;
  
  // MARK: - Init - UniformInterpolatable
  // ------------------------------------
  
  public init(
    valueStart: T.InterpolatableValue,
    valueEnd: T.InterpolatableValue,
    easing: InterpolationEasing? = nil,
    clampingOptions: ClampingOptions = .none
  ) {
  
    self.inputValueStart = 0;
    self.inputValueEnd = 1;
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    
    self.interpolatorPercent = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easing: easing,
        clampingOptions: clampingOptions
      );
    };
    
    self.interpolatorValue = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easing: easing,
        clampingOptions: clampingOptions
      );
    };
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T.InterpolatableValue,
    outputValueEnd: T.InterpolatableValue,
    easing: InterpolationEasing? = nil,
    clampingOptions: ClampingOptions = .none
  ) {
  
    self.inputValueStart = inputValueStart
    self.inputValueEnd = inputValueEnd
    self.outputValueStart = outputValueStart
    self.outputValueEnd = outputValueEnd
    
    self.interpolatorPercent = {
      T.rangedLerp(
        relativePercent: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easing: easing,
        clampingOptions: clampingOptions
      );
    };
    
    self.interpolatorValue = {
      T.rangedLerp(
        inputValue: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easing: easing,
        clampingOptions: clampingOptions
      );
    };
  };
  
  // MARK: - Init - CompositeInterpolatable
  // --------------------------------------
  
  public init(
    valueStart: T.InterpolatableValue,
    valueEnd: T.InterpolatableValue,
    easingMap: T.EasingKeyPathMap,
    clampingMap: T.ClampingKeyPathMap
  ) where T: CompositeInterpolatable {
    
    self.inputValueStart = 0;
    self.inputValueEnd = 1;
    self.outputValueStart = valueStart;
    self.outputValueEnd = valueEnd;
    
    self.interpolatorPercent = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easingMap: easingMap,
        clampingMap: clampingMap
      );
    };
    
    self.interpolatorValue = {
      T.lerp(
        valueStart: $0.outputValueStart,
        valueEnd: $0.outputValueEnd,
        percent: $1,
        easingMap: easingMap,
        clampingMap: clampingMap
      );
    };
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T.InterpolatableValue,
    outputValueEnd: T.InterpolatableValue,
    easingMap: T.EasingKeyPathMap,
    clampingMap: T.ClampingKeyPathMap
  ) where T: CompositeInterpolatable {
  
    self.inputValueStart = inputValueStart
    self.inputValueEnd = inputValueEnd
    self.outputValueStart = outputValueStart
    self.outputValueEnd = outputValueEnd
    
    self.interpolatorPercent = {
      T.rangedLerp(
        relativePercent: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easingMap: easingMap,
        clampingMap: clampingMap
      );
    };
    
    self.interpolatorValue = {
      T.rangedLerp(
        inputValue: $1,
        inputValueStart: $0.inputValueStart,
        inputValueEnd: $0.inputValueEnd,
        outputValueStart: $0.outputValueStart,
        outputValueEnd: $0.outputValueEnd,
        easingMap: easingMap,
        clampingMap: clampingMap
      );
    };
  };
  
  // MARK: - Init - ConfigurableCompositeInterpolatable
  // --------------------------------------------------
  
  public init(
    valueStart: T.InterpolatableValue,
    valueEnd: T.InterpolatableValue,
    easingElementMap: T.EasingElementMap,
    clampingElementMap: T.ClampingElementMap
  ) where T: ConfigurableCompositeInterpolatable {
  
    let easingMap: T.EasingKeyPathMap =
      .init(type: T.self, easingElementMap: easingElementMap);
      
    let clampingMap: T.ClampingKeyPathMap =
      .init(type: T.self, clampingElementMap: clampingElementMap);
    
    self.init(
      valueStart: valueStart,
      valueEnd: valueEnd,
      easingMap: easingMap,
      clampingMap: clampingMap
    );
  };
  
  public init(
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: T.InterpolatableValue,
    outputValueEnd: T.InterpolatableValue,
    easingElementMap: T.EasingElementMap,
    clampingElementMap: T.ClampingElementMap
  ) where T: ConfigurableCompositeInterpolatable {
    
    let easingMap: T.EasingKeyPathMap =
      .init(type: T.self, easingElementMap: easingElementMap);
      
    let clampingMap: T.ClampingKeyPathMap =
      .init(type: T.self, clampingElementMap: clampingElementMap);
      
    self = .init(
      inputValueStart: inputValueStart,
      inputValueEnd: inputValueEnd,
      outputValueStart: outputValueStart,
      outputValueEnd: outputValueEnd,
      easingMap: easingMap,
      clampingMap: clampingMap
    );
  };
  
  // MARK: - Functions
  // -----------------
  
  public func compute(usingPercentValue percent: CGFloat) -> T.InterpolatableValue {
    self.interpolatorPercent(self, percent);
  };
  
  public func compute(usingInputValue inputValue: CGFloat) -> T.InterpolatableValue {
    self.interpolatorValue(self, inputValue);
  };
    
  public func computeAndApplyToTarget(usingPercentValue percent: CGFloat) {
    guard let targetBlock = self.targetBlock else {
      return;
    };
    
    let interpolatedValue = self.compute(usingPercentValue: percent)
    targetBlock(self, interpolatedValue);
  };
  
  public func computeAndApplyToTarget(usingInputValue inputValue: CGFloat) {
    guard let targetBlock = self.targetBlock else {
      return;
    };
    
    let interpolatedValue = self.compute(usingInputValue: inputValue)
    targetBlock(self, interpolatedValue);
  };
};
