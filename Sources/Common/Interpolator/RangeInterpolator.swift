//
//  RangeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation



public struct RangeInterpolator {

  public typealias RangeItem = IndexValuePair<CGFloat>;
  
  // MARK: - Properties
  // ------------------

  public let rangeInput: [CGFloat];
  public let rangeOutput: [CGFloat];
  
  public var shouldClampMin: Bool;
  public var shouldClampMax: Bool;
  
  private(set) public var rangeInputMin: RangeItem;
  private(set) public var rangeInputMax: RangeItem;
  
  private(set) public var rangeOutputMin: RangeItem;
  private(set) public var rangeOutputMax: RangeItem;
  
  var prevInputValue: CGFloat?;
  var currentRangeStart: RangeItem?;
  var currentRangeEnd: RangeItem?;
  
  // MARK: - Computed Properties
  // ---------------------------

  
  // MARK: - Init
  // ------------
  
  public init(
    rangeInput: [CGFloat],
    rangeOutput: [CGFloat],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) throws {
      
    guard rangeInput.count == rangeOutput.count else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "count of rangeInput and rangeOutput are different"
      );
    };
    
    guard rangeInput.count >= 2 else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "rangeInput and rangeOutput must have at least contain 2 items"
      );
    };
    
    self.rangeInput = rangeInput;
    self.rangeOutput = rangeOutput;
    self.shouldClampMin = shouldClampMin;
    self.shouldClampMax = shouldClampMax;
    
    self.rangeInputMin = rangeInput.indexedMin!;
    self.rangeInputMax = rangeInput.indexedMax!;
    
    self.rangeOutputMin = rangeOutput.indexedMin!;
    self.rangeOutputMax = rangeOutput.indexedMax!;
  };
};


