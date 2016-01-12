//
//  StatsViewController.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Charts
import ChameleonFramework

class StatsViewController: UIViewController {

    @IBOutlet weak var dayChart: PieChartView!
    @IBOutlet weak var weekChart: BarChartView!
    
    private struct DisplayOptions {
        static let barSpacing : CGFloat = 0.5
        static let backgroundColor = UIColor.clearColor()
        
        static let goodPrimary = FlatGreen()
        static let goodSecondary = FlatWhite()
        
        static let warningPrimary = FlatYellow()
        static let warningSecondary = FlatYellowDark()
        
        static let badPrimary = FlatRed()
        static let badSecondary = FlatRedDark()
        
        static let defaultColor = FlatWhite()
    
        static let warningRange = 200
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekChart.xAxis.drawAxisLineEnabled = false
        weekChart.xAxis.drawGridLinesEnabled = false
        weekChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        weekChart.xAxis.setLabelsToSkip(0)
        
        weekChart.leftAxis.enabled = false
        weekChart.leftAxis.drawGridLinesEnabled = false
        
        weekChart.rightAxis.enabled = false
        weekChart.rightAxis.drawGridLinesEnabled = false
        
        weekChart.backgroundColor = DisplayOptions.backgroundColor
        weekChart.drawBordersEnabled = false
        weekChart.drawGridBackgroundEnabled = false
        weekChart.legend.enabled = false
        weekChart.descriptionText = ""
        
        dayChart.backgroundColor = DisplayOptions.backgroundColor
        dayChart.legend.enabled = false
        
        setCalorieData()
    }
    
    func setCalorieData() {
        
        let dataPoints = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        let values = [1500.0, 2000.0, 1700.0, 1800.0, 1600.0, 2150.0, 1550.0]
//        let goalCalories = 3000
//        let dayDisplayed = 0
        //let pieValues = [1000.0, 500.0]
        
        
        
        var barDataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            barDataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
        barChartDataSet.barSpace = DisplayOptions.barSpacing
        barChartDataSet.setColor(DisplayOptions.defaultColor)
        barChartDataSet.highlightColor = DisplayOptions.goodPrimary
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        weekChart.data = barChartData
        
        //let dayDataEntries: [ChartDataEntry]
//        let dayDataEntries = [ChartDataEntry(value: 1000, xIndex: 0),
//                              ChartDataEntry(value: 500, xIndex: 1) ]
//        let dayDataPoints = ["Calories", "Left"]
//        
//        
//        let pieChartDataSet = PieChartDataSet(yVals: dayDataEntries, label: "Calories")
//        pieChartDataSet.colors = [DisplayOptions.goodPrimary, DisplayOptions.defaultColor]
//        let pieChartData = PieChartData(xVals: dayDataPoints, dataSet: pieChartDataSet)
//        dayChart.data = pieChartData
        
        setDayCalorieChart(2400, dailyGoal : 2000)
        
    }
    
    func setDayCalorieChart(caloriesConsumed : Int, dailyGoal : Int){
        
        //if the user has consumed over their daily goal
        let over = caloriesConsumed > dailyGoal
        
        var values : [Int]
        var labels : [String]
        var colors : [UIColor]
        
        if(over){
            values = [dailyGoal, caloriesConsumed - dailyGoal]
            labels = ["Calories", "Over"]
            
            if(caloriesConsumed - dailyGoal > DisplayOptions.warningRange){
                colors = [DisplayOptions.badPrimary, DisplayOptions.badSecondary]
            } else {
                colors = [DisplayOptions.warningPrimary, DisplayOptions.warningSecondary]
            }
        } else {
            values = [caloriesConsumed, dailyGoal - caloriesConsumed]
            labels = ["Calories", "Left"]
            colors = [DisplayOptions.goodPrimary, DisplayOptions.goodSecondary]
        }
        
        var dayDataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            dayDataEntries.append(ChartDataEntry(value: Double(values[i]), xIndex: i))
        }
        
        let dayChartDataSet = PieChartDataSet(yVals: dayDataEntries, label: "Calories")
        dayChartDataSet.colors = colors
        let dayChartData = PieChartData(xVals: labels, dataSet: dayChartDataSet)
        dayChart.data = dayChartData
    }
    
    func setWeeklyCalorieChart(dates : [NSDate], values : [Int]){
        
    }
    
}
