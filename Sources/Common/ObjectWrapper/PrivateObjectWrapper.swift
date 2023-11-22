//
//  ObjectWrapperBase.swift
//  
//
//  Created by Dominic Go on 9/18/23.
//

import Foundation


open class PrivateObjectWrapper<
  WrapperType: AnyObject,
  EncodedString: PrivateObjectWrappingEncodedString
>: ObjectWrapper<
  WrapperType,
  EncodedString
> {

  public override init?(
    objectToWrap sourceObject: AnyObject,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject as? NSObject,
          let className = EncodedString.className.decodedString,
          sourceObject.className == className
    else { return nil };
    
    super.init(
      objectToWrap: sourceObject,
      shouldRetainObject: shouldRetainObject
    );
  };
};



