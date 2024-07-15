//
//  Array+Interpolator.swift
//  
//
//  Created by Dominic Go on 7/15/24.
//

import Foundation


public extension Array where Element == Interpolator {

  func getInterpolator(
    forInputValue inputValue: CGFloat,
    withStartIndex startIndex: Int? = nil
  ) -> IndexValuePair<Interpolator>? {
    
    let predicate: (_ interpolator: Interpolator) -> Bool = {
         inputValue >= $0.inputValueStart
      && inputValue <= $0.inputValueEnd;
    };
    
    guard let startIndex = startIndex else {
      return self.indexedFirst { _, interpolator in
        predicate(interpolator);
      };
    };
    
    return self.indexedFirstBySeekingForwardAndBackwards(startIndex: startIndex) { item, _ in
      predicate(item.value);
    };
  };
};
