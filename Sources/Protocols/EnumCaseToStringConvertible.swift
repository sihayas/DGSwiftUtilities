//
//  EnumCaseToStringConvertible.swift
//  
//
//  Created by Dominic Go on 12/17/23.
//

import Foundation

public protocol EnumCaseToStringConvertible: Hashable {
  static var enumCaseStringMap: Dictionary<Self, String> { get };
};

public extension EnumCaseToStringConvertible {

  var caseString: String? {
    Self.enumCaseStringMap[self];
  };
  
  init?(fromString string: String){
    
    let match = Self.enumCaseStringMap.first {
      $0.value == string;
    };
    
    guard let match = match else { return nil };
    self = match.key;
  };
};
