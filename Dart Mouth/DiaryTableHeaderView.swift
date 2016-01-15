//
//  DiaryTableHeaderView.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/15/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout

class DiaryTableHeaderView: UIView {
    
    private struct Dimensions {
        static let TitleFontSize: CGFloat = 18
        static let CaloriesLabelFontSize: CGFloat = 18
        static let CaloriesLabelOffset: CGFloat = 3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    var title: UILabel!
    var caloriesLabel: UILabel!

    private func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        title = UILabel()
        title.font = UIFont(name: title.font!.fontName, size: Dimensions.TitleFontSize)
        title.textColor = self.tintColor
        
        caloriesLabel = UILabel()
        caloriesLabel.font = UIFont(name: caloriesLabel.font!.fontName, size: Dimensions.CaloriesLabelFontSize)
        caloriesLabel.textColor = self.tintColor
        
        self.addSubview(title)
        self.addSubview(caloriesLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        
        caloriesLabel.autoPinEdge(.Left, toEdge: .Right, ofView: title, withOffset: Dimensions.CaloriesLabelOffset)
        caloriesLabel.autoPinEdgeToSuperviewMargin(.Top)
        caloriesLabel.autoPinEdgeToSuperviewMargin(.Bottom)
    }
}
