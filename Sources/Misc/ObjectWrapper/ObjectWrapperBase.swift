//
//  ObjectWrapperBase.swift
//  
//
//  Created by Dominic Go on 9/18/23.
//

import Foundation


open class ObjectWrapperBase<
  WrapperType,
  EncodedString: ObjectWrappingEncodedString
> {

  public var objectWrapper: ObjectContainer<WrapperType>;
  
  public var wrappedObject: WrapperType? {
    self.objectWrapper.object;
  }; 
  
  public init?(
    objectToWrap sourceObject: AnyObject?,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject as? NSObject,
          let className = EncodedString.className.decodedString,
          sourceObject.className == className
    else { return nil };
  
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



