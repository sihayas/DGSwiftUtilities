//
//  ObjectWrappingEncodedString.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import Foundation

public protocol ObjectWrappingEncodedString: HashedStringDecodable {
  static var className: Self { get };
};
