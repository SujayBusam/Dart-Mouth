//
//  StatsViewController.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {

    @IBOutlet weak var dayChart: PieChartView!
    @IBOutlet weak var weekChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCalorieData()
    }
    
    func setCalorieData() {
        
        let dataPoints = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        let values = [1500.0, 2000.0, 1700.0, 1800.0, 1600.0, 2150.0, 1550.0]

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        weekChart.noDataTextDescription = "TEST"
        weekChart.noDataText = "TEST"
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Calories")
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        weekChart.data = barChartData
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Calories")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        dayChart.data = pieChartData
        
    }
}
