//
//  Test01ViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit
import DGSwiftUtilities

fileprivate class ModalViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view.backgroundColor = .white;
  };
};

class Test01ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view.backgroundColor = .white;
    
    let presentButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Present Modal", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonPresent(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
     let controlsStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .center;
      stack.spacing = 10;
      
      stack.addArrangedSubview(presentButton);
      
      return stack;
    }();
    
    controlsStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(controlsStack);

    NSLayoutConstraint.activate([
      controlsStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      controlsStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ]);
  };
  
  @objc func onPressButtonPresent(_ sender: UIButton){
    guard let window = self.view.window else {
      print(
        "Test01ViewController.onPressButtonPresent",
        "\n- could not get window"
      );
      return;
    };
    
    guard let topPresentedVC = window.topmostPresentedViewController else {
      print(
        "Test01ViewController.onPressButtonPresent",
        "\n- could not get topmostPresentedViewController"
      );
      return;
    };
    
    let modalVC = ModalViewController();
    topPresentedVC.present(modalVC, animated: true);
  };
};
