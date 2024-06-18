//
//  CardViewController.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/15/24.
//

import UIKit

public class CardViewController: UIViewController {

  public var cardConfig: CardConfig;
  
  public init(cardConfig: CardConfig){
    self.cardConfig = cardConfig;
    super.init(nibName: nil, bundle: nil);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  public override func loadView() {
    self.applyCardConfig();
  };
  
  public func applyCardConfig(){
    if self.isViewLoaded {
      self.view.removeFromSuperview();
    };
    
    let cardView = self.cardConfig.createCardView();
    self.view = cardView.rootVStack;
  };
};
