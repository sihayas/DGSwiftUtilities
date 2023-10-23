//
//  RGBColor.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation

public struct RGBColor {

  public var r: CGFloat;
  public var g: CGFloat;
  public var b: CGFloat;
  
  public init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.r = r;
    self.g = g;
    self.b = b;
  };
  
  public init(r: Int, g: Int, b: Int) {
    self.r = CGFloat(r) / 255;
    self.g = CGFloat(g) / 255;
    self.b = CGFloat(b) / 255;
  }
};
