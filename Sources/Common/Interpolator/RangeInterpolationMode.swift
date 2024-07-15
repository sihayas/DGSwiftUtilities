//
//  RangeInterpolationMode.swift
//  
//
//  Created by Dominic Go on 7/16/24.
//

import Foundation

public enum RangeInterpolationMode {
  case extrapolateLeft;
  case extrapolateRight;
  case interpolate(interpolatorIndex: Int);
};
