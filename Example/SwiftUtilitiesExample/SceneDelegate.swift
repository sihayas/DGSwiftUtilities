//
//  SceneDelegate.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit
import DGSwiftUtilities

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?;
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Use this method to optionally configure and attach the UIWindow `window`
    // to the provided UIWindowScene `scene`.
    //
    // If using a storyboard, the `window` property will automatically be
    // initialized and attached to the scene.
    //
    // This delegate does not imply the connecting scene or session are new
    // (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return };
    
    let window = UIWindow(windowScene: windowScene);
    self.window = window;
    
    RouteManager.sharedInstance.window = window;
    RouteManager.sharedInstance.applyCurrentRoute();
    
    window.makeKeyAndVisible();
    
    
    if false {
      [-1.0, -0.5, 0.0, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0].forEach {
        let valueStart = 0;
        let valueEnd = 100;
        print(
          "input:", $0,
          "\n - valueStart:", valueStart,
          "\n - valueEnd:", valueEnd,
          "\n - lerp result:", InterpolatorHelpers.lerp(valueStart: CGFloat(valueStart), valueEnd: CGFloat(valueEnd), percent: $0),
          "\n"
        );
      };
    };
    
    if true {
      // -1000, -10, 0, 10, 1000
      var rangedInterpolator = try! RangeInterpolator<CGRect>(
        rangeInput : [-100 , -1 , 0, 1 , 100 ],
        rangeOutput: [
          .init(x: -1000, y: -1000, width: -1000, height: -1000),
          .init(x: -10  , y: -10  , width: -10  , height: -10  ),
          .init(x:  0   , y:  0   , width:  0   , height:  0   ),
          .init(x:  10  , y:  10  , width:  10  , height:  10  ),
          .init(x:  1000, y:  1000, width:  1000, height:  1000),
        ]
      );
      
      
      [-100, -1, 0, 1, 100, -1000, 500, -200, -50, -0.5, 0.5, 50, 75, 200, 500, 1000].forEach {
        let result = rangedInterpolator.interpolate(inputValue: $0)
        print(
          "input:", $0,
          "result:", result,
          "\n"
        );
      };
    };
    
    if false {
      
    };
    
    if false {
      [].seekForwardAndBackwards(startIndex: 1, where: {_,_ in return true})
    
      (0...1).firstBySeekingForwardAndBackwards(startIndex: 5){
        print("\($0)", "\($1)");
        return false;
      };
      
 
      let result = InterpolatorHelpers.interpolate(
        inputValue: 0.5,
        inputValueStart: 0,
        inputValueEnd: 1,
        outputValueStart: 1,
        outputValueEnd: 50,
        easing: .linear
      );
      
      let result2A = InterpolatorHelpers.interpolate(
        inputValue: -5,
        rangeInput: [0, 10],
        rangeOutput: [0, 100]
      );
      
      let result2B = InterpolatorHelpers.interpolate(
        inputValue: -5,
        inputValueStart: 0,
        inputValueEnd: 10,
        outputValueStart: 0,
        outputValueEnd: 100
      );
      
      let result3 = InterpolatorHelpers.lerp(valueStart: 0, valueEnd: 100, percent: 0.5)
      
      print("");
    };
    
    if true {
      
    };
    

    
  };
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its
    // session is discarded.
    //
    // Release any resources associated with this scene that can be re-created
    // the next time the scene connects.
    //
    // The scene may re-connect later, as its session was not necessarily
    // discarded (see `application:didDiscardSceneSessions` instead).
  };
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active
    // state.
    //
    // Use this method to restart any tasks that were paused (or not yet
    // started) when the scene was inactive.
  };
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive
    // state.
    //
    // This may occur due to temporary interruptions (ex. an incoming phone
    // call).
  };
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  };
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    //
    // Use this method to save data, release shared resources, and store enough
    // scene-specific state information to restore the scene back to its
    // current state.
  };
};

