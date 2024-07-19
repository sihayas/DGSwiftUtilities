//
//  CGPoint+ConfigurableCompositeInterpolatable.swift
//
//
//  Created by Dominic Go on 7/17/24.
//

import Foundation
import CoreGraphics


extension CGPoint: ConfigurableCompositeInterpolatable {

  public struct InterpolatableElements: OptionSet, CompositeInterpolatableElements {
    public let rawValue: Int;
    
    public static let x = Self(rawValue: 1 << 2);
    public static let y = Self(rawValue: 1 << 3);
    
    public var associatedAnyKeyPaths: [AnyKeyPath] {
      var keyPaths: [AnyKeyPath] = [];
    
      keyPaths.unwrapThenAppend(
          self.contains(.x) ? \CGPoint.x
        : self.contains(.y) ? \CGPoint.y
        : nil
      );
      
      return keyPaths;
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };

  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.x: CGFloat.self,
    \.y: CGFloat.self,
  ];
};
