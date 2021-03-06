//
//  SearchableViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/24/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class SearchableViewController: UIViewController {
    
    var currentSearchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchTextChanged(newSearchText: String?) {
        self.currentSearchText = newSearchText
    }
    
    func searchRequested() {}
}
