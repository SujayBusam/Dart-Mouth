//
//  PastMealTableViewCell.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 2/5/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class PastMealTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealEntriesLabel: UILabel!

    
    // MARK: - Default override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Instance variables
    
    var userMeal: UserMeal? {
        didSet { setupUI() }
    }
    
    
    // MARK: - UI Configuration
    
    func setupUI() {
        if let userMeal = self.userMeal {
            mealNameLabel.text = userMeal.title
            mealEntriesLabel.text = userMeal.getCommaSeparatedRecipes() ?? ""
            
            // Set the image view based on UserMeal title
            switch userMeal.title {
            case MealTime.Breakfast.displayString!:
                mealImageView.image = UIImage(named: Constants.Images.SunriseGreen)
                break
            case MealTime.Lunch.displayString!:
                mealImageView.image = UIImage(named: Constants.Images.SunGreen)
                break
            case MealTime.Dinner.displayString!:
                mealImageView.image = UIImage(named: Constants.Images.SunsetGreen)
                break
            case MealTime.Snacks.displayString!:
                mealImageView.image = UIImage(named: Constants.Images.ClockGreen)
                break
            default:
                print("PastMeal Cell: A UserMeal with a non-standard title: \(userMeal.title) found. Not good!")
                mealImageView.image = UIImage(named: Constants.Images.ClockGreen)
                break
            }
        }
    }
    

}
