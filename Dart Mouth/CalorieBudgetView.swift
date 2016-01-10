//
//  CalorieBudgetView.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout
import ChameleonFramework

protocol CalorieBudgetViewDelegate: class {
    func budgetValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int
    func foodValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int
}

/*
This is a custom UIView that shows budget calories, food calories consumed, and budget over/under value.
It shoud look like the top bar for the Log view in the LoseIt app.
*/

class CalorieBudgetView: UIView {
    
    struct Labels {
        static let Budget = "Budget"
        static let Food = "Food"
        static let Under = "Under"
        static let Over = "Over"
    }
    
    struct Dimensions {
        static let StackViewWidth: CGFloat = 75
    }
    
    struct Colors {
        static let LightGrayHex = "F7F7F7"
        static let TopLabelColor: UIColor = FlatGrayDark()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        updateLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        updateLabels()
    }
    
    weak var delegate: CalorieBudgetViewDelegate?
    var numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    // The 3 stack views that contain the relevant labels
    var budgetStackView: UIStackView!
    var foodStackView: UIStackView!
    var underOverStackView: UIStackView!
    
    // Labels for the budgetStackView
    var budgetLabel: UILabel = UILabel()
    var budgetValue: UILabel = UILabel()
    
    // Labels for the foodStackView
    var foodLabel: UILabel = UILabel()
    var foodValue: UILabel = UILabel()
    
    // Labels for the underOverStackView
    var underOverLabel: UILabel = UILabel()
    var underOverValue: UILabel = UILabel()
    
    var allLabels: [UILabel!] {
        return [budgetLabel, budgetValue, foodLabel, foodValue, underOverLabel, underOverValue]
    }
    
    var allStackViews: [UIStackView] {
        return [budgetStackView, foodStackView, underOverStackView]
    }
    
    // Setup subviews for budget value, food value, over/under value.
    private func setupSubviews() {
        self.backgroundColor = UIColor(hexString: Colors.LightGrayHex)
        
        // Setup all of the labels
        for label in allLabels {
            label.textAlignment = .Center
            label.adjustsFontSizeToFitWidth = true
        }
        
        budgetLabel.text = Labels.Budget
        budgetLabel.textColor = Colors.TopLabelColor
        
        foodLabel.text = Labels.Food
        foodLabel.textColor = Colors.TopLabelColor
        
        underOverLabel.text = Labels.Under
        underOverLabel.textColor = Colors.TopLabelColor
        
        // Create and setup all of the stack views
        budgetStackView = UIStackView(arrangedSubviews: [budgetLabel, budgetValue])
        foodStackView = UIStackView(arrangedSubviews: [foodLabel, foodValue])
        underOverStackView = UIStackView(arrangedSubviews: [underOverLabel, underOverValue])
        for stackView in allStackViews {
            stackView.axis = .Vertical
            stackView.distribution = .FillEqually
            stackView.alignment = .Fill
            self.addSubview(stackView)
        }
        
        setupConstraints()
    }
    
    // Use PureLayout to setup constaints for stack views.
    private func setupConstraints() {
        let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        budgetStackView.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Right)
        budgetStackView.autoSetDimensionsToSize(CGSizeMake(Dimensions.StackViewWidth, self.frame.height))
        
        foodStackView.autoCenterInSuperview()
        foodStackView.autoPinEdgeToSuperviewEdge(.Top)
        foodStackView.autoPinEdgeToSuperviewEdge(.Bottom)
        foodStackView.autoSetDimension(.Width, toSize: Dimensions.StackViewWidth)
        
        underOverStackView.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Left)
        underOverStackView.autoSetDimensionsToSize(CGSizeMake(Dimensions.StackViewWidth, self.frame.height))
    }
    
    // Update calorie values using delegate.
    func updateLabels() {
        guard self.delegate != nil else { return }
        
        let calorieBudget = delegate!.budgetValueForCalorieBudgetView(self)
        self.budgetValue.text = formatValue(calorieBudget)
        
        let foodCalories = delegate!.foodValueForCalorieBudgetView(self)
        self.foodValue.text = formatValue(foodCalories)
        
        let calorieNet = calorieBudget - foodCalories
        if calorieNet > 0 {
            self.underOverLabel.text = Labels.Under
        } else {
            self.underOverLabel.text = Labels.Over
        }
        self.underOverValue.text = formatValue(abs(calorieNet))
    }
    
    // Format numeric value so that it uses commas e.g. 2,123
    // Returns a string.
    private func formatValue(value: Int) -> String {
        self.numberFormatter.numberStyle = .DecimalStyle
        return self.numberFormatter.stringFromNumber(value)!
    }
}
