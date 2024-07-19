//
//  RangeInterpolator.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public struct RangeInterpolator<T: UniformInterpolatable> {

  public typealias RangeItemInput = IndexValuePair<CGFloat>;
  public typealias RangeItemOutput = IndexValuePair<T>;
  
  private enum InterpolationMode {
    case extrapolateLeft;
    case extrapolateRight;
    case interpolate(interpolatorIndex: Int);
  };
  
  public static var genericType: T.Type {
    return T.self;
  };
  
  // typealias X = UniformInterpolator<T>;
  // typealias Y = CompositeInterpolator<T>;
  
  // MARK: - Properties
  // ------------------

  public let rangeInput: [CGFloat];
  public let rangeOutput: [T];
  
  public var shouldClampMin: Bool;
  public var shouldClampMax: Bool;
  
  private(set) public var rangeInputMin: RangeItemInput;
  private(set) public var rangeInputMax: RangeItemInput;
  
  private(set) public var inputValuePrev: CGFloat?;
  private(set) public var inputValueCurrent: CGFloat?;
  
  private(set) public var interpolators: [UniformInterpolator<T>];
  private(set) public var extrapolatorLeft: UniformInterpolator<T>;
  private(set) public var extrapolatorRight: UniformInterpolator<T>;
  
  private var interpolationModePrevious: InterpolationMode?;
  private var interpolationModeCurrent: InterpolationMode? {
    willSet {
      self.interpolationModePrevious = newValue;
    }
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var currentInterpolator: UniformInterpolator<T>? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return self.extrapolatorLeft;
        
      case .extrapolateRight:
        return self.extrapolatorRight;
        
      case let .interpolate(interpolatorIndex):
        return self.interpolators[interpolatorIndex];
    };
  };
  
  public var currentInterpolationIndex: Int? {
    guard let interpolationModeCurrent = self.interpolationModeCurrent else {
      return nil;
    };
    
    switch interpolationModeCurrent {
      case .extrapolateLeft:
        return 0;
        
      case .extrapolateRight:
        return self.rangeInput.count - 1;
        
      case let .interpolate(interpolatorIndex):
        return interpolatorIndex;
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    rangeInput: [CGFloat],
    rangeOutput: [T],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
    // TODO: Impl. easing - To be impl.
  ) throws {
    
    try Self.checkIfValid(
      rangeInput: rangeInput,
      rangeOutput: rangeOutput
    );
    
    self.rangeInput = rangeInput;
    self.rangeOutput = rangeOutput;
    
    self.shouldClampMin = shouldClampMin;
    self.shouldClampMax = shouldClampMax;
    
    self.rangeInputMin = rangeInput.indexedMin!;
    self.rangeInputMax = rangeInput.indexedMax!;
    
    var interpolators: [UniformInterpolator<T>] = [];
    
    for index in 0..<rangeInput.count - 1 {
      let inputStart = rangeInput[index];
      let inputEnd   = rangeInput[index + 1];
      
      let outputStart = rangeOutput[index];
      let outputEnd   = rangeOutput[index + 1];
      
      let interpolator = UniformInterpolator<T>(
        inputValueStart : inputStart ,
        inputValueEnd   : inputEnd   ,
        outputValueStart: outputStart,
        outputValueEnd  : outputEnd  ,
        easing          : .linear // TODO: WIP - To be impl.
      );
      
      interpolators.append(interpolator);
    };
    
    self.interpolators = interpolators;
    
    self.extrapolatorLeft = .init(
      inputValueStart: rangeInput[1],
      inputValueEnd: rangeInput[0],
      outputValueStart: rangeOutput[1],
      outputValueEnd: rangeOutput[0],
      easing: .linear // TODO: WIP - To be impl.
    );
    
    self.extrapolatorRight = .init(
      inputValueStart: rangeInput.secondToLast!,
      inputValueEnd: rangeInput.last!,
      outputValueStart: rangeOutput.secondToLast!,
      outputValueEnd: rangeOutput.last!,
      easing: .linear // TODO: WIP - To be impl.
    );
  };
  
  public init(
    rangeInput: [CGFloat],
    rangeOutput: [T],
    easingConfig: T.EasingKeyPathMap = [:]
  ) throws where T: CompositeInterpolatable  {
    
    try Self.checkIfValid(
      rangeInput: rangeInput,
      rangeOutput: rangeOutput
    );
    
    self.rangeInput = rangeInput;
    self.rangeOutput = rangeOutput;
    
    self.shouldClampMin = false; // TODO: WIP - To be impl.
    self.shouldClampMax = false; // TODO: WIP - To be impl.
    
    self.rangeInputMin = rangeInput.indexedMin!;
    self.rangeInputMax = rangeInput.indexedMax!;
    
    var interpolators: [any Interpolator] = [];
    
    for index in 0..<rangeInput.count - 1 {
      let inputStart = rangeInput[index];
      let inputEnd   = rangeInput[index + 1];
      
      let outputStart = rangeOutput[index];
      let outputEnd   = rangeOutput[index + 1];
      
      typealias A = CompositeInterpolator<T>;
      
      let interpolator = A(
        inputValueStart : inputStart ,
        inputValueEnd   : inputEnd   ,
        outputValueStart: outputStart,
        outputValueEnd  : outputEnd
      );
      
      //let x = interpolator as? UniformInterpolator<T>;
      //print(index, "interpolator", x);
      //continue;
      
      // let a = interpolator as? Box<T>;
      // let b = interpolator as? UniformInterpolator<T>;
      // let c = interpolator as? CompositeInterpolator<T>.UniformInterpolator;
      // let d = interpolator as? A.UniformInterpolator
      
      let a = interpolator as? Box<T>;
      let b = interpolator as? UniformInterpolator<T> ;
      let c = interpolator as? CompositeInterpolator<T>.UniformInterpolator;
      let d = interpolator as? A.UniformInterpolator
      
      interpolators.append(interpolator);
    };
    
    //self.interpolators = interpolators;
    
    //let any: Any = 1;
    //let b: Int = any;
    
    
    fatalError();
  };
  
  // MARK: Functions
  // ---------------
  
  public func createDirectInterpolator(
    fromStartIndex startIndex: Int,
    toEndIndex endIndex: Int
  ) throws -> UniformInterpolator<T> {
    
    guard startIndex >= 0 && startIndex < self.rangeInput.count else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "startIndex out of bounds"
      );
    };
    
    guard endIndex >= 0 && endIndex < self.rangeInput.count else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "endIndex out of bounds"
      );
    };
    
    guard startIndex != endIndex else {
      throw GenericError(
        errorCode: .indexOutOfBounds,
        description: "startIndex and endIndex cannot be the same"
      );
    };
    
    let inputStart = rangeInput[startIndex];
    let inputEnd   = rangeInput[startIndex];
    
    let outputStart = rangeOutput[endIndex];
    let outputEnd   = rangeOutput[endIndex];
    
    let interpolator = UniformInterpolator(
      inputValueStart : inputStart ,
      inputValueEnd   : inputEnd   ,
      outputValueStart: outputStart,
      outputValueEnd  : outputEnd
    );
    
    return interpolator;
  };
  
  public mutating func interpolate(inputValue: CGFloat) -> T {
    let inputValuePrev = self.inputValueCurrent;
    
    self.inputValuePrev = inputValuePrev;
    self.inputValueCurrent = inputValue;
  
    let matchInterpolator = self.interpolators.getInterpolator(
      forInputValue: inputValue,
      withStartIndex: self.currentInterpolationIndex
    );
    
    if false {
      let x: (any Interpolator)? = nil;
      let y = x!;
      
      let z = y.interpolate(
        inputValue: inputValue,
        easing: nil,
        shouldClampLeft: false,
        shouldClampRight: false
      );
      
      //return z;
    };
    
    if let (interpolatorIndex, interpolator) = matchInterpolator {
      self.interpolationModeCurrent =
        .interpolate(interpolatorIndex: interpolatorIndex);
        
      let temp =  interpolator.interpolate(inputValue: inputValue);
      return temp;
    };
    
    // extrapolate left
    if inputValue < rangeInput.first! {
      self.interpolationModeCurrent = .extrapolateLeft;
    
      guard !self.shouldClampMin else {
        return rangeOutput.first!;
      };
      
      return self.extrapolatorLeft.interpolate(
        inputValue: inputValue,
        easingOverride: .linear
      );
    };
    
    // extrapolate right
    if inputValue > rangeInput.last! {
      self.interpolationModeCurrent = .extrapolateRight;
      
      guard !self.shouldClampMax else {
        return rangeOutput.last!;
      };
        
      return self.extrapolatorRight.interpolate(
        inputValue: inputValue,
        easingOverride: .linear
      );
    };
    
    // this shouldn't be called
    return T.interpolate(
      inputValue: inputValue,
      inputValueStart: self.rangeInput.first!,
      inputValueEnd: self.rangeInput.last!,
      outputValueStart: self.rangeOutput.first!,
      outputValueEnd: self.rangeOutput.last!,
      easing: .linear
    );
  };
};

private extension RangeInterpolator {
  
  static func checkIfValid(
    rangeInput: [CGFloat],
    rangeOutput: [T]
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
  };
  
  static func createInBetweenInterpolators(
    rangeInput: [CGFloat],
    rangeOutput: [T]
  ) -> [UniformInterpolator<T>] {
  
    var interpolators: [UniformInterpolator<T>] = [];
    
    let a = rangeOutput as? [any CompositeInterpolatable];
    let b = T.self as? any CompositeInterpolatable.Type;
    
    for index in 0..<rangeInput.count - 1 {
      let inputStart = rangeInput[index];
      let inputEnd   = rangeInput[index + 1];
      
      let outputStart = rangeOutput[index];
      let outputEnd   = rangeOutput[index + 1];
      
      let interpolator = UniformInterpolator<T>(
        inputValueStart : inputStart ,
        inputValueEnd   : inputEnd   ,
        outputValueStart: outputStart,
        outputValueEnd  : outputEnd
      );
      
      interpolators.append(interpolator);
    };
    
    return interpolators;
  };
};

// MARK: - Array+UniformInterpolator
// ---------------------------------

fileprivate extension Array {

  func getInterpolator<T>(
    forInputValue inputValue: CGFloat,
    withStartIndex startIndex: Int? = nil
  ) -> IndexValuePair<UniformInterpolator<T>>? where Element == UniformInterpolator<T> {
    
    let predicate: (_ interpolator: UniformInterpolator<T>) -> Bool = {
         inputValue >= $0.inputValueStart
      && inputValue <= $0.inputValueEnd;
    };
    
    guard let startIndex = startIndex else {
      return self.indexedFirst { _, interpolator in
        predicate(interpolator);
      };
    };
    
    return self.indexedFirstBySeekingForwardAndBackwards(startIndex: startIndex) { item, _ in
      predicate(item.value);
    };
  };
};








public struct Box<T: UniformInterpolatable>: Interpolator {
  public init(inputValueStart: CGFloat, inputValueEnd: CGFloat, outputValueStart: T, outputValueEnd: T, hasCustomInputRange: Bool) {
    fatalError()
  }
  
  public var inputValueStart: CGFloat
  
  public var inputValueEnd: CGFloat
  
  public var outputValueStart: T
  
  public var outputValueEnd: T
  
  public var hasCustomInputRange: Bool
  
  public typealias InterpolatableValue = T;
};
