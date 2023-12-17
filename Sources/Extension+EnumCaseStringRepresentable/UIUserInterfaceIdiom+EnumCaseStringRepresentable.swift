//
//  UIUserInterfaceIdiom+EnumCaseStringRepresentable.swift
//  
//
//  Created by Dominic Go on 12/17/23.
//

import UIKit


extension UIUserInterfaceIdiom: EnumCaseStringRepresentable {
  public var caseString: String {
    switch self {
      case .unspecified:
        return "unspecified";

      case .phone:
        return "phone";

      case .pad:
        return "pad";

      case .tv:
        return "tv";

      case .carPlay:
        return "carPlay";

      case .mac:
        return "mac";

      case .vision:
        return "vision";
      
      @unknown default:
        #if DEBUG
        print("Runtime Warning - Not implemented");
        #endif
        return "";
    };
  };
};
