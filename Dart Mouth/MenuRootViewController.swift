//
//  MenuRootViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class MenuRootViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and add MenuViewController into this VC's container view.
        let menuVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.MenuView)
        self.addChildViewController(menuVC)
        menuVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(menuVC.view)
        
        menuVC.didMoveToParentViewController(self)
    }


}
