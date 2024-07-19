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
      let sharedRangeOutputValues: [CGFloat] = [-1000, -10, 0, 10, 1000];
      
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
                rangeOutput: sharedRangeOutputValues
              );
              
              let results = Helpers.invokeRangedInterpolatorAndGetResults(
                with: sharedInputValues,
                rangedInterpolator: &rangedInterpolator
              );
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
            }
          ),
          
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGRect>"),
            ],
            handler: { _,_ in
            
              var rangedInterpolator = try! RangeInterpolator<CGRect>(
                rangeInput : sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0, width: $0, height: $0)
                }
              );
              
              let results = Helpers.invokeRangedInterpolatorAndGetResults(
                with: sharedInputValues,
                rangedInterpolator: &rangedInterpolator
              );
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
            }
          ),
          
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGSize>"),
            ],
            handler: { _,_ in
            
              var rangedInterpolator = try! RangeInterpolator<CGSize>(
                rangeInput : sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(width: $0, height: $0)
                }
              );
              
              let results = Helpers.invokeRangedInterpolatorAndGetResults(
                with: sharedInputValues,
                rangedInterpolator: &rangedInterpolator
              );
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
            }
          ),
          
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGPoint>"),
            ],
            handler: { _,_ in
            
              var rangedInterpolator = try! RangeInterpolator<CGPoint>(
                rangeInput : sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0)
                }
              );
              
              let results = Helpers.invokeRangedInterpolatorAndGetResults(
                with: sharedInputValues,
                rangedInterpolator: &rangedInterpolator
              );
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
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
    var items: [AttributedStringConfig] = [
      .init(text: "rangeInput: "),
      .init(text: self.rangeInput.description),
      .newLine,
    ];
    
    items.append(
      .init(text: "rangeOutput: ")
    );
    
    items += {
      let isInterpolatingCGFloat = type(of: self).genericType == CGFloat.self;
      
      return isInterpolatingCGFloat ? [
        .init(text: self.rangeOutput.description),
      ]
      : self.rangeOutput.enumerated().reduce(into: []){
        $0 += [
          .newLine,
          .init(text: "\($1.offset). "),
          .init(text: "\($1.element)"),
        ];
      }
    }();
    
    items.append(.newLine);
    return items;
  };
  
  mutating func interpolateAndGetMetadataAsAttributedStringConfig(
    inputValue: CGFloat
  ) -> [AttributedStringConfig] {
    
    let result = self.interpolate(inputValue: inputValue);
    
    return [
      .init(text: "inputValue: \(inputValue)"),
      .newLine,
      .init(text: "result: \(result)"),
    ];
  };
};

extension UniformInterpolator {

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

fileprivate struct Helpers {

  static func invokeRangedInterpolatorAndGetResults<T>(
    with inputValues: [CGFloat],
    rangedInterpolator: inout RangeInterpolator<T>
  ) -> [AttributedStringConfig] {
  
    var textItems: [AttributedStringConfig] = [];
    textItems += rangedInterpolator.metadataAsAttributedStringConfig;
    textItems.append(.newLine);
    
    textItems += inputValues.enumerated().reduce(into: []) {
      $0.append(.init(text: "\($1.offset). "));
      $0 += rangedInterpolator.interpolateAndGetMetadataAsAttributedStringConfig(inputValue: $1.element)
      
      if let interpolator = rangedInterpolator.currentInterpolator {
        $0.append(.newLine);
        $0 += interpolator.metadataAsAttributedStringConfig;
      };
      
      $0.append(.newLines(2));
    };
    
    return textItems;
  };
    
  static func logAndPresent(
    textItems: [AttributedStringConfig],
    parentVC: UIViewController
  ){
    let attributedString = textItems.makeAttributedString();
    print(attributedString.string);
    
    let modalVC = LogViewController();
    modalVC.textItems = textItems;
    
    parentVC.present(modalVC, animated: true);
  };
};
