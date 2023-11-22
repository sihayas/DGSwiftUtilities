//
//  ObjectWrapper.swift
//  
//
//  Created by Dominic Go on 11/6/23.
//

import Foundation


open class ObjectWrapper<
  WrapperType: AnyObject,
  EncodedString: HashedStringDecodable
> {

  public var objectWrapper: ObjectContainer<WrapperType>;
  
  public var wrappedObject: WrapperType? {
    self.objectWrapper.object;
  }; 
  
  public init?(
    objectToWrap sourceObject: AnyObject,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject as? NSObject else { return nil };
  
    self.objectWrapper = .init(
      objectToWrap: sourceObject,
      shouldRetainObject: shouldRetainObject
    );
  };
  
  @discardableResult
  public func performSelector<T>(
    usingEncodedString encodedString: EncodedString,
    withArg1 arg1: Any? = nil,
    withArg2 arg2: Any? = nil,
    type: T.Type = Any.self,
    shouldRetainValue: Bool = false
  ) throws -> T? {
  
    guard let wrappedObject = self.wrappedObject else {
      throw GenericError(
        errorCode: .unexpectedNilValue,
        description: "Could not get wrapped object"
      );
    };
    
    return try ObjectWrapperHelpers.performSelector(
      forObject: wrappedObject,
      selectorFromHashedString: encodedString,
      withArg1: arg1,
      withArg2: arg2,
      type: type,
      shouldRetainValue: shouldRetainValue
    );
  };
  
  public func debugPrintWrappedObject(){
    #if DEBUG
    print(self.wrappedObject.debugDescription);
    #endif
  };
};
