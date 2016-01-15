//
//  DiaryAdderViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/15/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class DiaryAdderViewController: UIViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBAction func mealtimeButtonClicked(sender: UIButton) {
        let mealTime = sender.currentTitle!
        dismissViewControllerAnimated(true) { () -> Void in
            if let vc = self.sourceVC as? RecipeNutritionViewController {
                vc.presentAddedToDiaryAlert()
            }
        }
    }
    
    var sourceVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSubviews() {
//        self.view.backgroundColor = UIColor(hexString: "F7F7F7")
//        self.view.alpha = 0.6
    }
    
    override var preferredContentSize: CGSize {
        get {
            if buttonStackView != nil && presentingViewController != nil {
                return buttonStackView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        
        set { super.preferredContentSize = newValue }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
