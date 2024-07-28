//
//  ImageConfig.swift
//  
//
//  Created by Dominic Go on 7/28/24.
//

import UIKit


public protocol ImageConfig {
  
  var shouldCacheCreatedImage: Bool { get set };
  var state: ImageConfigState { get };
  
  var cachedImage: UIImage? { get };
  
  func preloadImage() throws;
  
  func makeImage() throws -> UIImage;
};

// MARK: - ImageConfig+Helpers
// ---------------------------

public extension ImageConfig {

  var isImageLoaded: Bool {
    self.state == .loaded;
  };
  
  mutating func makeImageIfNeeded() throws -> UIImage {
    if let cachedImage = self.cachedImage {
      return cachedImage;
    };
    
    return try self.makeImage();
  };
};

