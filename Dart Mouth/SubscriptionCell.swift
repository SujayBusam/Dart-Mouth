//
//  SubscriptionCell.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 3/5/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class SubscriptionCell: UITableViewCell {
    
    enum Display{
        case Current, New, Added
    }
    
    private struct DisplayOptions{
        static let ButtonSize : CGFloat = 17.0
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    var button : VBFPopFlatButton = VBFPopFlatButton(frame: CGRectMake(0, 0, DisplayOptions.ButtonSize, DisplayOptions.ButtonSize))
    var display : Display = .Current
    var table : UITableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    
    func setup(){
        accessoryType = .DisclosureIndicator
        selectionStyle = .Default
        button.addTarget(self, action: "buttonPressed", forControlEvents: .TouchDown)
        accessoryView = button
        updateDisplay()
    }
    
    func setRecipe(recipe: Recipe){
        textLabel?.text = recipe.name
        detailTextLabel?.text = "\(recipe.getCalories()?.description ?? "-") cals"
    }
    
    func updateDisplay(){
        switch display {
        case .Current:
            button.animateToType(.buttonCloseType)
            button.setTintColor(Constants.Colors.appPrimaryColorDark, forState: .Normal)
        case .New:
            button.animateToType(.buttonAddType)
            button.setTintColor(Constants.Colors.appPrimaryColorDark, forState: .Normal)
            backgroundColor = UIColor.whiteColor()
        case .Added:
            button.animateToType(.buttonOkType)
            button.setTintColor(UIColor.whiteColor(), forState: .Normal)
            backgroundColor = Constants.Colors.appPrimaryColorDark
        }
    }
    
    func buttonPressed(){
        var newDisplay : Display?
        switch display {
            case .Current: return
            case .New: newDisplay = .Added
            case .Added: newDisplay = .New
        }
        display = newDisplay!
        updateDisplay()
    }
}


