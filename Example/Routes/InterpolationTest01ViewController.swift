//
//  InterpolationTest01ViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 7/17/24.
//

import UIKit
import DGSwiftUtilities




class InterpolationTest01ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    self.view.backgroundColor = .white;
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 15;
                
      return stack;
    }();
    
    var cardConfig: [CardConfig] = [];
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100, -1, 0, 1, 100];
      let sharedInputValues: [CGFloat] = [
        -100, -1, 0, 1, 100,
        -1000, -500, -200, -50, -0.5, 0.5, 50, 75, 200, 500, 1000,
      ];
    
      return .init(
        title: "Basic Testing by Logging",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGFloat>"),
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGFloat>(
                rangeInput : sharedRangeInputValues,
                rangeOutput: [-1000, -10, 0, 10, 1000]
              );
              
              var textItems: [AttributedStringConfig] = [];
              
              textItems += rangedInterpolator.metadataAsAttributedStringConfig;
              textItems.append(.newLine);
              
              textItems += sharedInputValues.enumerated().reduce(into: []) {
                let result = rangedInterpolator.interpolate(
                  inputValue: $1.element
                );
                
                $0 += [
                  .init(text: "\($1.offset)"),
                  .init(text: " - input: \($1.element)"),
                  .init(text: " - result: \(result)"),
                ];
                
                if let interpolator = rangedInterpolator.currentInterpolator {
                  $0.append(.newLine);
                  $0 += interpolator.metadataAsAttributedStringConfig;
                };
                
                $0.append(.newLines(2));
              };
              
              let attributedString = textItems.makeAttributedString();
              print(attributedString.string);
              
              let modalVC = LogViewController();
              modalVC.textItems = textItems;
              
              self.present(modalVC, animated: true);
            }
          ),
        ]
      );
    }());
    
    cardConfig.forEach {
      let cardView = $0.createCardView();
      stackView.addArrangedSubview(cardView.rootVStack);
      stackView.setCustomSpacing(15, after: cardView.rootVStack);
    };
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      scrollView.alwaysBounceVertical = true;
      return scrollView
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      stackView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      stackView.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
      
      stackView.widthAnchor.constraint(
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

extension RangeInterpolator {
  
  var metadataAsAttributedStringConfig: [AttributedStringConfig] {
    return [
      .init(text: "rangeInput: "),
      .init(text: self.rangeInput.description),
      .newLine,
      
      .init(text: "rangeOutput: "),
      .init(text: self.rangeOutput.description),
      .newLines(2),
    ];
  };
};

extension Interpolator {

  var metadataAsAttributedStringConfig: [AttributedStringConfig] {
    return [
      .init(text: "inputValueStart: \(self.inputValueStart)"),
      .newLine,
      .init(text: "inputValueEnd: \(self.inputValueEnd)"),
      .newLine,
      .init(text: "outputValueStart: \(self.outputValueStart)"),
      .newLine,
      .init(text: "outputValueEnd: \(self.outputValueEnd)"),
    ];
  };
};
