//
//  TableViewController.swift
//  ALPHACamp_finalAssessment_Q4
//
//  Created by Ka Ho on 16/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON

class TableViewController: UITableViewController {

    var metroInfo:[arrivedMetroInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.LabeledProgress(title: "可愛的捷運資訊載入中。。。", subtitle: "稍候喔"))
        metroDataAPICall { (result) in
            let allRows = result["result"]["results"].arrayValue
            for row in allRows {
                let eachCuteCuteMetro = arrivedMetroInfo()
                eachCuteCuteMetro.id = row["_id"].stringValue
                eachCuteCuteMetro.station = row["Station"].stringValue
                eachCuteCuteMetro.destination = row["Destination"].stringValue
                eachCuteCuteMetro.updatedTime = self.timeStandardToHumanReadable(row["UpdateTime"].stringValue)
                self.metroInfo.append(eachCuteCuteMetro)
            }
        }

    }

    func timeStandardToHumanReadable(nonFriendlyString: String) -> String {
        // this string can be like
        // 2016-05-16T18:00:51.953     or like
        // 2016-05-16T18:00:51.95      or even
        // 2016-05-16T18:00:51         that will be nil when extracting, i love this api...
        let sourceString = nonFriendlyString
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = sourceString.characters.count == 23 ? "yyyy-MM-dd'T'HH:mm:ss.SSS" : (sourceString.characters.count == 22 ? "yyyy-MM-dd'T'HH:mm:ss.SS" : "yyyy-MM-dd'T'HH:mm:ss")
        let nsdate = dateFormatter.dateFromString(sourceString)
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        return outputDateFormatter.stringFromDate(nsdate!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
