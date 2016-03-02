//
//  CheckboxUIButton.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 2/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

protocol CheckboxUIButtonDelegate: class {
    func didSelectCheckbox(sender: CheckboxUIButton)
}

// TODO: needs to be just a view
class CheckboxUIButton: UIButton {
    weak var delegate: CheckboxUIButtonDelegate!
    
    // Images
    let checkedImage = UIImage(named: "CheckboxChecked")!
    let uncheckedImage = UIImage(named: "CheckboxUnchecked")!
    
    // Bool property
    var isChecked: Bool = false {
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
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        print("Checkbox clicked")
        delegate.didSelectCheckbox(self)
    }
    
    func toggleCheck() {
        self.isChecked = !self.isChecked
    }

}
