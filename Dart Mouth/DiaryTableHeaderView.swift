//
//  DiaryTableHeaderView.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/15/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout
import ChameleonFramework

protocol DiaryTableHeaderViewDelegate: class {
    func addButtonPressedForDiaryTableHeader(sender: DiaryTableHeaderView)
}

class DiaryTableHeaderView: UIView {
    
    private struct Dimensions {
        static let TitleFontSize: CGFloat = 20
        static let CaloriesLabelFontSize: CGFloat = 20
        static let CaloriesLabelOffset: CGFloat = 5
        static let BorderHeight: CGFloat = 1
    }
    
    private struct Colors {
        static let TitleText: UIColor = FlatSkyBlue()
        static let CaloriesLabelText: UIColor = FlatSkyBlue()
    }
    
    private struct Identifiers {
        static let PlusButton = "PlusGray"
        static let plusButtonPressed = "plusButtonPressed:"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    var delegate: DiaryTableHeaderViewDelegate!
    
    var borderLine: UIView!
    var title: UILabel!
    var caloriesLabel: UILabel!
    var plusButton: UIButton!

    private func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        // Add a small border on top
        borderLine = UIView()
        borderLine.backgroundColor = FlatMintDark()
        
        title = UILabel()
        title.font = UIFont(name: title.font!.fontName, size: Dimensions.TitleFontSize)
        title.textColor = Colors.TitleText
        
        caloriesLabel = UILabel()
        caloriesLabel.font = UIFont(name: caloriesLabel.font!.fontName, size: Dimensions.CaloriesLabelFontSize)
        caloriesLabel.textColor = Colors.CaloriesLabelText
        
        plusButton = UIButton(frame: CGRectMake(0, 0, self.bounds.height, self.bounds.height))
        plusButton.setImage(UIImage(named: Identifiers.PlusButton), forState: .Normal)
        plusButton.addTarget(self, action: NSSelectorFromString(Identifiers.plusButtonPressed), forControlEvents: .TouchUpInside)
        
        self.addSubview(borderLine)
        self.addSubview(title)
        self.addSubview(caloriesLabel)
        self.addSubview(plusButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        borderLine.autoSetDimensionsToSize(CGSizeMake(self.bounds.width, Dimensions.BorderHeight))
        borderLine.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        
        title.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        
        caloriesLabel.autoPinEdge(.Left, toEdge: .Right, ofView: title, withOffset: Dimensions.CaloriesLabelOffset)
        caloriesLabel.autoPinEdgeToSuperviewMargin(.Top)
        caloriesLabel.autoPinEdgeToSuperviewMargin(.Bottom)
        
        plusButton.autoSetDimensionsToSize(CGSizeMake(self.bounds.height, self.bounds.height))
        plusButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
    }
    
    func plusButtonPressed(sender: UIButton) {
        delegate.addButtonPressedForDiaryTableHeader(self)
    }

}
