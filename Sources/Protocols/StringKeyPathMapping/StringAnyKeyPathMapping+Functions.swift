//
//  StringAnyKeyPathMapping+Functions.swift
//
//
//  Created by Dominic Go on 12/27/23.
//

import Foundation


/// Cached values for `StringAnyKeyPathMapping.anyKeyPathValueTypes`
/// for each type that conforms to `StringAnyKeyPathMapping`.
///
fileprivate var __cacheAnyKeyPathValueTypes:
  Dictionary<String, [StringAnyKeyPathMapping.Type]> = [:];

/// Cached values for
/// `StringAnyKeyPathMapping.recursivelyGetAllAnyKeyPathValueTypes`
/// for each type that conforms to `StringAnyKeyPathMapping`.
///
fileprivate var __cacheAllAnyKeyPathValueTypes:
  Dictionary<String, [StringAnyKeyPathMapping.Type]> = [:];

extension StringAnyKeyPathMapping {

  // MARK: - Private - Caching Helpers
  // ---------------------------------
  
  private static var _typeName: String {
    String(describing: Self.self);
  };
  
  /// Cached values for `StringAnyKeyPathMapping.anyKeyPathValueTypes`
  private static var _cacheAnyKeyPathValueTypes: [StringAnyKeyPathMapping.Type]? {
    get {
      __cacheAnyKeyPathValueTypes[Self._typeName];
    }
    set {
      __cacheAnyKeyPathValueTypes[Self._typeName] = newValue;
    }
  };
  
  /// Cached values for
  /// `StringAnyKeyPathMapping.recursivelyGetAllAnyKeyPathValueTypes`
  ///
  private static var _cacheAllAnyKeyPathValueTypes: [StringAnyKeyPathMapping.Type]? {
    get {
      __cacheAllAnyKeyPathValueTypes[Self._typeName];
    }
    set {
      __cacheAllAnyKeyPathValueTypes[Self._typeName] = newValue;
    }
  };
  
  // MARK: - Private Helpers
  // -----------------------

  /// All of the `Value.Type` items from `KeyPath<Root, Value>` in
  /// `Self.anyKeyPathMap`, that conforms to `StringAnyKeyPathMapping`.
  ///
  private static var anyKeyPathValueTypes: [StringAnyKeyPathMapping.Type] {
    if let _cacheAnyKeyPathValueTypes = Self._cacheAnyKeyPathValueTypes {
      return _cacheAnyKeyPathValueTypes;
    };
  
    let types = Self.anyKeyPathMap.compactMap {
      let keyPath = $0.value;
      let keyPathValueType = type(of: keyPath).valueType;
      
      return keyPathValueType as? StringAnyKeyPathMapping.Type;
    };
    
    var uniqueTypes: [StringAnyKeyPathMapping.Type] = [];
    
    for type in types {
      let match = uniqueTypes.first {
        $0 == type;
      };
      
      /// skip `type` item if already exists in `uniqueTypes`
      guard match == nil else { continue };
      uniqueTypes.append(type);
    };
    
    Self._cacheAnyKeyPathValueTypes = uniqueTypes;
    return uniqueTypes;
  };
  
  private static var recursiveAnyKeyPathValueTypes: [StringAnyKeyPathMapping.Type] {
    Self.recursivelyGetAllAnyKeyPathValueTypes();
  };
  
  private static func recursivelyGetAllAnyKeyPathValueTypes(
    currentItems: [StringAnyKeyPathMapping.Type]? = nil
  ) -> [StringAnyKeyPathMapping.Type] {
    
    if let _cacheAllAnyKeyPathValueTypes = Self._cacheAllAnyKeyPathValueTypes {
      return _cacheAllAnyKeyPathValueTypes;
    };
  
    var allAnyKeyPathValueTypes: [StringAnyKeyPathMapping.Type] = [Self.self];
    
    for anyKeyPathValueType in Self.anyKeyPathValueTypes {
      let shouldSkip: Bool = {
        guard let currentItems = currentItems else { return false };
        
        let match = currentItems.first {
          $0 == anyKeyPathValueType;
        };
        
        // Duplicate - current item already exists in
        // `allAnyKeyPathValueTypes`.
        return match != nil;
      }();
      
      guard !shouldSkip else { continue };
      allAnyKeyPathValueTypes.append(anyKeyPathValueType);
      
      allAnyKeyPathValueTypes +=
        anyKeyPathValueType.recursivelyGetAllAnyKeyPathValueTypes(
          currentItems: allAnyKeyPathValueTypes
        );
    };
    
    Self._cacheAllAnyKeyPathValueTypes = allAnyKeyPathValueTypes;
    return allAnyKeyPathValueTypes;
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public static func getAnyKeyPath(
    forKey stringKey: String
  ) throws -> AnyKeyPath {
    
    /// Converts "string key" literal: "foo.bar.baz",
    /// to an array of string keys: `["foo", "bar", "baz"]`
    ///
    let stringKeys: [String] = {
      let rawKeys = stringKey.components(separatedBy: ".");

      return rawKeys.compactMap {
        let components = $0.components(
          separatedBy: CharacterSet.alphanumerics.inverted
        );
        
        let filteredString = components.joined();
        guard !filteredString.isEmpty else { return nil };
        
        return filteredString;
      };
    }();
    
    guard stringKeys.count > 0 else {
      throw GenericError(
        errorCode: .guardCheckFailed,
        description: "Number of keys in key path must be > 0",
        extraDebugValues: [
          "stringKey": stringKey,
        ]
      );
    };
    
    let allAnyKeyPathValueTypes = Self.recursiveAnyKeyPathValueTypes;
    
    let anyKeyPaths = stringKeys.compactMap { stringKey in
      for typeItem in allAnyKeyPathValueTypes {
        guard let anyKeyPath = typeItem.anyKeyPathMap[stringKey]
        else { continue };
        
        return anyKeyPath;
      };
      
      return nil;
    };
    
    guard anyKeyPaths.count > 0 else {
      throw GenericError(
        errorCode: .guardCheckFailed,
        description: "Number of parsed keys in key path must be > 0",
        extraDebugValues: [
          "stringKey": stringKey,
        ]
      );
    };
    
    let combinedAnyKeyPath: AnyKeyPath = try {
      var keyPaths = anyKeyPaths;
      let rootKeyPath = keyPaths.removeFirst();
      
      return try keyPaths.reduce(rootKeyPath) {
        guard let combined = $0.appending(path: $1) else {
          throw GenericError(
            errorCode: .guardCheckFailed,
            description: "Unable to combine key paths together",
            extraDebugValues: [
              "stringKey": stringKey,
              "anyKeyPaths": anyKeyPaths,
              "keyPathCurrent": $0,
              "keyPathNext": $1,
            ]
          );
        };
        
        return combined;
      };
    }();
    
    return combinedAnyKeyPath;
    
    /*
    let rootKeyPath: KeyPath<Self, T>? = {
      guard let partialKeyPath = Self.stringToKeyPathMap[stringKey] else {
        throw "No matching key path value for string key"
      };

      guard let keyPath = value as? KeyPath<Self, T> else {
        throw "Unable to cast partial key path to target type";
      };

      return keyPath;
    }();
    */
  };
  
  public static func getPartialKeyPath(
    forKey stringKey: String
  ) throws -> PartialKeyPath<Self> {
    
    let anyKeyPath = try Self.getAnyKeyPath(forKey: stringKey);
    
    guard let partialKeyPath = anyKeyPath as? PartialKeyPath<Self> else {
      throw GenericError(
        errorCode: .guardCheckFailed,
        description: "Cast to PartialKeyPath failed",
        extraDebugValues: [
          "stringKey": stringKey,
          "anyKeyPath": anyKeyPath,
          "Self": String(describing: Self.self),
        ]
      );
    };
    
    return partialKeyPath;
  };
  
  public static func getKeyPath<T>(
    forKey stringKey: String,
    valueType: T.Type
  ) throws -> KeyPath<Self, T> {
    
    let partialKeyPath = try Self.getPartialKeyPath(forKey: stringKey);
    
    guard let keyPath = partialKeyPath as? KeyPath<Self, T> else {
      throw GenericError(
        errorCode: .guardCheckFailed,
        description: "Cast to KeyPath failed",
        extraDebugValues: [
          "stringKey": stringKey,
          "partialKeyPath": partialKeyPath,
          "Self": String(describing: Self.self),
          "valueType": String(describing: T.self),
        ]
      );
    };
    
    return keyPath;
  };
};
