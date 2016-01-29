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
import HTHorizontalSelectionList

class StatsViewController: UIViewController, ChartViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, DateNavigationControlDelegate, ProgressDisplayDataSource {
    
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
    
    @IBOutlet weak var weekProgressDisplay: ProgressDisplay!{
        didSet{
            weekProgressDisplay.dataSource = self
        }
    }
    
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
    
    
    //TEMP FAKE DATA VARS
    var values : [Int] = [Int](count: DisplayOptions.totalDays, repeatedValue: 0)
    var dates : [NSDate] = [NSDate](count: DisplayOptions.totalDays, repeatedValue: NSDate())
    var protein : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0.0)
    var fat : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0.0)
    var carbs : [Float] = [Float](count: DisplayOptions.totalDays, repeatedValue: 0.0)
    //TEMP FAKE DATA VARS
    
    var weeksBack : Int = 0
    var startOfWeek : NSDate = NSDate()
    
    var display : StatDisplay = .Calorie
    var barSelection : Int = 0
    var goal : Int = 2000
    var caloriesConsumed : Int {
        get {
            return values[barSelection]
        }
    }
    
    //chart fonts -- default to small, but change to bigger on larger devices
    var selectorTextFont = DisplayOptions.SelectorTextFontNormal
    var calorieCenterTextFont = DisplayOptions.CalorieCenterTextFontNormal
    var calorieDescriptorTextFont = DisplayOptions.CalorieDescriptorTextFontNormal
    var calorieTotalLabelTextFont = DisplayOptions.CalorieTotalLabelTextFontNormal
    
    private struct DisplayOptions {
        //ANIMATION VARIABLES
        static let AnimateDuration : NSTimeInterval = 0.8
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
        
        static let ProteinColor = UIColor(hexString: "189090")
        static let CarbColor = UIColor(hexString: "F0B428")
        static let FatColor = UIColor(hexString: "E42640")
        
        //DATA SETTINGS
        static let totalDays = 7
        static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        static let DayLabels : [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
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
        startOfWeek = getMostRecentMonday()
        barSelection = getDayIndex()
        
        //LOAD FAKE DATA
        loadWeekData()
        //setup charts and selector
        dayChartSetup()
        weekChartSetup()
        selectorSetup()
        
        //update chart data
        updateUI()
    }
    
    func loadWeekData(){
        loadFakeData()
    }
    
    func loadFakeData(){
        for i in 0..<7 {
            values[i] = 1600 + Int(arc4random_uniform(800))
            dates[i] = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: startOfWeek, options: NSCalendarOptions.MatchNextTime)!
            
            var p = 0.2 + Float(arc4random_uniform(20)) * 0.01
            var f = 0.2 + Float(arc4random_uniform(10)) * 0.01
            var c = 0.3 + Float(arc4random_uniform(30)) * 0.01


            //make future dates have no data
            if(NSDate().compare(dates[i]) == NSComparisonResult.OrderedAscending){
                p = 0
                f = 0
                c = 0
                self.values[i] = 0
            }
            
            protein[i] = p
            fat[i] = f
            carbs[i] = c
        }
    }
    
    func loadEmptyData(){
        for i in 0..<7 {
            values[i] = 0
            dates[i] = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)!
            
            protein[i] = 0
            fat[i] = 0
            carbs[i] = 0
        }
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
        //statsSelector.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyle.BottomBar
        //statsSelector.selectionIndicatorHeight = DisplayOptions.SelectorHeight
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
        
    }
    
    func weekChartSetup() {
        weekChart.xAxis.drawAxisLineEnabled = false
        weekChart.xAxis.drawGridLinesEnabled = false
        weekChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        weekChart.xAxis.setLabelsToSkip(0)
        weekChart.setVisibleXRange(minXRange: 0, maxXRange: 7.0)
        
        let goalLine = ChartLimitLine(limit: Double(goal))
        goalLine.lineColor = DisplayOptions.GoalLineColor
        weekChart.leftAxis.addLimitLine(goalLine)
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
        
        let swipeRec = UISwipeGestureRecognizer()
        swipeRec.addTarget(self, action: "swipedView")
        weekChart.addGestureRecognizer(swipeRec)
        
        weekNavigator.changeTheme(.Black)
    }
    
    func swipedView(){
        print("SWIPED")
    }
    
    
    // MARK: - Calorie Data Update functions
    
    func updateDayCalorieChart(){
        //calorie specific settings
        dayChart.legend.enabled = false
        
        //if the user has consumed over their daily goal
        let over = caloriesConsumed > goal
        
        var displayValues : [Int]
        var labels : [String]
        var calorieString : String
        var calorieDescriptor : String
        
        if(over){
            displayValues = [goal, caloriesConsumed - goal]
            labels = ["Calories", "Over"]
            calorieString = String(caloriesConsumed - goal)
            calorieDescriptor = String("\nCALORIES\nOVER BUDGET")
        } else {
            displayValues = [caloriesConsumed, goal - caloriesConsumed]
            labels = ["Calories", "Left"]
            calorieString = String(goal - caloriesConsumed)
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
        dayChart.descriptionText = String(caloriesConsumed) + " / " + String(goal)
        
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
        for i in 0..<values.count {
            if(values[i] <= goal){
                barDataEntries.append(BarChartDataEntry(values: [Double(values[i]), 0], xIndex: i))
            } else {
                barDataEntries.append(BarChartDataEntry(values: [Double(goal), Double(values[i] - goal)], xIndex: i))
            }
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //dateFormatter.dateFormat = "M/dd"
        //dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        let dateStrings = dates.map { (date) -> String in
//            return dateFormatter.stringFromDate(date)
//        }
        barChartDataSet.barSpace = DisplayOptions.BarSpacing
        barChartDataSet.colors = [DisplayOptions.GoodColor, DisplayOptions.BadColor]
        barChartDataSet.drawValuesEnabled = false
        //barChartDataSet.setColors(DisplayOptions.DefaultColor)
        //barChartDataSet.highlightColor = getPrimaryColor()
        
        let barChartData = BarChartData(xVals: dateStrings, dataSet: barChartDataSet)
        weekChart.data = barChartData
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        weekNavigator.updateDateLabel()
        weekProgressDisplay.updateCalorieDisplay(Int(arc4random_uniform(3000)) - 1500)
    }
    
    
    // MARK: - Macro Data Update functions
    
    func updateDayMacroChart(){
        //Macro specific pie chart settings
        dayChart.descriptionText = ""
        dayChart.centerText = ""
        dayChart.legend.enabled = true
        
        
        let dayDataEntries: [ChartDataEntry] = [
            ChartDataEntry(value: Double(protein[barSelection]), xIndex: 0),
            ChartDataEntry(value: Double(carbs[barSelection]), xIndex: 1),
            ChartDataEntry(value: Double(fat[barSelection]), xIndex: 2)
        ]
        
        let labels = ["Protein", "Carbs", "Fat"]
        
        //configure macro data set
        let dayChartDataSet = PieChartDataSet(yVals: dayDataEntries)
        dayChartDataSet.colors = [DisplayOptions.ProteinColor, DisplayOptions.CarbColor, DisplayOptions.FatColor]
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
        
        for i in 0..<protein.count {
            let dataEntry = BarChartDataEntry(values: [Double(carbs[i]), Double(protein[i]), Double(fat[i])] , xIndex: i)
            barDataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries)
        
//        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.dateFormat = "M/dd"
        //dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        let dateStrings = dates.map { (date) -> String in
//            return dateFormatter.stringFromDate(date)
//        }
        
        barChartDataSet.barSpace = DisplayOptions.BarSpacing
        barChartDataSet.colors = [DisplayOptions.ProteinColor, DisplayOptions.CarbColor, DisplayOptions.FatColor]
        barChartDataSet.drawValuesEnabled = false
        let barChartData = BarChartData(xVals: dateStrings, dataSet: barChartDataSet)
        weekChart.data = barChartData
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        weekNavigator.updateDateLabel()
        weekProgressDisplay.updateMacroDisplay(Int(arc4random_uniform(200)) - 100,
            protein: Int(arc4random_uniform(200)) - 100,
            fat: Int(arc4random_uniform(200)) - 100)
    }
    
    // MARK: - Week Shifting Methods
    
    func shiftWeekPrev(){
        startOfWeek = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: startOfWeek, options: NSCalendarOptions.MatchPreviousTimePreservingSmallerUnits)!
        weeksBack++
        loadWeekData()
        updateUI()
    }
    
    func shiftWeekNext(){
        if(weeksBack == 0){
            return
        }
        startOfWeek = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 7, toDate: startOfWeek, options: NSCalendarOptions.MatchNextTime)!
        weeksBack--
        loadWeekData()
        updateUI()
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
    
    // MARK: -  ProgressDisplayDataSource Protocol Methods

    func getWeeklyCalorieChange(sender: ProgressDisplay) -> Int{
        return 200
    }
    
    func getWeeklyCarbChange(sender: ProgressDisplay) -> Int{
        return 100
    }
    
    func getWeeklyProteinChange(sender : ProgressDisplay) -> Int{
        return 20
    }
    
    func getWeeklyFatChange(sender: ProgressDisplay) -> Int {
        return 30
    }


    

    
    
    // MARK: - Chart Protocol Methods
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        barSelection = entry.xIndex
        //highlight the whole bar, not just the segment that was actually clicked on
        weekChart.highlightValue(xIndex: barSelection, dataSetIndex: 0, callDelegate: false)
        updateDayChart()
        print(entry.xIndex)
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
    func getDayIndex() -> Int {
        let component = NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
        //Days range from 0-7, and Monday is 2
        return (component + 5) % 7
    }
    
    
    
    func getLabelColor() -> UIColor {
        if(caloriesConsumed <= goal){
            return DisplayOptions.GoodSecondary
        } else {
            return DisplayOptions.BadPrimary
        }
    }
    
    func getPrimaryColor() -> UIColor {
        if(caloriesConsumed <= goal){
            return DisplayOptions.GoodPrimary
        } else {
            return DisplayOptions.BadPrimary
        }
    }
}


