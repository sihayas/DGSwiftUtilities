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

  static var interpolatablePropertiesMap: InterpolatableValuesMap { get };
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: [PartialKeyPath<Self>: InterpolationEasing]
  ) -> Self;
};

public extension CompositeInterpolatable {
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: [PartialKeyPath<Self>: InterpolationEasing]
  ) -> Self {
    
    var newValue = valueStart;
    
    for (partialKeyPath, type) in Self.interpolatablePropertiesMap {
      let easing = easingMap[partialKeyPath];

      if InterpolatorHelpers.lerp(
        type: type,
        keyPath: partialKeyPath,
        valueStart: valueStart,
        valueEnd: valueEnd,
        percent: percent,
        easing: easing,
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
  
  // MARK: - `Interpolator` Conformance
  // ----------------------------------
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> Self {
    
    Self.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easingMap: [:]
    );
  };
};
