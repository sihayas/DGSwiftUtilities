//
//  CGRect+CompositeInterpolatableWithConfigurableElements.swift
//
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation
import CoreGraphics


extension CGRect: CompositeInterpolatableWithConfigurableElements {
  
  public struct InterpolatableElements: OptionSet, CompositeInterpolatableElements {
    public let rawValue: Int;
    
    public static let width  = Self(rawValue: 1 << 0);
    public static let height = Self(rawValue: 1 << 1);
    public static let x      = Self(rawValue: 1 << 2);
    public static let y      = Self(rawValue: 1 << 3);
    
    public static let size  : Self = [.width, .height];
    public static let origin: Self = [.x, .y];
    
    public var associatedAnyKeyPaths: [AnyKeyPath] {
      var keyPaths: [AnyKeyPath] = [];
      
      keyPaths.unwrapThenAppend(
          self.contains(.size  ) ? \CGRect.size
        : self.contains(.width ) ? \CGSize.width
        : self.contains(.height) ? \CGSize.height
        : nil
      );
      
      keyPaths.unwrapThenAppend(
          self.contains(.origin) ? \CGRect.origin
        : self.contains(.x     ) ? \CGPoint.x
        : self.contains(.y     ) ? \CGPoint.y
        : nil
      );
      
      return keyPaths;
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };

  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.size: CGSize.self,
    \.origin: CGPoint.self,
  ];
};


