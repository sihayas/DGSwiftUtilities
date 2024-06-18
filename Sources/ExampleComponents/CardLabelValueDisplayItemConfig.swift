//
//  CardLabelValueDisplayItemConfig.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/15/24.
//

import UIKit

public enum CardLabelValueDisplayItemConfig {
  
  public static func singleRowPlain(label: String, value: String) -> Self {
    .singleRow(
      label: [.init(text: label)],
      value: [.init(text: value)]
    );
  };
  
  public static func singleRowPlain(
    label: String,
    value: CustomStringConvertible
  ) -> Self {
    .singleRow(
      label: [.init(text: label)],
      value: [.init(text: value.description)]
    );
  };
  
  public static func singleRowPlain(
    label: String,
    value: CustomDebugStringConvertible
  ) -> Self {
    .singleRow(
      label: [.init(text: label)],
      value: [.init(text: value.debugDescription)]
    );
  };
  
  case singleRow(
    label: [AttributedStringConfig],
    value: [AttributedStringConfig]
  );
  
  public func createView(colorThemeConfig: ColorThemeConfig) -> UIView {
    let rootHStack = {
      let stack = UIStackView();
      
      stack.axis = .horizontal;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
                
      return stack;
    }();
    
    switch self {
      case let .singleRow(labelConfigRaw, valueConfigRaw):
        var labelConfig = labelConfigRaw;
        labelConfig.append(.init(text: ":"));
        
        labelConfig = labelConfig.map {
          var configItem = $0;
          if configItem.foregroundColor == nil {
            configItem.foregroundColor = colorThemeConfig.colorTextDark;
          };
          
          if configItem.fontConfig.weight == nil {
            configItem.fontConfig.weight = .semibold;
          };
          
          return configItem;
        };
        
        let valueConfig = valueConfigRaw.map {
          var configItem = $0;
          if configItem.foregroundColor == nil {
            configItem.foregroundColor = colorThemeConfig.colorTextDark;
          };
          
          if configItem.fontConfig.weight == nil {
            configItem.fontConfig.weight = .regular;
          };
          
          return configItem;
        };
        
        let leftTitleLabel = UILabel();
        leftTitleLabel.attributedText = labelConfig.makeAttributedString();
        
        rootHStack.addArrangedSubview(leftTitleLabel);
        
        let rightValueLabel = UILabel();
        rightValueLabel.attributedText = valueConfig.makeAttributedString();
        
        rootHStack.addArrangedSubview(rightValueLabel);
    };
    
    return rootHStack;
  };
};
