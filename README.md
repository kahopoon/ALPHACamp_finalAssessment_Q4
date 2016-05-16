# ALPHACamp_finalAssessment_Q4

## Data Source
臺北市政府資料開放平台：臺北捷運列車到站站名  
Taipei Gov Open Data: Taipei Metro Arrived Station Info
http://data.taipei/opendata/datalist/datasetMeta?oid=6556e1e8-c908-42d5-b984-b3f7337b139b

## App screen
![Alt text](launch.png?raw=true "launch")
![Alt text](show.png?raw=true "show")
![Alt text](alert.png?raw=true "alert")
![Alt text](refresh.png?raw=true "refresh")  

## Pod install
```
	pod 'Alamofire'
	pod 'SwiftyJSON'
	pod 'PKHUD'
```

## API Call
```swift
let callURL:String = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=55ec6d6e-dc5c-4268-a725-d04cc262172b"

func metroDataAPICall(completion: (result: JSON) -> Void) {
    Alamofire.request(.GET, callURL).responseJSON { (response) in
        completion(result: JSON(response.result.value!))
    }
}
```

## Data Model
```swift
class arrivedMetroInfo {
    var id:String?
    var station:String?
    var destination:String?
    var updatedTime:String?
}
```

## TableView Controller

### Data load
```swift
func loadData() {
        // remove cache in exist
        metroInfo.removeAll()
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
```
in this function, clear array (becuase pull to refresh will simply use this function too), show loading label, manipulate api data into class object and insert into array, when down, reload table view, hide loading label.  

### viewDidLoad
```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.loadData), forControlEvents: .ValueChanged)
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
        loadData()
    }
```
simply implement of pull to refresh and initial load of data, don't forget click enable refresh on storyboard to activate pull to refresh.  

### time format converter
```swift
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
```
nothing special here, just convert data from api to human readable time format, but notice the api data can be different format everytime you grep, make some condition for avoiding nil.

### alert notice
```swift
func alertOfAnswer(answer: String) {
        let showMessage = "真的是\(answer)耶!"
        let alertController = UIAlertController(title: "你好聰明，竟然答對了！", message: showMessage, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "當然當然", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
```
this is for alert prompt when user click on row to get the destination of the metro

### selected row action
```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        alertOfAnswer(metroInfo[indexPath.row].destination!)
    }
```
this is essential for above's alert notice, using indexpath row to grep destination station from array and display alert

### insert data into cell
```swift
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.arrivedStationLabel.text = metroInfo[indexPath.row].station
        cell.timeLabel.text = metroInfo[indexPath.row].updatedTime
        return cell
    }
```
two label for data insertion

## TableView Cell UI
very simple UI :)  
![Alt text](tableviewCell.png?raw=true "tableviewCell") 
