//
//  TargetedInterpolator.swift
//  
//
//  Created by Dominic Go on 7/20/24.
//

import Foundation


public protocol TargetedInterpolator {
  func interpolateAndApplyToTarget(inputValue: CGFloat);
  func interpolateAndApplyToTarget(inputPercent: CGFloat);
};
