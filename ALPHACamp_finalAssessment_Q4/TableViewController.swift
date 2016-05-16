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
            self.tableView.reloadData()
            HUD.hide()
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
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metroInfo.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.arrivedStationLabel.text = metroInfo[indexPath.row].station
        cell.timeLabel.text = metroInfo[indexPath.row].updatedTime
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
