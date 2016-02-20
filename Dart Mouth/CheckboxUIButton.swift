//
//  CheckboxUIButton.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 2/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class CheckboxUIButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "CheckboxChecked")!
    let uncheckedImage = UIImage(named: "CheckboxUnchecked")!
    
    // Bool property
    var isChecked: Bool = true {
        didSet {
            if isChecked {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = true
    }
    
    func buttonClicked(sender: UIButton) {
        self.isChecked = !self.isChecked
    }

}
