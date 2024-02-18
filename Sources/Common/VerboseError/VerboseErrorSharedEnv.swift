//
//  VerboseErrorSharedEnv.swift
//  
//
//  Created by Dominic Go on 2/18/24.
//

import Foundation

public struct VerboseErrorSharedEnv {
  public static var overrideShouldLogFileMetadata: Bool?;
  public static var overrideShouldLogFilePath: Bool?;
  public static var overrideEnableLogStackTrace: Bool?;
};

public extension VerboseErrorSharedEnv {
  @available(*, deprecated, renamed: "overrideShouldLogFilePath")
  static var shouldLogFileMetadata: Bool? {
    Self.overrideShouldLogFilePath;
  };
  
  @available(*, deprecated, renamed: "overrideShouldLogFilePath")
  static var shouldLogFilePath: Bool? {
    Self.overrideShouldLogFilePath;
  };
};
