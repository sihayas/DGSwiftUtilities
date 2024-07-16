//
//  InterpolatableWithEasingMap.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation


public protocol InterpolatableWithEasingMap: Interpolatable {
  
  static var interpolatableProperties: [PartialKeyPath<Self>] { get };
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: [PartialKeyPath<Self>: InterpolationEasing]
  ) -> Self;
};

public extension InterpolatableWithEasingMap {
  
  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: [PartialKeyPath<Self>: InterpolationEasing]
  ) -> Self {
    
    var newValue = valueStart;
    
    for partialKeyPath in Self.interpolatableProperties {
      let easing = easingMap[partialKeyPath];
    
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
