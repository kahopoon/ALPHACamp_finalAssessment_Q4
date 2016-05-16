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
    
    func loadData() {
        // remove cache in exist
        metroInfo.removeAll()
        print("test")
        HUD.show(.LabeledProgress(title: "可愛的捷運資訊", subtitle: "正在可愛地載入中。。。"))
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
            self.refreshControl?.endRefreshing()
            HUD.hide()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.loadData), forControlEvents: .ValueChanged)
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
        loadData()
    }

    func timeStandardToHumanReadable(nonFriendlyString: String) -> String {
        // this string can be like
        // 2016-05-16T18:00:51.953     or like
        // 2016-05-16T18:00:51.95      or maybe
        // 2016-05-16T18:00:51.9       or even
        // 2016-05-16T18:00:51         that will be nil when extracting, i love this api...
        let sourceString = nonFriendlyString
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = sourceString.characters.count == 23 ? "yyyy-MM-dd'T'HH:mm:ss.SSS" : (sourceString.characters.count == 22 ? "yyyy-MM-dd'T'HH:mm:ss.SS" : (sourceString.characters.count == 21 ? "yyyy-MM-dd'T'HH:mm:ss.S" : "yyyy-MM-dd'T'HH:mm:ss"))
        let nsdate = dateFormatter.dateFromString(sourceString)
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        return outputDateFormatter.stringFromDate(nsdate!)
    }
    
    func alertOfAnswer(answer: String) {
        let showMessage = "真的是\(answer)耶!"
        let alertController = UIAlertController(title: "你好聰明，竟然答對了！", message: showMessage, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "當然當然", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        alertOfAnswer(metroInfo[indexPath.row].destination!)
    }
}
