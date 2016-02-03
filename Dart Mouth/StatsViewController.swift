//
//  StatsViewController.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Charts
import Parse
import MBProgressHUD
import ChameleonFramework
import HTHorizontalSelectionList

class StatsViewController: UIViewController, ChartViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, DateNavigationControlDelegate {
    
    @IBOutlet weak var statsSelector: HTHorizontalSelectionList!{
        didSet {
            statsSelector.delegate = self
            statsSelector.dataSource = self
        }
    }

    @IBOutlet weak var weekNavigator: WeekNavigationControl!{
        didSet{
            weekNavigator.delegate = self
        }
    }
    
    @IBOutlet weak var weekProgressDisplay: ProgressDisplay!
    
    @IBOutlet weak var dayChart: PieChartView! {
        didSet {
            dayChart.delegate = self
        }
    }
    @IBOutlet weak var weekChart: BarChartView!{
        didSet {
            weekChart.delegate = self
        }
    }
    
    enum StatDisplay : Int {
        case Calorie = 0, Macro = 1
    }
    
    var calories : [Int] = [Int](count: DisplayOptions.totalDays, repeatedValue: 0)
    var dates : [NSDate] = [NSDate](count: DisplayOptions.totalDays, repeatedValue: NSDate())
    var protein : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0)
    var fat : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0)
    var carbs : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0)
    
    var goalCalories : Int = 2000
    var goalProtein : Float = 0.1
    var goalCarbs : Float = 0.3
    var goalFat : Float = 0.1
    
    var weeksBack : Int = 0
    var startOfWeek : NSDate = NSDate()
    var endOfWeek : NSDate {
        get {
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 6, toDate: startOfWeek, options: NSCalendarOptions.MatchNextTime)!
        }
    }
    
    var display : StatDisplay = .Calorie
    var barSelection : Int = 0
    var caloriesConsumed : Int {
        get {
            return calories[barSelection]
        }
    }

    //chart fonts -- default to small, but change to bigger on larger devices
    var selectorTextFont = DisplayOptions.SelectorTextFontNormal
    var calorieCenterTextFont = DisplayOptions.CalorieCenterTextFontNormal
    var calorieDescriptorTextFont = DisplayOptions.CalorieDescriptorTextFontNormal
    var calorieTotalLabelTextFont = DisplayOptions.CalorieTotalLabelTextFontNormal
    
    private struct DisplayOptions {
        // TITLE
        static let Title = "Nutrition Stats"
        
        //ANIMATION VARIABLES
        static let AnimateDuration : NSTimeInterval = 0.6
        static let AnimateStyle : ChartEasingOption = ChartEasingOption.EaseOutQuint
        
        
        //COLOR SETTINGS
        static let BackgroundColor = UIColor.clearColor()
        
        static let GoodColor = FlatGreen()
        static let BadColor = FlatRed()
        
        static let GoodPrimary = FlatGreen()
        static let GoodSecondary = FlatWhite()
        
        static let BadPrimary = FlatRed()
        static let BadSecondary = FlatRedDark()
        
        static let DefaultColor = FlatWhite()
        static let GoalLineColor = FlatWhiteDark()
        
        //DATA SETTINGS
        static let totalDays = 7
        static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        static let DayLabels : [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        static let goalLineBuffer = 300 //minimum y value shown on chart to include goal
        
        //DIMENSION VARIABLES
        static let SelectorHeight : CGFloat = 100.0
        static let BarSpacing : CGFloat = 0.5
        static let HoleRadiusPercent : CGFloat  = 0.7
        static let PieCenterTextFontSize : CGFloat = 0.5
        
        //FONTS
        static let SelectorTextFontNormal = UIFont.systemFontOfSize(15.0)
        static let CalorieCenterTextFontNormal = UIFont.systemFontOfSize(35.0)
        static let CalorieDescriptorTextFontNormal = UIFont.systemFontOfSize(10.0)
        static let CalorieTotalLabelTextFontNormal = UIFont.systemFontOfSize(15.0)
        
        static let SelectorTextFontCompact = UIFont.systemFontOfSize(15.0)
        static let CalorieCenterTextFontCompact = UIFont.systemFontOfSize(35.0)
        static let CalorieDescriptorTextFontCompact = UIFont.systemFontOfSize(10.0)
        static let CalorieTotalLabelTextFontCompact = UIFont.systemFontOfSize(15.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = DisplayOptions.Title
        
        startOfWeek = getMostRecentMonday()
        barSelection = getDayIndex(NSDate()) //defaults to current weekday
        
        //setup charts and selector
        dayChartSetup()
        weekChartSetup()
        selectorSetup()
        
        //hide charts until data is loaded
        hideCharts()
        
        //request data to be loaded on charts
        loadWeekData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadWeekData()
    }
    
    func loadWeekData(){
        
//        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        spinningActivity.userInteractionEnabled = false
    
        UserMeal.findObjectsInBackgroundWithBlockWithinRange(self.userMealQueryCompletionHandler, startDate: startOfWeek, endDate: endOfWeek, forUser: CustomUser.currentUser()!)
        //loadFakeData()
    }
    
    // Function that gets called after getting UserMeals this week.
    func userMealQueryCompletionHandler(objects: [PFObject]?, error: NSError?) -> Void {
        clearData()
        goalCalories = CustomUser.currentUser()!.goalDailyCalories
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if error == nil {
                let userMeals = objects as! [UserMeal]
                for userMeal in userMeals {
                    let i = self.getDayIndex(userMeal.date)
                    
                    self.calories[i] += userMeal.getCumulativeCalories()
                    self.protein[i] += userMeal.getCumulativeProtein()
                    self.fat[i] += userMeal.getCumulativeFat()
                    self.carbs[i] += userMeal.getCumulativeCarbs()
                }
            }
            //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.updateUI()
            self.showCharts()
        }
    }
    
    func loadFakeData(){
        for i in 0..<7 {
            calories[i] = 1600 + Int(arc4random_uniform(800))
            dates[i] = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: startOfWeek, options: NSCalendarOptions.MatchNextTime)!
            
            var p = Float(0.2 + Float(arc4random_uniform(20)) * 0.01)
            var f = Float(0.2 + Float(arc4random_uniform(10)) * 0.01)
            var c = Float(0.3 + Float(arc4random_uniform(30)) * 0.01)


            //make future dates have no data
            if(NSDate().compare(dates[i]) == NSComparisonResult.OrderedAscending){
                p = 0
                f = 0
                c = 0
                self.calories[i] = 0
            }
            
            protein[i] = p
            fat[i] = f
            carbs[i] = c
        }
    }
    
    func clearData(){
        for i in 0..<7 {
            calories[i] = 0
            dates[i] = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)!
            
            protein[i] = 0
            fat[i] = 0
            carbs[i] = 0
        }
    }
    
    private func hideCharts(){
        dayChart.alpha = 0
        weekChart.alpha = 0
    }

    private func showCharts(){
        dayChart.alpha = 1
        weekChart.alpha = 1
    }
    
    
    func updateUI(){
        updateDayChart()
        updateWeekChart()
    }
    
    func updateDayChart(){
        if(display == StatDisplay.Calorie){
            updateDayCalorieChart()
        } else if(display == StatDisplay.Macro){
            updateDayMacroChart()
        }
        dayChart.animate(yAxisDuration: DisplayOptions.AnimateDuration, easingOption: DisplayOptions.AnimateStyle)
    }
    
    func updateWeekChart(){
        if(display == StatDisplay.Calorie){
            updateWeeklyCalorieChart()
        } else if(display == StatDisplay.Macro){
            updateWeeklyMacroChart()
        }
        weekChart.animate(xAxisDuration: DisplayOptions.AnimateDuration, yAxisDuration: DisplayOptions.AnimateDuration,
            easingOption: DisplayOptions.AnimateStyle)
        
    }
    
    // MARK: - Setup Functions
    func setupFonts(){
        //downsize font on smaller devices
        if(self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.Regular ||
            self.view.traitCollection.verticalSizeClass != UIUserInterfaceSizeClass.Regular) {
                selectorTextFont = DisplayOptions.SelectorTextFontCompact
                calorieCenterTextFont = DisplayOptions.CalorieCenterTextFontCompact
                calorieDescriptorTextFont = DisplayOptions.CalorieDescriptorTextFontCompact
                calorieTotalLabelTextFont = DisplayOptions.CalorieTotalLabelTextFontCompact
        }
    }
    func selectorSetup(){
        statsSelector.setTitleFont(UIFont.systemFontOfSize(15.0), forState: UIControlState.Normal)
        statsSelector.bottomTrimHidden = true
        statsSelector.centerAlignButtons = true
        statsSelector.reloadData()
    }
    
    func dayChartSetup(){
        dayChart.backgroundColor = DisplayOptions.BackgroundColor
        dayChart.legend.enabled = false
        dayChart.descriptionText = ""
        dayChart.descriptionFont = calorieTotalLabelTextFont
        dayChart.holeRadiusPercent = DisplayOptions.HoleRadiusPercent
        dayChart.drawSliceTextEnabled = false
        dayChart.legend.position = ChartLegend.ChartLegendPosition.BelowChartRight
        //dayChart.userInteractionEnabled = false
    }
    
    func weekChartSetup() {
        weekChart.xAxis.drawAxisLineEnabled = false
        weekChart.xAxis.drawGridLinesEnabled = false
        weekChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        weekChart.xAxis.setLabelsToSkip(0)
        weekChart.setVisibleXRange(minXRange: 0, maxXRange: 7.0)
        
        weekChart.leftAxis.drawLimitLinesBehindDataEnabled = true
        weekChart.leftAxis.enabled = false
        weekChart.leftAxis.drawGridLinesEnabled = false
        
        weekChart.rightAxis.enabled = false
        weekChart.rightAxis.drawGridLinesEnabled = false
        
        weekChart.dragEnabled = true
        weekChart.backgroundColor = DisplayOptions.BackgroundColor
        weekChart.drawBordersEnabled = false
        weekChart.drawGridBackgroundEnabled = false
        weekChart.legend.enabled = false
        weekChart.descriptionText = ""
        
        weekChart.dragDecelerationEnabled = false
        weekChart.highlightPerTapEnabled = false
        weekChart.multipleTouchEnabled = false
        weekChart.highlightPerTapEnabled = true
        weekChart.doubleTapToZoomEnabled = false
        
        weekNavigator.changeTheme(.Black)
    }
    
    // MARK: - Calorie Data Update functions
    
    func updateDayCalorieChart(){
        //if the user has consumed over their daily goal
        let over = caloriesConsumed > goalCalories
        
        var displayValues : [Int]
        var labels : [String]
        var calorieString : String
        var calorieDescriptor : String
        
        if(over){
            displayValues = [goalCalories, caloriesConsumed - goalCalories]
            labels = ["Calories", "Over"]
            calorieString = String(caloriesConsumed - goalCalories)
            calorieDescriptor = String("\nCALORIES\nOVER BUDGET")
        } else {
            displayValues = [caloriesConsumed, goalCalories - caloriesConsumed]
            labels = ["Calories", "Left"]
            calorieString = String(goalCalories - caloriesConsumed)
            calorieDescriptor = String("\nCALORIES\nUNDER BUDGET")
        }
        let textParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        textParagraphStyle.alignment = NSTextAlignment.Center
        
        
        let attributesCalorieString : [String : AnyObject] = [
            NSFontAttributeName : calorieCenterTextFont,
            NSForegroundColorAttributeName : getPrimaryColor(),
            NSParagraphStyleAttributeName : textParagraphStyle]
        
        let attributesCalorieDescriptor : [String : AnyObject] = [
            NSFontAttributeName : calorieDescriptorTextFont,
            NSParagraphStyleAttributeName : textParagraphStyle]
        
        
        let centerText = NSMutableAttributedString(string: calorieString + calorieDescriptor)
        centerText.addAttributes(attributesCalorieString, range: NSMakeRange(0, calorieString.characters.count))
        centerText.addAttributes(attributesCalorieDescriptor, range: NSMakeRange(calorieString.characters.count, calorieDescriptor.characters.count))
        
        dayChart.centerAttributedText = centerText
        dayChart.descriptionText = String(caloriesConsumed) + " / " + String(goalCalories)
        
        var dayDataEntries: [ChartDataEntry] = []
        
        for i in 0..<displayValues.count {
            dayDataEntries.append(ChartDataEntry(value: Double(displayValues[i]), xIndex: i))
        }
        
        let dayChartDataSet = PieChartDataSet(yVals: dayDataEntries, label: "Calories")
        dayChartDataSet.colors = [DisplayOptions.GoodPrimary, getLabelColor()]
        dayChartDataSet.drawValuesEnabled = false
        let dayChartData = PieChartData(xVals: labels, dataSet: dayChartDataSet)
        dayChart.data = dayChartData
    }
    
    func updateWeeklyCalorieChart(){
        var barDataEntries: [BarChartDataEntry] = []
        let dateStrings : [String] = DisplayOptions.DayLabels
        var weekCumulativeCalories  = 0
        for i in 0..<calories.count {
            weekCumulativeCalories += calories[i]
            if(calories[i] <= goalCalories){
                barDataEntries.append(BarChartDataEntry(values: [Double(calories[i]), 0], xIndex: i))
            } else {
                barDataEntries.append(BarChartDataEntry(values: [Double(goalCalories), Double(calories[i] - goalCalories)], xIndex: i))
            }
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
        barChartDataSet.barSpace = DisplayOptions.BarSpacing
        barChartDataSet.colors = [DisplayOptions.GoodColor, DisplayOptions.BadColor]
        barChartDataSet.drawValuesEnabled = false
        
        let barChartData = BarChartData(xVals: dateStrings, dataSet: barChartDataSet)
        weekChart.data = barChartData
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        weekNavigator.updateDateLabel()
        
        weekChart.leftAxis.removeAllLimitLines()
        let goalLine = ChartLimitLine(limit: Double(goalCalories))
        goalLine.lineColor = DisplayOptions.GoalLineColor
        weekChart.leftAxis.addLimitLine(goalLine)
        
        //update week progress bar
        weekProgressDisplay.updateCalorieDisplay(Int(weekCumulativeCalories - goalCalories * 7))
    }

    
    // MARK: - Macro Data Update functions
    
    func updateDayMacroChart(){
        //Macro specific pie chart settings
        dayChart.descriptionText = ""
        dayChart.centerText = ""
        
        
        let proteinCalories = protein[barSelection] * Constants.NutritionalConstants.ProteinCaloriesToGram
        let carbCalories = carbs[barSelection] * Constants.NutritionalConstants.CarbsCaloriesToGram
        let fatCalories = fat[barSelection] * Constants.NutritionalConstants.FatCaloriesToGram
        let totalMacroCalories = proteinCalories + carbCalories + fatCalories
                
        let dayDataEntries: [ChartDataEntry] = [
            ChartDataEntry(value: Double(proteinCalories / totalMacroCalories), xIndex: 0),
            ChartDataEntry(value: Double(carbCalories / totalMacroCalories), xIndex: 1),
            ChartDataEntry(value: Double(fatCalories / totalMacroCalories), xIndex: 2)
        ]
        
        let labels = ["Protein", "Carbs", "Fat"]
        
        //configure macro data set
        let dayChartDataSet = PieChartDataSet(yVals: dayDataEntries)
        dayChartDataSet.colors = [Constants.Colors.ProteinColor, Constants.Colors.CarbColor, Constants.Colors.FatColor]
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        dayChartDataSet.valueFormatter = formatter
        dayChartDataSet.label = ""
        
        let dayChartData = PieChartData(xVals: labels, dataSet: dayChartDataSet)
        dayChart.data = dayChartData
    }
    
    func updateWeeklyMacroChart(){
        var barDataEntries: [BarChartDataEntry] = []
        let dateStrings : [String] = DisplayOptions.DayLabels
        
        var weekCumulativeProtein : Float = 0.0
        var weekCumulativeCarbs : Float = 0.0
        var weekCumulativeFat : Float = 0.0

        for i in 0..<protein.count {
            weekCumulativeProtein += protein[i]
            weekCumulativeCarbs += carbs[i]
            weekCumulativeFat += fat[i]
            
            let proteinCalories = Double(protein[i] * Constants.NutritionalConstants.ProteinCaloriesToGram)
            let carbCalories = Double(carbs[i] * Constants.NutritionalConstants.CarbsCaloriesToGram)
            let fatCalories = Double(carbs[i] * Constants.NutritionalConstants.FatCaloriesToGram)
            let dataEntry = BarChartDataEntry(values: [carbCalories, proteinCalories, fatCalories] , xIndex: i)
            barDataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
        barChartDataSet.barSpace = DisplayOptions.BarSpacing
        barChartDataSet.colors = [Constants.Colors.ProteinColor, Constants.Colors.CarbColor, Constants.Colors.FatColor]
        barChartDataSet.drawValuesEnabled = false
        let barChartData = BarChartData(xVals: dateStrings, dataSet: barChartDataSet)
        weekChart.leftAxis.removeAllLimitLines()
        weekChart.data = barChartData
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        weekNavigator.updateDateLabel()
        
        
        //update Week ProgressBar
        let targetProtein = Float(7) * Float(goalCalories) * goalProtein / Constants.NutritionalConstants.ProteinCaloriesToGram
        let targetCarbs = Float(7) * Float(goalCalories) * goalCarbs / Constants.NutritionalConstants.CarbsCaloriesToGram
        let targetFat = Float(7) * Float(goalCalories) * goalCarbs / Constants.NutritionalConstants.FatCaloriesToGram
        weekProgressDisplay.updateMacroDisplay(Int(roundf(weekCumulativeCarbs - targetCarbs)),
            protein: Int(roundf(weekCumulativeProtein - targetProtein)),
            fat: Int(roundf(weekCumulativeFat - targetFat)))
    }
    
    // MARK: - Week Shifting Methods
    
    func shiftWeekPrev(){
        startOfWeek = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: startOfWeek, options: NSCalendarOptions.MatchPreviousTimePreservingSmallerUnits)!
        weeksBack++
        loadWeekData()
    }
    
    func shiftWeekNext(){
        if(weeksBack == 0){
            return
        }
        startOfWeek = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 7, toDate: startOfWeek, options: NSCalendarOptions.MatchNextTime)!
        weeksBack--
        loadWeekData()
    }

    
    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return 2
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        if(index == StatDisplay.Calorie.rawValue){
            return "Calories"
        } else if(index == StatDisplay.Macro.rawValue){
            return "Macros"
        } else {
            return "Missing Item"
        }
    }
    
    
    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        display = StatDisplay(rawValue: index)!
        updateUI()    
    }
    
    // MARK: -  DateNavigationControlDelegate Protocol Methods
    
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate{
        return startOfWeek
    }
    func leftArrowWasPressed(sender: UIButton){
        shiftWeekPrev()
    }
    func rightArrowWasPressed(sender: UIButton){
        shiftWeekNext()
    }
    
    // MARK: - Chart Protocol Methods
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        barSelection = entry.xIndex
        //highlight the whole bar, not just the segment that was actually clicked on
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        updateDayChart()
    }
    
    // MARK: - Date Range Utility Methods
    
    //gets the most recent NSDate that is a Monday, which could be the current day
    func getMostRecentMonday() -> NSDate {
        let today = NSDate()
        
        let monday = 2
        //return today if today is Monday
        if(DisplayOptions.calendar.component(.Weekday, fromDate: today) == monday){
            return today
        }
        
        let prevDateComponent = NSDateComponents()
        prevDateComponent.weekday = monday
        
        let date = DisplayOptions.calendar.nextDateAfterDate(today, matchingComponents: prevDateComponent, options: [NSCalendarOptions.SearchBackwards, NSCalendarOptions.MatchPreviousTimePreservingSmallerUnits])
        return date!
    }
    
    //returns how many days ago a certain date was
    func howManyDaysAgo(date: NSDate) -> Int {
        let startDay = DisplayOptions.calendar.ordinalityOfUnit(.Day, inUnit: NSCalendarUnit.Era, forDate: date)
        let endDay = DisplayOptions.calendar.ordinalityOfUnit(.Day, inUnit: NSCalendarUnit.Era, forDate: NSDate())
        return endDay - startDay
    }
    
    //translates the current day into chart value index
    func getDayIndex(date : NSDate) -> Int {
        let component = NSCalendar.currentCalendar().component(.Weekday, fromDate: date)
        //Days range from 0-7, and Monday is 2
        return (component + 5) % 7
    }
    
    func getLabelColor() -> UIColor {
        if(caloriesConsumed <= goalCalories){
            return DisplayOptions.GoodSecondary
        } else {
            return DisplayOptions.BadPrimary
        }
    }
    func getPrimaryColor() -> UIColor {
        if(caloriesConsumed <= goalCalories){
            return DisplayOptions.GoodPrimary
        } else {
            return DisplayOptions.BadPrimary
        }
    }
}


