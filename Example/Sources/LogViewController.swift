//
//  LogViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 7/17/24.
//

import UIKit
import DGSwiftUtilities


class LogViewController: UIViewController {
  
  var textItems: [AttributedStringConfig] = [];

  override func viewDidLoad() {
    super.viewDidLoad();
    self.view.backgroundColor = .white;
    
    self.view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10);
    
    let label = {
      let label = UILabel();
      
      label.font = nil;
      label.textColor = nil;
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      
      label.attributedText = self.textItems.makeAttributedString();
      
      return label;
    }();
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      scrollView.alwaysBounceVertical = true;
      return scrollView
    }();
    
    label.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(label);
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      label.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      label.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
      
      label.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: -24
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      scrollView.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
      scrollView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
      ),
      scrollView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
      ),
    ]);
  };
};
