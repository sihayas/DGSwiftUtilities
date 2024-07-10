//
//  File 2.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public enum InterpolationEasing {
  
  case linear;
  
  case easeInCustom(amount: CGFloat);
  case easeOutCustom(amount: CGFloat);
  case easeInOutCustom(easeInAmount: CGFloat, easeOutAmount: CGFloat);
  
  /// amount: 0.1 = slowest, 1 = linear, 10 = fastest
  case easeInOutExpoCustom(amount: CGFloat)
  
  case customFunction(_ easingFn: (CGFloat) -> CGFloat);
  
  case easeInSine;
  case easeOutSine;
  case easeInOutSine;
  
  case easeInQuad;
  case easeOutQuad;
  case easeInOutQuad;
  
  case easeInCubic;
  case easeOutCubic;
  case easeInOutCubic;
  
  case easeInQuart;
  case easeOutQuart;
  case easeInOutQuart;
  
  case easeInQuint;
  case easeOutQuint;
  case easeInOutQuint;
  
  case easeInExpo;
  case easeOutExpo;
  case easeInOutExpo;
  
  func compute(inputValue: CGFloat) -> CGFloat {
    switch self {
      case .linear:
        return inputValue;
        
      case let .easeInCustom(amount):
        return pow(inputValue, amount);
        
      case let .easeOutCustom(amount):
        let exp = amount / 2;
        return pow(inputValue, exp);
        
      case let .easeInOutCustom(easeInAmount, easeOutAmount):
        let easeInConfig: Self = .easeInCustom(amount: easeInAmount);
        let easeOutConfig: Self = .easeOutCustom(amount: easeOutAmount);
        
        let easeIn = easeInConfig.compute(inputValue: inputValue);
        let easeOut = easeOutConfig.compute(inputValue: inputValue);
        
        return Interpolator.lerp(
          valueStart: easeIn,
          valueEnd: easeOut,
          percent: inputValue
        );
        
      case let .easeInOutExpoCustom(amount):
        if inputValue < 0.5 {
          return pow(inputValue * 2, amount) / 2;
        };
        
        return 1 - pow(2 - inputValue * 2, amount) / 2;
        
      case let .customFunction(easingFn):
        return easingFn(inputValue);
        
      case .easeInSine:
        return 1 - cos((inputValue * CGFloat.pi) / 2);
        
      case .easeOutSine:
        return sin((inputValue * CGFloat.pi) / 2);
        
      case .easeInOutSine:
        return -(cos(CGFloat.pi * inputValue) - 1) / 2;
        
      case .easeInQuad:
        return inputValue * inputValue;
        
      case .easeOutQuad:
        return 1 - (1 - inputValue) * (1 - inputValue);
        
      case .easeInOutQuad:
        if inputValue < 0.5 {
          return 2 * inputValue * inputValue;
        };
        
        return 1 - pow(-2 * inputValue + 2, 2) / 2;
        
      case .easeInCubic:
        return inputValue * inputValue * inputValue;
        
      case .easeOutCubic:
        return  1 - pow(1 - inputValue, 3);
        
      case .easeInOutCubic:
        if inputValue < 0.5 {
          return 4 * inputValue * inputValue * inputValue;
        };
        
        return 1 - pow(-2 * inputValue + 2, 3) / 2;
        
      case .easeInQuart:
        return inputValue * inputValue * inputValue * inputValue;
        
      case .easeOutQuart:
        return 1 - pow(1 - inputValue, 4);
        
      case .easeInOutQuart:
        if inputValue < 0.5 {
          return 8 * inputValue * inputValue * inputValue * inputValue;
        };
        
        return 1 - pow(-2 * inputValue + 2, 4) / 2;
        
      case .easeInQuint:
        return inputValue * inputValue * inputValue * inputValue * inputValue;
        
      case .easeOutQuint:
        return 1 - pow(1 - inputValue, 5);
        
      case .easeInOutQuint:
        if inputValue < 0.5 {
          return 16 * inputValue * inputValue * inputValue * inputValue * inputValue;
        };
        
        return 1 - pow(-2 * inputValue + 2, 5) / 2;
        
      case .easeInExpo:
        if inputValue.asWholeNumberExact == 0 {
          return 0;
        };
        
        return pow(2, 10 * inputValue - 10);
        
      case .easeOutExpo:
        if inputValue.asWholeNumberExact == 1 {
          return 1;
        };
        
        return 1 - pow(2, -10 * inputValue);
        
      case .easeInOutExpo:
        if inputValue.asWholeNumberExact == 0 {
          return 0;
        };
        
        if inputValue.asWholeNumberExact == 1 {
          return 1;
        };
        
        if inputValue < 0.5 {
          return pow(2, 20 * inputValue - 10) / 2;
        };
        
        return (2 - pow(2, -20 * inputValue + 10)) / 2;
    };
  };
};

