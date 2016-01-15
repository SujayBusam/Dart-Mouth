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

class StatsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var dayChart: PieChartView!
    @IBOutlet weak var weekChart: BarChartView!
    
    var selected : Int = 0;
    var values : [Int] = []
    var dates : [NSDate] = []
    var goal : Int = 2000
    var caloriesConsumed : Int {
        get {
            return values[selected]
        }
    }
    
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
        static let goalLineColor = FlatWhiteDark()
    
        static let warningRange = 200
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FAKE DATA GENERATION
        let numFakeDataPoints = 7
        let secondsInDay = 24 * 60 * 60
        
        for i in 0..<numFakeDataPoints{
            values.append(1600 + Int(arc4random_uniform(800)))
            dates.append(NSDate(timeIntervalSinceNow: NSTimeInterval(i * secondsInDay)))
        }
        selected = values.count - 1;
        // END - FAKE DATA GENERATION

        weekChart.xAxis.drawAxisLineEnabled = false
        weekChart.xAxis.drawGridLinesEnabled = false
        weekChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        weekChart.xAxis.setLabelsToSkip(0)
        
        weekChart.leftAxis.enabled = false
        weekChart.leftAxis.drawGridLinesEnabled = false
        
        let goalLine = ChartLimitLine(limit: Double(goal))
        goalLine.lineColor = DisplayOptions.goalLineColor
        goalLine.lineDashPhase = 20
        weekChart.leftAxis.addLimitLine(goalLine)
        weekChart.leftAxis.drawLimitLinesBehindDataEnabled = true
        
        weekChart.rightAxis.enabled = false
        weekChart.rightAxis.drawGridLinesEnabled = false
        
        weekChart.dragEnabled = true
        weekChart.backgroundColor = DisplayOptions.backgroundColor
        weekChart.drawBordersEnabled = false
        weekChart.drawGridBackgroundEnabled = false
        weekChart.legend.enabled = false
        weekChart.descriptionText = ""
        weekChart.delegate = self
        
        
        dayChart.backgroundColor = DisplayOptions.backgroundColor
        dayChart.legend.enabled = false
        dayChart.descriptionText = ""
        
        setCalorieData()
    }
    
    func setCalorieData() {
        print("in set calorie data")
        print(values)

        updateWeeklyCalorieChart()
        updateDayCalorieChart()
        
    }
    
    func updateDayCalorieChart(){
        //if the user has consumed over their daily goal
        let over = caloriesConsumed > goal
        
        var displayValues : [Int]
        var labels : [String]
        
        if(over){
            displayValues = [goal, caloriesConsumed - goal]
            labels = ["Calories", "Over"]
        } else {
            displayValues = [caloriesConsumed, goal - caloriesConsumed]
            labels = ["Calories", "Left"]
        }
        
        var dayDataEntries: [ChartDataEntry] = []
        
        for i in 0..<displayValues.count {
            dayDataEntries.append(ChartDataEntry(value: Double(displayValues[i]), xIndex: i))
        }
        
        let dayChartDataSet = PieChartDataSet(yVals: dayDataEntries, label: "Calories")
        dayChartDataSet.colors = [getPrimaryColor(), getSecondaryColor()]
        let dayChartData = PieChartData(xVals: labels, dataSet: dayChartDataSet)
        dayChart.data = dayChartData
    }
    
    func updateWeeklyCalorieChart(){
        var barDataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(value: Double(values[i]), xIndex: i)
            barDataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "M/dd"
        //dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let dateStrings = dates.map { (date) -> String in
            return dateFormatter.stringFromDate(date)
        }
        
        barChartDataSet.barSpace = DisplayOptions.barSpacing
        barChartDataSet.setColor(DisplayOptions.defaultColor)
        barChartDataSet.highlightColor = getPrimaryColor()
        let barChartData = BarChartData(xVals: dateStrings, dataSet: barChartDataSet)
        weekChart.data = barChartData
        weekChart.highlightValue(xIndex: selected, dataSetIndex: 0, callDelegate: false)
        
    }
    
    func getPrimaryColor() -> UIColor {
        if(caloriesConsumed <= goal){
            return DisplayOptions.goodPrimary
        } else if(caloriesConsumed < goal + DisplayOptions.warningRange){
            return DisplayOptions.warningPrimary
        } else {
            return DisplayOptions.badPrimary
        }
    }
    
    func getSecondaryColor() -> UIColor {
        if(caloriesConsumed <= goal){
            return DisplayOptions.goodSecondary
        } else if(caloriesConsumed < goal + DisplayOptions.warningRange){
            return DisplayOptions.warningSecondary
        } else {
            return DisplayOptions.badSecondary
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        selected = entry.xIndex
        updateDayCalorieChart()
        updateWeeklyCalorieChart()
    }
}
