//
//  RouteListViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit


class RouteItemController: UIViewController {

  var index = 0;
  var routeKey: Route!;
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view.backgroundColor = .init(hexString: "#BBDEFB");
    self.view.layer.cornerRadius = 12;
    
    let rootStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fillProportionally;
      stack.alignment = .fill;
      stack.spacing = 12;
                
      return stack;
    }();
    
    let label: UILabel = {
      let label = UILabel();
      
      label.text = "\(self.index) - \(self.routeKey.rawValue)";
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
      label.font = .boldSystemFont(ofSize: 22);
      
      return label;
    }();
    
    rootStack.addArrangedSubview(label);
    
    let presentButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Present as Modal", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonPresent(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    rootStack.addArrangedSubview(presentButton);
    
    let pushButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Push to Stack", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonPush(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    rootStack.addArrangedSubview(pushButton);
    
    rootStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootStack);
    
    NSLayoutConstraint.activate([
      rootStack.topAnchor.constraint(
        equalTo: self.view.topAnchor,
        constant: 12
      ),
      rootStack.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor,
        constant: -12
      ),
      rootStack.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -12
      ),
      rootStack.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: 12
      ),
    ]);
  };
  
  @objc func onPressButtonPush(_ sender: UIButton){
    guard let _ = self.view.window else {
      print(
        "RouteItemController.onPressButtonPushToStack",
        "\n- could not get window"
      );
      return;
    };
    
    guard let navigationController = self.navigationController else {
      print(
        "RouteItemController.onPressButtonPushToStack",
        "\n- could not get navigationController"
      );
      return;
    };
    
    let routeVC = self.routeKey.viewController;
    navigationController.pushViewController(routeVC, animated: true);
  };
  
  
  @objc func onPressButtonPresent(_ sender: UIButton){
    guard let window = self.view.window else {
      print(
        "RouteItemController.onPressButtonPresent",
        "\n- could not get window"
      );
      return;
    };
    
    guard let topPresentedVC = window.topmostPresentedViewController else {
      print(
        "RouteItemController.onPressButtonPresent",
        "\n- could not get topmostPresentedViewController"
      );
      return;
    };
    
    let routeVC = self.routeKey.viewController;
    topPresentedVC.present(routeVC, animated: true);
  };
};

class RouteListViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view.backgroundColor = .white;

    let rootStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.alignment = .fill;
      stack.spacing = 12 * 2;
                
      return stack;
    }();
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      
      scrollView.alwaysBounceVertical = true;
      
      return scrollView
    }();
    
    let routes: [Route] = Route.allRoutes;
    
    for route in routes.enumerated() {
      let routeController = RouteItemController();
      routeController.index = route.offset;
      routeController.routeKey = route.element;
      
      self.addChild(routeController);
      rootStack.addArrangedSubview(routeController.view);
    };
    
    rootStack.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(rootStack);
    
    NSLayoutConstraint.activate([
      rootStack.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      rootStack.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      rootStack.leadingAnchor.constraint(
        equalTo: scrollView.leadingAnchor,
        constant: 12
      ),
      rootStack.trailingAnchor.constraint(
        equalTo: scrollView.trailingAnchor,
        constant: -12
      ),
      rootStack.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: -24
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      scrollView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      scrollView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      scrollView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
      scrollView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
    ]);
  };
};
