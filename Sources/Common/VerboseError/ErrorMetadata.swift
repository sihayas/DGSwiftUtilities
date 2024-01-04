//
//  RNIErrorMetadata.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation

public protocol ErrorMetadata {

  static var domain: String? { get };
  static var parentType: String? { get };
  
  static var shouldLogFileMetadata: Bool { get };
  static var shouldLogFilePath: Bool { get };
  static var shouldLogStackTrace: Bool { get };
};

extension ErrorMetadata {
  public static var shouldLogFileMetadata: Bool {
    return true;
  };
  
  public static var shouldLogFilePath: Bool {
    return true;
  };
  
  public static var shouldLogStackTrace: Bool {
    return false;
  };
};
