//
//  CGSize+ConfigurableCompositeInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/17/24.
//

import Foundation
import CoreGraphics


extension CGSize: ConfigurableCompositeInterpolatable {

  public struct InterpolatableElements: OptionSet, CompositeInterpolatableElements {
    public let rawValue: Int;
    
    public static let width  = Self(rawValue: 1 << 0);
    public static let height = Self(rawValue: 1 << 1);
    
    public var associatedAnyKeyPaths: [AnyKeyPath] {
      var keyPaths: [AnyKeyPath] = [];
      
      keyPaths.unwrapThenAppend(
          self.contains(.width ) ? \CGSize.width
        : self.contains(.height) ? \CGSize.height
        : nil
      );
      
      return keyPaths;
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };
  
  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    \.width: CGFloat.self,
    \.height: CGFloat.self,
  ];
};
