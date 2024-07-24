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
      let sharedInputPercentPresets: [CGFloat] = [
        -2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2,
      ];
      
      return .init(
        title: "Basic Test for Interpolator<T>",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "Interpolator<CGRect>"),
            ],
            subtitle: [
              .init(text: "Tests for easingMap"),
            ],
            handler: { _,_ in
              let easingMapPresets: [(
                desc: String,
                easingMap: CGRect.EasingKeyPathMap
              )] = [
                (
                  desc: "Empty easingMap",
                  easingMap: [:]
                ),
                (
                  desc: "easeInCubic for size, easeOutCubic for origin",
                  easingMap: [
                    \CGSize.width: .easeInCubic,
                    \CGSize.height: .easeInCubic,
                    \CGPoint.x: .easeOutCubic,
                    \CGPoint.y: .easeOutCubic
                  ]
                ),
                (
                  desc: "easeInOutQuad for x, easeInOutCubic for y",
                  easingMap: [
                    \CGPoint.x: .easeInOutQuad,
                    \CGPoint.y: .easeInOutCubic
                  ]
                ),
                (
                  desc: (
                      "easeInQuad for x, easeOutCubic for y, "
                    + "easeInOutQuart for width, easeInOutExpo for height"
                  ),
                  easingMap: [
                    \CGPoint.x: .easeInQuad,
                    \CGPoint.y: .easeOutCubic,
                    \CGSize.width: .easeInOutQuart,
                    \CGSize.height: .easeInOutExpo
                  ]
                ),
                (
                  desc: (
                      "easeInSine for x, easeOutExpo for y, "
                    + "easeInOutQuart for width, easeInOutQuint for height"
                  ),
                  easingMap: [
                    \CGPoint.x: .easeInSine,
                    \CGPoint.y: .easeOutExpo,
                    \CGSize.width: .easeInOutQuart,
                    \CGSize.height: .easeInOutQuint
                  ]
                ),
              ];
              
              var results: [AttributedStringConfig] = [];
              
              var didLogInterpolatorMetadata = false;
              
              for (index, easingMapPreset) in easingMapPresets.enumerated() {
                let interpolator: Interpolator<CGRect> = .init(
                  valueStart : .init(x: 0  , y: 0  , width: 0  , height: 0  ),
                  valueEnd   : .init(x: 100, y: 100, width: 100, height: 100),
                  easingMap  : easingMapPreset.easingMap,
                  clampingMap: [:]
                );
                
                if !didLogInterpolatorMetadata {
                  results += interpolator.metadataAsAttributedStringConfig;
                  results.append(.newLines(2));
                  didLogInterpolatorMetadata = true;
                };
                
                results += [
                  .init(text: "easingMapPreset: \(index+1) of \(easingMapPresets.count)"),
                  .newLine,
                  .init(text: "preset desc: \(easingMapPreset.desc)"),
                  .newLine,
                  .init(text: "preset easingMap: \(easingMapPreset.easingMap)"),
                  .newLines(2),
                ];
                
                for (index, percentPreset) in sharedInputPercentPresets.enumerated() {
                  let result = interpolator.compute(usingPercentValue: percentPreset);
                  
                  results += [
                    .init(text: "percentPreset: \(index+1) of \(sharedInputPercentPresets.count)"),
                    .newLine,
                    .init(text: "inputPercent: \(percentPreset)"),
                    .newLine,
                    .init(text: "result: \(result)"),
                    .newLines(2),
                  ];
                }
              };
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
            }
          ),
          
          .filledButton(
            title: [
              .init(text: "Interpolator<CGRect>"),
            ],
            subtitle: [
              .init(text: "Tests for clamping"),
            ],
            handler: { _,_ in
              let clampingMapPresets: [(
                desc: String,
                clampingMap: CGRect.ClampingKeyPathMap
              )] = [
                (
                  desc: "Empty easingMap",
                  clampingMap: [:]
                ),
                (
                  desc: "clamp left for x, clamp right for width",
                  clampingMap: [
                    \CGPoint.x: .left,
                    \CGSize.width: .right,
                  ]
                ),
                (
                  desc: "clamp left for y, clamp right for height",
                  clampingMap: [
                    \CGPoint.y: .left,
                    \CGSize.height: .right,
                  ]
                ),
                (
                  desc: (
                      "clamp right for x, clamp left for y,"
                    + "clamp left for width, clamp right for height"
                  ),
                  clampingMap: [
                    \CGPoint.x: .right,
                    \CGPoint.y: .left,
                    \CGSize.width: .left,
                    \CGSize.height: .right,
                  ]
                ),
                (
                  desc: "clamp leftAndRight for all",
                  clampingMap: [
                    \CGPoint.x: .leftAndRight,
                    \CGPoint.y: .leftAndRight,
                    \CGSize.width: .leftAndRight,
                    \CGSize.height: .leftAndRight,
                  ]
                ),
              ];
              
              var results: [AttributedStringConfig] = [];
              var didLogInterpolatorMetadata = false;
              
              for (index, preset) in clampingMapPresets.enumerated() {
                let interpolator: Interpolator<CGRect> = .init(
                  valueStart : .init(x: 0  , y: 0  , width: 0  , height: 0  ),
                  valueEnd   : .init(x: 100, y: 100, width: 100, height: 100),
                  easingMap  : [:],
                  clampingMap: preset.clampingMap
                );
                
                if !didLogInterpolatorMetadata {
                  results += interpolator.metadataAsAttributedStringConfig;
                  results.append(.newLines(2));
                  didLogInterpolatorMetadata = true;
                };
                
                results += [
                  .init(text: "easingMapPreset: \(index+1) of \(clampingMapPresets.count)"),
                  .newLine,
                  .init(text: "preset desc: \(preset.desc)"),
                  .newLine,
                  .init(text: "preset clampingMap: \(preset.clampingMap)"),
                  .newLines(2),
                ];
                
                for (index, percentPreset) in sharedInputPercentPresets.enumerated() {
                  let result = interpolator.compute(usingPercentValue: percentPreset);
                  
                  results += [
                    .init(text: "percentPreset: \(index+1) of \(sharedInputPercentPresets.count)"),
                    .newLine,
                    .init(text: "inputPercent: \(percentPreset)"),
                    .newLine,
                    .init(text: "result: \(result)"),
                    .newLines(2),
                  ];
                }
              }
              
              Helpers.logAndPresent(
                textItems: results,
                parentVC: self
              );
            }
          ),
        ]
      );
    }());
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100, -1, 0, 1, 100];
      let sharedRangeOutputValues: [CGFloat] = [-1000, -10, 0, 10, 1000];
      
      let sharedInputValues: [CGFloat] = [
        -100, -1, 0, 1, 100,
        -1000, -500, -200, -50, -0.5, 0.5, 50, 75, 200, 500, 1000,
      ];
      
      return .init(
        title: "Basic Tests for RangeInterpolator",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGFloat>"),
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGFloat>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: nil
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
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0, width: $0, height: $0)
                },
                easingProvider: nil
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
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(width: $0, height: $0)
                },
                easingProvider: nil
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
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0)
                },
                easingProvider: nil
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
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100, -1, 0, 1, 100];
      let sharedRangeOutputValues: [CGFloat] = [-1000, -10, 0, 10, 1000];
      
      let sharedInputValues: [CGFloat] = [
        // exact
        -100, -1, 0, 1, 100,
        
        // extrapolate left
        -1000, -500, -200,
        
        // extrapolate right
        200, 500, 1000,
        
        // interpolate
        -80, -40, -50, -20, -10,
        -0.75, -0.5, -0.3,
        0.25, 0.5, 0.75,
        10, 20, 25, 40, 50, 75, 80,
      ];
      
      return .init(
        title: "Basic Tests for ElementInterpolatable",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<CGFloat>"),
            ],
            subtitle: [
              .init(text: "Test uniform easing via easingProvider")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGFloat>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: .rangeIndexAndInterpolatorType {
                  switch $1 {
                    case .extrapolateLeft:
                      return .easeOutCubic;
                      
                    case .extrapolateRight:
                      return .easeInCubic;
                      
                    case .interpolate:
                      break;
                  };
                  
                  return ($0 % 2 == 0)
                    ? .easeInCubic
                    : .easeOutCubic;
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "Extrapolator left = .easeOutCubic, "),
                .init(text: "extrapolator right = .easeInCubic, "),
                .init(text: "interpolator = .easeInCubic when odd position,"),
                .init(text: "interpolator = .easeOutCubic when even position,"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<CGFloat>"),
            ],
            subtitle: [
              .init(text: "Test uniform clamping via clampingOptions")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGFloat>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: nil,
                clampingOptions: .leftAndRight
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "clampingOptions = leftAndRight "),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
            subtitle: [
              .init(text: "Test composite easing via easingMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGRect>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0, width: $0, height: $0)
                },
                easingMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    \CGPoint.x: .easeInQuad,
                    \CGPoint.y: .easeInCubic,
                    \CGSize.width: .easeInQuart,
                    \CGSize.height: .easeInQuint,
                  ] : [
                    \CGPoint.x: .easeOutQuad,
                    \CGPoint.y: .easeOutCubic,
                    \CGSize.width: .easeOutQuart,
                    \CGSize.height: .easeOutQuint,
                  ];
                },
                clampingMapProvider: nil
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "x = easeInQuad, y = easeInCubic, width = easeInQuart, height = easeInQuint"),
                .newLines(2),
                .init(text: "When rangeIndex is odd, then: "),
                .init(text: "x = easeOutQuad, y = easeOutCubic, width = easeOutQuart, height = easeOutQuint"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
            subtitle: [
              .init(text: "Test composite clamping via clampingMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGRect>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0, width: $0, height: $0)
                },
                easingMapProvider: nil,
                clampingMapProvider: .returnOnly {
                  return [
                    \CGPoint.x: .left,
                    \CGPoint.y: .right,
                    \CGSize.width: .leftAndRight,
                    \CGSize.height: .none,
                  ];
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "clamping: "),
                .init(text: "x = left, y = right, width = leftAndRight, height = none"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
            subtitle: [
              .init(text: "Test composite easing via easingElementMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<CGRect>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues.map {
                  .init(x: $0, y: $0, width: $0, height: $0)
                },
                easingElementMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    .x: .easeOutQuad,
                    .y: .easeInOutCubic,
                    .width: .easeOutQuart,
                    .height: .easeInOutQuint,
                  ] : [
                    .x: .easeInQuad,
                    .y: .easeInOutCubic,
                    .width: .easeInQuart,
                    .height: .easeInOutQuint,
                  ];
                },
                clampingElementMapProvider: nil
                
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "x = easeOutQuad, y = easeInOutCubic, width = easeOutQuart, height = easeInOutQuint"),
                .newLines(2),
                .init(text: "When rangeIndex is odd, then: "),
                .init(text: "x = easeInQuad, y = easeInOutCubic, width = easeInQuart, height = easeInOutQuint"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100, -1, 0, 1, 100];
      let rangeOutputValues: [CGFloat] = [100, 0, 200, 50, 255];
      
      let sharedInputValues: [CGFloat] = [
        // exact
        -100, -1, 0, 1, 100,
        
        // extrapolate left
        -1000, -500, -200,
        
        // extrapolate right
        200, 500, 1000,
        
        // interpolate
        -80, -40, -50, -20, -10,
        -0.75, -0.5, -0.3,
        0.25, 0.5, 0.75,
        10, 20, 25, 40, 50, 75, 80,
      ];
      
      let sharedRangeOutputItems: [UIColor] = rangeOutputValues.map {
        .init(
          red: $0/255,
          green: $0/255,
          blue: $0/255,
          alpha: $0/255
        )
      };
      
      return .init(
        title: "Basic Tests for Interpolating UIColor",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<UIColor>"),
            ],
            subtitle: [
              .init(text: "Test uniform easing via easingProvider")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIColor>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputItems,
                easingProvider: .rangeIndexAndInterpolatorType {
                  switch $1 {
                    case .extrapolateLeft:
                      return .easeOutCubic;
                      
                    case .extrapolateRight:
                      return .easeInCubic;
                      
                    case .interpolate:
                      break;
                  };
                  
                  return ($0 % 2 == 0)
                    ? .easeInCubic
                    : .easeOutCubic;
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<UIColor>"),
                .newLine,
                .init(text: "Extrapolator left = .easeOutCubic, "),
                .init(text: "extrapolator right = .easeInCubic, "),
                .init(text: "interpolator = .easeInCubic when odd position,"),
                .init(text: "interpolator = .easeOutCubic when even position,"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100 , -1  , 0, 1  , 100 ];
      let rangeOutputValues     : [CGFloat] = [-1000, -100, 0, 100, 1000];
      
      let sharedInputValues: [CGFloat] = [
        // exact
        -100, -1, 0, 1, 100,
        
        // extrapolate left
        -1000, -500, -200,
        
        // extrapolate right
        200, 500, 1000,
        
        // interpolate
        -80, -40, -50, -20, -10,
        -0.75, -0.5, -0.3,
        0.25, 0.5, 0.75,
        10, 20, 25, 40, 50, 75, 80,
      ];
      
      let sharedRangeOutputValues: [Angle<CGFloat>] = rangeOutputValues.map {
        .degrees($0);
      };
      
      return .init(
        title: "Basic Tests for Interpolating Angle",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<Angle>"),
            ],
            subtitle: [
              .init(text: "Test uniform easing via easingProvider")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Angle<CGFloat>>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: .rangeIndexAndInterpolatorType {
                  switch $1 {
                    case .extrapolateLeft:
                      return .easeOutCubic;
                      
                    case .extrapolateRight:
                      return .easeInCubic;
                      
                    case .interpolate:
                      break;
                  };
                  
                  return ($0 % 2 == 0)
                    ? .easeInCubic
                    : .easeOutCubic;
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<Angle<CGFloat>>"),
                .newLine,
                .init(text: "Extrapolator left = .easeOutCubic, "),
                .init(text: "extrapolator right = .easeInCubic, "),
                .init(text: "interpolator = .easeInCubic when odd position,"),
                .init(text: "interpolator = .easeOutCubic when even position,"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<Angle>"),
            ],
            subtitle: [
              .init(text: "Test uniform clamping via clampingOptions")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Angle<CGFloat>>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: nil,
                clampingOptions: .leftAndRight
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<Angle<CGFloat>>"),
                .newLine,
                .init(text: "clampingOptions = leftAndRight "),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
    
    cardConfig.append({
      let sharedRangeInputValues : [CGFloat] = [-100 , -1  , 0, 1  , 100 ];
      let rangeOutputValues: [CGFloat] = [-1000, -100, 0, 100, 1000];
      
      let sharedInputValues: [CGFloat] = [
        // exact
        -100, -1, 0, 1, 100,
        
        // extrapolate left
        -1000, -500, -200,
        
        // extrapolate right
        200, 500, 1000,
        
        // interpolate
        -80, -40, -50, -20, -10,
        -0.75, -0.5, -0.3,
        0.25, 0.5, 0.75,
        10, 20, 25, 40, 50, 75, 80,
      ];
      
      let sharedRangeOutputValues: [Transform3D] = rangeOutputValues.map {
        .init(
          translateX: $0,
          translateY: $0,
          translateZ: $0,
          scaleX: $0,
          scaleY: $0,
          rotateX: .degrees($0),
          rotateY: .degrees($0),
          rotateZ: .degrees($0),
          perspective: $0,
          skewX: $0,
          skewY: $0
        );
      };
      
      return .init(
        title: "Basic Tests for Interpolating Transform3D",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<Transform3D>"),
            ],
            subtitle: [
              .init(text: "Test uniform easing via easingProvider")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Transform3D>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: .rangeIndexAndInterpolatorType {
                  switch $1 {
                    case .extrapolateLeft:
                      return .easeOutCubic;
                      
                    case .extrapolateRight:
                      return .easeInCubic;
                      
                    case .interpolate:
                      break;
                  };
                  
                  return ($0 % 2 == 0)
                    ? .easeInCubic
                    : .easeOutCubic;
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<Transform3D>"),
                .newLine,
                .init(text: "Extrapolator left = .easeOutCubic, "),
                .init(text: "extrapolator right = .easeInCubic, "),
                .init(text: "interpolator = .easeInCubic when odd position,"),
                .init(text: "interpolator = .easeOutCubic when even position,"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<Transform3D>"),
            ],
            subtitle: [
              .init(text: "Test uniform clamping via clampingOptions")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Transform3D>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: nil,
                clampingOptions: .leftAndRight
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<Transform3D>"),
                .newLine,
                .init(text: "clampingOptions = leftAndRight "),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<Transform3D>"),
            ],
            subtitle: [
              .init(text: "Test composite easing via Transform3D")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Transform3D>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    \Transform3D.translateX : .easeInQuad ,
                    \Transform3D.translateY : .easeInCubic,
                    \Transform3D.translateZ : .easeInQuart,
                    \Transform3D.scaleX     : .easeInQuint,
                    \Transform3D.scaleY     : .easeInQuad ,
                    \Transform3D.rotateX    : .easeInCubic,
                    \Transform3D.rotateY    : .easeInQuart,
                    \Transform3D.rotateZ    : .easeInQuint,
                    \Transform3D.perspective: .easeInQuad ,
                    \Transform3D.skewX      : .easeInCubic,
                    \Transform3D.skewY      : .easeInQuart,
                  ] : [
                    \Transform3D.translateX : .easeOutQuad ,
                    \Transform3D.translateY : .easeOutCubic,
                    \Transform3D.translateZ : .easeOutQuart,
                    \Transform3D.scaleX     : .easeOutQuint,
                    \Transform3D.scaleY     : .easeOutQuad ,
                    \Transform3D.rotateX    : .easeOutCubic,
                    \Transform3D.rotateY    : .easeOutQuart,
                    \Transform3D.rotateZ    : .easeOutQuint,
                    \Transform3D.perspective: .easeOutQuad ,
                    \Transform3D.skewX      : .easeOutCubic,
                    \Transform3D.skewY      : .easeOutQuart,
                  ];
                },
                clampingMapProvider: nil
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "easeInQuad = translateX, "),
                .init(text: "easeInCubic = translateY, "),
                .init(text: "easeInQuart = translateZ, "),
                .init(text: "easeInQuint = scaleX, "),
                .init(text: "easeInQuad = scaleY, "),
                .init(text: "easeInCubic = rotateX, "),
                .init(text: "easeInQuart = rotateY, "),
                .init(text: "easeInQuint = rotateZ, "),
                .init(text: "easeInQuad = perspective, "),
                .init(text: "easeInCubic = skewX, "),
                .init(text: "easeInQuart = skewY."),
                .newLines(2),
                .init(text: "easeOutQuad = translateX, "),
                .init(text: "easeOutCubic = translateY, "),
                .init(text: "easeOutQuart = translateZ, "),
                .init(text: "easeOutQuint = scaleX, "),
                .init(text: "easeOutQuad = scaleY, "),
                .init(text: "easeOutCubic = rotateX, "),
                .init(text: "easeOutQuart = rotateY, "),
                .init(text: "easeOutQuint = rotateZ, "),
                .init(text: "easeOutQuad = perspective, "),
                .init(text: "easeOutCubic = skewX, "),
                .init(text: "easeOutQuart = skewY"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<Transform3D>"),
            ],
            subtitle: [
              .init(text: "Test composite clamping via clampingMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Transform3D>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingMapProvider: nil,
                clampingMapProvider: .returnOnly {
                  return [
                    \Transform3D.translateX : .left,
                    \Transform3D.translateY : .right,
                    \Transform3D.translateZ : .leftAndRight,
                    \Transform3D.scaleX     : .none,
                    \Transform3D.scaleY     : .left,
                    \Transform3D.rotateX    : .right,
                    \Transform3D.rotateY    : .leftAndRight,
                    \Transform3D.rotateZ    : .none,
                    \Transform3D.perspective: .left,
                    \Transform3D.skewX      : .right,
                    \Transform3D.skewY      : .leftAndRight,
                  ];
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "clamping: "),
                .init(text: "left = translateX, "),
                .init(text: "right = translateY, "),
                .init(text: "leftAndRight = translateZ, "),
                .init(text: "none = scaleX, "),
                .init(text: "left = scaleY, "),
                .init(text: "right = rotateX, "),
                .init(text: "leftAndRight = rotateY, "),
                .init(text: "none = rotateZ, "),
                .init(text: "left = perspective, "),
                .init(text: "right = skewX, "),
                .init(text: "leftAndRight = skewY."),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<Transform3D>"),
            ],
            subtitle: [
              .init(text: "Test composite easing via easingElementMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<Transform3D>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingElementMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    .translateX : .easeInQuad  ,
                    .translateY : .easeOutQuad ,
                    .translateZ : .easeInQuart ,
                    .scaleX     : .easeOutQuart,
                    .scaleY     : .easeInQuint ,
                    .rotateX    : .easeOutQuint,
                    .rotateY    : .easeInQuad  ,
                    .rotateZ    : .easeOutQuad ,
                    .perspective: .easeInCubic ,
                    .skewX      : .easeOutCubic,
                    .skewY      : .easeInQuart ,
                  ] : [
                    .translateX : .easeInOutQuad ,
                    .translateY : .easeInOutCubic,
                    .translateZ : .easeInOutQuart,
                    .scaleX     : .easeInOutQuint,
                    .scaleY     : .easeInOutQuad ,
                    .rotateX    : .easeInOutCubic,
                    .rotateY    : .easeInOutQuart,
                    .rotateZ    : .easeInOutQuint,
                    .perspective: .easeInOutQuad ,
                    .skewX      : .easeInOutCubic,
                    .skewY      : .easeInOutQuart,
                  ];
                },
                clampingElementMapProvider: nil
                
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "translateX = easeInQuad, "),
                .init(text: "translateY = easeOutQuad, "),
                .init(text: "translateZ = easeInQuart, "),
                .init(text: "scaleX = easeOutQuart, "),
                .init(text: "scaleY = easeInQuint, "),
                .init(text: "rotateX = easeOutQuint, "),
                .init(text: "rotateY = easeInQuad, "),
                .init(text: "rotateZ = easeOutQuad, "),
                .init(text: "perspective = easeInCubic, "),
                .init(text: "skewX = easeOutCubic, "),
                .init(text: "skewY = easeInQuart,"),
                .newLines(2),
                .init(text: "When rangeIndex is odd, then: "),
                .init(text: "translateX = easeInOutQuad, "),
                .init(text: "translateY = easeInOutCubic, "),
                .init(text: "translateZ = easeInOutQuart, "),
                .init(text: "scaleX = easeInOutQuint, "),
                .init(text: "scaleY = easeInOutQuad, "),
                .init(text: "rotateX = easeInOutCubic, "),
                .init(text: "rotateY = easeInOutQuart, "),
                .init(text: "rotateZ = easeInOutQuint, "),
                .init(text: "perspective = easeInOutQuad, "),
                .init(text: "skewX = easeInOutCubic, "),
                .init(text: "skewY = easeInOutQuart."),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
    
    cardConfig.append({
      let sharedRangeInputValues: [CGFloat] = [-100 , -1  , 0, 1  , 100 ];
      let rangeOutputValues     : [CGFloat] = [-1000, -100, 0, 100, 1000];
      
      let sharedInputValues: [CGFloat] = [
        // exact
        -100, -1, 0, 1, 100,
        
        // extrapolate left
        -1000, -500, -200,
        
        // extrapolate right
        200, 500, 1000,
        
        // interpolate
        -80, -40, -50, -20, -10,
        -0.75, -0.5, -0.3,
        0.25, 0.5, 0.75,
        10, 20, 25, 40, 50, 75, 80,
      ];
      
      let sharedRangeOutputValues: [UIEdgeInsets] = rangeOutputValues.map {
        .init(
          top: $0,
          left: $0,
          bottom: $0,
          right: $0
        );
      };
      
      return .init(
        title: "Basic Tests for Interpolating UIEdgeInsets",
        desc: [],
        content: [
          .filledButton(
            title: [
              .init(text: "RangeInterpolator<UIEdgeInsets>"),
            ],
            subtitle: [
              .init(text: "Test uniform easing via easingProvider")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIEdgeInsets>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: .rangeIndexAndInterpolatorType {
                  switch $1 {
                    case .extrapolateLeft:
                      return .easeOutCubic;
                      
                    case .extrapolateRight:
                      return .easeInCubic;
                      
                    case .interpolate:
                      break;
                  };
                  
                  return ($0 % 2 == 0)
                    ? .easeInCubic
                    : .easeOutCubic;
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<UIEdgeInsets>"),
                .newLine,
                .init(text: "Extrapolator left = .easeOutCubic, "),
                .init(text: "extrapolator right = .easeInCubic, "),
                .init(text: "interpolator = .easeInCubic when odd position,"),
                .init(text: "interpolator = .easeOutCubic when even position,"),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<UIEdgeInsets>"),
            ],
            subtitle: [
              .init(text: "Test uniform clamping via clampingOptions")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIEdgeInsets>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingProvider: nil,
                clampingOptions: .leftAndRight
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "RangeInterpolator<UIEdgeInsets>"),
                .newLine,
                .init(text: "clampingOptions = leftAndRight "),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<UIEdgeInsets>"),
            ],
            subtitle: [
              .init(text: "Test composite easing via UIEdgeInsets")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIEdgeInsets>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    \UIEdgeInsets.left  : .easeInQuad ,
                    \UIEdgeInsets.right : .easeInCubic,
                    \UIEdgeInsets.top   : .easeInQuart,
                    \UIEdgeInsets.bottom: .easeInQuint,
                  ] : [
                    \UIEdgeInsets.left  : .easeOutQuad ,
                    \UIEdgeInsets.right : .easeOutCubic,
                    \UIEdgeInsets.top   : .easeOutQuart,
                    \UIEdgeInsets.bottom: .easeOutQuint,
                  ];
                },
                clampingMapProvider: nil
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "easeInQuad = left, "),
                .init(text: "easeInCubic = right, "),
                .init(text: "easeInQuart = top, "),
                .init(text: "easeInQuint = bottom."),
                .newLines(2),
                .init(text: "easeOutQuad = left, "),
                .init(text: "easeOutCubic = right, "),
                .init(text: "easeOutQuart = top, "),
                .init(text: "easeOutQuint = bottom."),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<UIEdgeInsets>"),
            ],
            subtitle: [
              .init(text: "Test composite clamping via clampingMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIEdgeInsets>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingMapProvider: nil,
                clampingMapProvider: .returnOnly {
                  return [
                    \UIEdgeInsets.left  : .left,
                    \UIEdgeInsets.right : .right,
                    \UIEdgeInsets.top   : .leftAndRight,
                    \UIEdgeInsets.bottom: .none,
                  ];
                }
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "clamping: "),
                .init(text: "left = left, "),
                .init(text: "right = right, "),
                .init(text: "leftAndRight = top, "),
                .init(text: "none = bottom."),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
              .init(text: "RangeInterpolator<UIEdgeInsets>"),
            ],
            subtitle: [
              .init(text: "Test composite easing via easingElementMap")
            ],
            handler: { _,_ in
              var rangedInterpolator = try! RangeInterpolator<UIEdgeInsets>(
                rangeInput: sharedRangeInputValues,
                rangeOutput: sharedRangeOutputValues,
                easingElementMapProvider: .rangeIndex {
                  return ($0 % 2 == 0) ? [
                    .left  : .easeInQuad  ,
                    .right : .easeOutQuad ,
                    .top   : .easeInQuart ,
                    .bottom: .easeOutQuart,
                  ] : [
                    .left  : .easeInOutQuad ,
                    .right : .easeInOutCubic,
                    .top   : .easeInOutQuart,
                    .bottom: .easeInOutQuint,
                  ];
                },
                clampingElementMapProvider: nil
                
              );
              
              var results: [AttributedStringConfig] = [
                .init(text: "When rangeIndex is even, then: "),
                .init(text: "left = easeInQuad, "),
                .init(text: "right = easeOutQuad, "),
                .init(text: "top = easeInQuart, "),
                .init(text: "bottom = easeOutQuart, "),
                .newLines(2),
                .init(text: "When rangeIndex is odd, then: "),
                .init(text: "left = easeInOutQuad, "),
                .init(text: "right = easeInOutCubic, "),
                .init(text: "top = easeInOutQuart, "),
                .init(text: "bottom = easeInOutQuint, "),
                .newLines(2),
              ];
              
              results += Helpers.invokeRangedInterpolatorAndGetResults(
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
      .newLine,
      .init(text: "interpolationModeCurrent: \(self.interpolationModeCurrent!)")
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
      
      if let interpolator = rangedInterpolator.currentOutputInterpolator {
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
