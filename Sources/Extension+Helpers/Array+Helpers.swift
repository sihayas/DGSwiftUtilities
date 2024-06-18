//
//  Array+Helpers.swift
//  
//
//  Created by Dominic Go on 6/16/24.
//

import Foundation

public extension Array {

  subscript(cyclicIndex index: Index) -> Element {
    get {
      self[self.index(forCyclicIndex: index)];
    }
    set {
      self[self.index(forCyclicIndex: index)] = newValue;
    }
  }
  
  func index(forCyclicIndex cyclicIndex: Index) -> Index {
    return cyclicIndex % self.count;
  };
  
  func first<T>(whereType type: T.Type) -> T? {
    let match = self.first {
      $0 is T;
    };
    
    return match as? T;
  };
};
