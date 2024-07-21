//
//  CompositeInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


public protocol CompositeInterpolatable: UniformInterpolatable {
  
  typealias InterpolatableValuesMap =
    [PartialKeyPath<Self>: any UniformInterpolatable.Type];
    
  typealias EasingKeyPathMap = [AnyKeyPath: InterpolationEasing];
  typealias ClampingKeyPathMap = [AnyKeyPath: ClampingOptions];

  static var interpolatablePropertiesMap: InterpolatableValuesMap { get };
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: EasingKeyPathMap,
    clampingMap: ClampingKeyPathMap
  ) -> Self;
};

// MARK: Default Conformance - `CompositeInterpolatable`
// ----------------------------------------------------

public extension CompositeInterpolatable {
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: EasingKeyPathMap,
    clampingMap: ClampingKeyPathMap
  ) -> Self {
    
    var newValue = valueStart;
    
    for (partialKeyPath, type) in Self.interpolatablePropertiesMap {
      let easing = easingMap[partialKeyPath];
      let clampingOptions = clampingMap[partialKeyPath];
      
      if let type = type as? any CompositeInterpolatable.Type,
         InterpolatorHelpers.rangedLerp(
           type: type,
           keyPath: partialKeyPath,
           valueStart: valueStart,
           valueEnd: valueEnd,
           percent: percent,
           easingMap: easingMap,
           clampingMap: clampingMap,
           writeTo: &newValue
         )
      {
        continue;
      };

      if InterpolatorHelpers.rangedLerp(
        type: type,
        keyPath: partialKeyPath,
        valueStart: valueStart,
        valueEnd: valueEnd,
        percent: percent,
        easing: easing,
        clampingOptions: clampingOptions,
        writeTo: &newValue
      ) {
        continue;
      };
    
      switch partialKeyPath {
        case let keyPath as WritableKeyPath<Self, CGFloat>:
          let concreteValueStart = valueStart[keyPath: keyPath];
          let concreteValueEnd   = valueEnd  [keyPath: keyPath];
          
          let result = InterpolatorHelpers.lerp(
            valueStart: concreteValueStart,
            valueEnd: concreteValueEnd,
            percent: percent,
            easing: easing
          );
          
          newValue[keyPath: keyPath] = result;
          continue;
          
        default:
          #if DEBUG
          let error = GenericError(
            errorCode: .runtimeError,
            description: "Case not implemented, unable to lerp"
          );
          fatalError(error.errorDescription!);
          #endif
          break;
      };
    };
    
    return newValue;
  };
};

// MARK: Default Conformance - `UniformInterpolatable`
// --------------------------------------------------

public extension CompositeInterpolatable {
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easing: InterpolationEasing? = nil
  ) -> Self {
  
    let easingMap: EasingKeyPathMap = Self.interpolatablePropertiesMap.reduce(into: [:]){
      $0[$1.key] = easing;
    };
    
    return Self.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easingMap: easingMap,
      clampingMap: [:] // MARK: TODO
    );
  };
};

// MARK: - Functions - Helpers
// ---------------------------

public extension CompositeInterpolatable {
  
  static func rangedLerp(
    inputValue: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: Self,
    outputValueEnd: Self,
    easingMap: EasingKeyPathMap,
    clampingMap: ClampingKeyPathMap
  ) -> Self {
  
    let inputValueAdj   = inputValue    - inputValueStart;
    let inputRangeDelta = inputValueEnd - inputValueStart;

    let progressRaw = inputValueAdj / inputRangeDelta;
    let progress = progressRaw.isFinite ? progressRaw : 0;
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd: outputValueEnd,
      percent: progress,
      easingMap: easingMap,
      clampingMap: clampingMap
    );
  };
  
  static func rangedLerp(
    relativePercent: CGFloat,
    inputValueStart: CGFloat,
    inputValueEnd: CGFloat,
    outputValueStart: Self,
    outputValueEnd: Self,
    easingMap: EasingKeyPathMap,
    clampingMap: ClampingKeyPathMap
  ) -> Self {
    
    let rangeDelta = abs(inputValueStart - inputValueEnd);
    let inputValue = rangeDelta * relativePercent;
        
    let percentRaw = inputValue / rangeDelta;
    let percent = percentRaw.isFinite ? percentRaw : 0;
    
    return Self.lerp(
      valueStart: outputValueStart,
      valueEnd: outputValueEnd,
      percent: percent,
      easingMap: easingMap,
      clampingMap: clampingMap
    );
  };
};

// MARK: - Dictionary+CompositeInterpolatable.EasingKeyPathMap
// -----------------------------------------------------------

extension Dictionary where Self == CompositeInterpolatable.EasingKeyPathMap {

  public init<T>(
    type: T.Type = T.self,
    easingElementMap: T.EasingElementMap
  ) where T: ConfigurableCompositeInterpolatable {
  
    self = easingElementMap.reduce(into: [:]) {
      for keyPath in  $1.key.associatedAnyKeyPaths {
        $0[keyPath] = $1.value;
      };
    };
  };
};

// MARK: - Dictionary+CompositeInterpolatable.EasingKeyPathMap
// -----------------------------------------------------------

extension Dictionary where Self == CompositeInterpolatable.ClampingKeyPathMap {

  public init<T>(
    type: T.Type = T.self,
    clampingElementMap: T.ClampingElementMap
  ) where T: ConfigurableCompositeInterpolatable {
  
    self = clampingElementMap.reduce(into: [:]) {
      for keyPath in  $1.key.associatedAnyKeyPaths {
        $0[keyPath] = $1.value;
      };
    };
  };
};
