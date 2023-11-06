//
//  ObjectWrapper.swift
//  
//
//  Created by Dominic Go on 11/6/23.
//

import Foundation


open class ObjectWrapper<
  WrapperType,
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
  
  public func debugPrintWrappedObject(){
    #if DEBUG
    print(self.wrappedObject.debugDescription);
    #endif
  };
};
