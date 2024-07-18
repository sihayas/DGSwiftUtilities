//
//  ConfigurableCompositeInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/18/24.
//

import Foundation

/// `CompositeInterpolatable` but with individually "configurable" elements.
/// In other words, custom easing + clamping for each "interpolatable" property
/// (e.g. `size`, etc).
/// 
public protocol ConfigurableCompositeInterpolatable: CompositeInterpolatable {
  
  associatedtype InterpolatableElements: CompositeInterpolatableElements;
  
  typealias EasingElementMap = [InterpolatableElements: InterpolationEasing];
};

public extension ConfigurableCompositeInterpolatable {

  static func lerp(
    valueStart: Self,
    valueEnd: Self,
    percent: CGFloat,
    easingMap: EasingElementMap
  ) -> Self {
    
    var keyPathEasingMap: EasingKeyPathMap = [:];
    
    for (element, easing) in easingMap {
      let associatedPartialKeyPaths =
        element.getAssociatedPartialKeyPaths(forType: Self.self);
      
      associatedPartialKeyPaths.forEach {
        keyPathEasingMap[$0] = easing;
      };
    };
    
    return Self.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easingMap: keyPathEasingMap
    );
  };
};
