//
//  RecipeTableViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/19/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {

//    @IBOutlet weak var searchContainer: SearchViewController!{
//        didSet{
//            if(searchContainer == nil){
//                print("nil")
//            } else {
//                print("not nil")
//            }
//           // searchContainer.filter.meal = 1
//        }
//    }
    
    var filter = MenuFilter()
    
    var recipes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        recipes.append("Grilled Chicken")
//        recipes.append("Broccoli")
//        recipes.append("Chicken Noodle Soup")
//        recipes.append("BBQ Chicken Pizza")
//        recipes.append("Vegetable Pizza")
//        recipes.append("Hawaiian Pizza")
//        recipes.append("Cereal")
//        recipes.append("Yogurt")
//        recipes.append("Grilled Salmon")
//        recipes.append("Tomato Soup")
//        recipes.append("Vanilla Ice Cream")
//        recipes.append("Chocolate Chip Cookies")
        
        self.tableView.reloadData()
        
//        if(searchContainer != nil){
//            print("It's not nil!")
//            searchContainer.recipeTable = nil
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateFilter(filter : MenuFilter) {
        self.filter = filter
        print("Menu changed!")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Recipe", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as UITableViewCell
        


        // Configure the cell...
        cell.textLabel?.text = recipes[indexPath.row]
//        cell.textLabel?.text = "My text"
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
