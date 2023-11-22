//
//  VerboseError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation


public struct VerboseError<
  Metadata: ErrorMetadata,
  Code: ErrorCode
>: LocalizedError {

  public var errorCode: Code?;
  public var description: String?;
  
  public var extraDebugValues: Dictionary<String, Any>?;
  public var extraDebugInfo: String?;

  public var fileName: String;
  public var lineNumber: Int;
  public var columnNumber: Int;
  public var functionName: String;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var debugTrace: String {
    var string = "fileName: \(self.fileName)";
    
    if let parentType = Metadata.parentType {
      string += " - type: \(parentType)";
    };
    
    string += " - functionName: \(self.functionName)";
    string += " - lineNumber: \(self.lineNumber)";
    string += " - columnNumber: \(self.columnNumber)";
    
    return string;
  };
  
  var extraDebugValuesString: String? {
    guard let extraDebugValues = self.extraDebugValues else { return nil };
    
    let items = extraDebugValues.enumerated().map {
      var string = "\($0.element.key): \($0.element.value)";
      
      let isLastItem = ($0.offset == extraDebugValues.count - 1);
      string += isLastItem ? "" : ", ";
      
      return string;
    };
    
    let itemsString = items.reduce("") {
      $0 + $1;
    };
    
    return "extraDebugValuesString: { \(itemsString) }";
  };
  
  public var baseErrorMessage: String {
    var strings: [String] = [];
    
    if let domain = Metadata.domain {
      strings.append("domain: \(domain)");
    };
  
    if let errorCode = self.errorCode {
      strings.append("code: \(errorCode.rawValue)");
    };
    
    if let description = self.description {
      strings.append("description: \(description)");
    };
  
    if let extraDebugInfo = self.extraDebugInfo {
      strings.append("extraDebugInfo: \(extraDebugInfo)");
    };
    
    if let extraDebugValuesString = self.extraDebugValuesString {
      strings.append("extraDebugValues: \(extraDebugValuesString)");
    };
    
    return strings.enumerated().reduce("") { acc, next in
      let prefix = next.offset > 0 ? " - " : "";
      return acc + prefix + next.element;
    };
  };
  
  public var errorDescription: String? {
    "\(self.baseErrorMessage) - \(self.debugTrace)";
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    description: String,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function
  ) {
  
    self.description = description;
    
    self.extraDebugValues = extraDebugValues;
    self.extraDebugInfo = extraDebugInfo;
    
    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
  };
  
  public init(
    errorCode: Code,
    description: String? = nil,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function
  ) {
    
    self.errorCode = errorCode;
    self.description = description ?? errorCode.description;
    
    self.extraDebugValues = extraDebugValues;
    self.extraDebugInfo = extraDebugInfo;
    
    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
  };
  
  // MARK: - Functions
  // -----------------
  
  func log(){
    #if DEBUG
    guard let errorDescription = self.errorDescription else { return };
    print("Error -", errorDescription);
    #endif
  };
};
