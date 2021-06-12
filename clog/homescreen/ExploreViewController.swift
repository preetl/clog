import UIKit
import Charts
import CoreData
import HealthKit

class ExploreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData = ["sleep time", "sleep quality", "phone in bed time", "mood", "step count"]
    
    var surveyResults: [NSManagedObject] = []
    
    //let day = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
//    let sleepQuality = [4.0, 3.0, 8.0, 10.0, 4.0]
//    let sleep = [360, 335.0, 450.0, 540, 450]
//    let mood = [4.0, 3.0, 2.0, 4.0, 3.0]
//    let phoneBed = [45.0, 75.0, 30.0, 15.0, 30.0]
    
    let healthStore = HKHealthStore()
    
    var sleepQuality: [Double] = []
    var sleep: [Double] = []
    var phoneBed: [Double] = []
    var mood: [Double] = []
    var dates: [Date] = []
    var steps: [Double] = []
    
    var container: NSPersistentContainer!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel;
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.appBoldFontWith(size: 14)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.ClogColors.MetalBlue
        }
        pickerLabel?.text = pickerData[row]
        return pickerLabel!;
    }
    
    
    @IBOutlet weak var combinedChart: CombinedChartView!
    @IBOutlet weak var pickerRight: UIPickerView!
    @IBOutlet weak var pickerLeft: UIPickerView!
    @IBOutlet weak var doButton: UIButton!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
    inComponent component: Int) {
        if pickerLeft.selectedRow(inComponent: 0) == pickerRight.selectedRow(inComponent: 0){
            doButton.isEnabled = false
            doButton.alpha = 0.5
            
            
        }else{
            doButton.isEnabled = true
            doButton.alpha = 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        
        doButton.layer.cornerRadius = 10
        pickerLeft.delegate = self
        pickerLeft.dataSource = self
        pickerRight.delegate = self
        pickerRight.dataSource = self
        pickerRight.selectRow(1, inComponent: 0, animated: true)
        
        combinedChart.isHidden = true
        
        let text = "play around with your data!"
        let subtext = "Explore trends in your behaviours. Choose 2 different variables and see if there is a relationship between them over time"
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
        
        attributedText.append(NSAttributedString(string: "\n\n\(subtext)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))
        
        instruction.attributedText = attributedText
        instruction.textAlignment = .left
        
        surveyResults = fetchRecordsForEntity("Survey")
        
        sleep = []
        mood = []
        sleepQuality = []
        phoneBed = []
        dates = []
        
        for i in 0..<surveyResults.count{
            sleepQuality.append(surveyResults[i].value(forKey: "sleepQuality") as! Double)
            sleep.append((surveyResults[i].value(forKey: "sleep") as! Double)/60)
            phoneBed.append((surveyResults[i].value(forKey: "phoneBed") as! Double)/60)
            mood.append(surveyResults[i].value(forKey: "mood") as! Double)
            dates.append(surveyResults[i].value(forKey: "date") as! Date)
        }
        print("sleep", sleep, "mood", mood, "phoneBed", phoneBed, "sleepQuality", sleepQuality, "date", dates)
        
        for date in dates{
            getSteps(day: date) { (result) in
                DispatchQueue.main.async {
                    let stepCount = Double(result)
                    self.steps.append(stepCount)
                    print("step count", result)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func compareButtonTapped(button: UIButton) {
        
        if surveyResults.count < 2 {
            
            let text = "sorry :("
            let subtext = "clog. is still collecting data for you to explore. check here the day after tomorrow or after you've completed 2 daily questionnaires."
            let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
            
            attributedText.append(NSAttributedString(string: "\n\n\(subtext)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))
            
            instruction.attributedText = attributedText
            
        }else{
            
            combinedChart.isHidden = false
            instruction.isHidden = true
            icon.isHidden = true
            
            let leftPick = pickerLeft.selectedRow(inComponent: 0)
            let rightPick = pickerRight.selectedRow(inComponent: 0)
            
            let leftLookup = dataFromPick(index: leftPick)
            let rightLookup = dataFromPick(index: rightPick)
            
            print("left index: ", leftLookup)
            print("right index: ", rightLookup)
            
            
            let barChartData = generateBarData(values: rightLookup.data, label: rightLookup.label)
            let lineChartData = generateLineData(values: leftLookup.data, label: leftLookup.label)
            print("line", leftLookup.data)
            
            combinedChart.drawOrder = [DrawOrder.bar.rawValue,
                                   DrawOrder.line.rawValue]
            
            let data: CombinedChartData = CombinedChartData()
            data.lineData = lineChartData
            data.barData = barChartData

            combinedChart.data = data
            
            let xAxis = combinedChart.xAxis
            xAxis.labelFont = UIFont.appBoldFontWith(size: 11)
            xAxis.labelTextColor = UIColor.ClogColors.MetalBlue
            xAxis.drawAxisLineEnabled = false
            xAxis.granularityEnabled = true
            xAxis.granularity = 1
            xAxis.valueFormatter = self
            
            let leftAxis = combinedChart.leftAxis
            leftAxis.labelTextColor = UIColor.gray
            leftAxis.axisMaximum = leftLookup.data.max()! + (0.1*(leftLookup.data.max()!))
            leftAxis.axisMinimum = leftLookup.data.min()!
            leftAxis.drawGridLinesEnabled = false
            leftAxis.granularityEnabled = true
            leftAxis.granularity = 1
            
            let rightAxis = combinedChart.rightAxis
            rightAxis.labelTextColor = UIColor.gray
            rightAxis.axisMaximum = rightLookup.data.max()! + (0.1*(rightLookup.data.max()!))
            rightAxis.axisMinimum = rightLookup.data.min()!
            rightAxis.granularityEnabled = true
            rightAxis.granularity = 1
            
            combinedChart.notifyDataSetChanged()
            combinedChart.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
            combinedChart.fitScreen()

            
        }
    }
    
    func dataFromPick(index:Int)-> (data: [Double], label: String){
        var data: [Double]
        var label = ""
        switch index {
        case 0:
            data =  sleep
            label = "sleep"
        case 1:
            data = sleepQuality
            label = "sleep quality"
        case 2:
            data = phoneBed
            label = "phone in bed"
        case 3:
            data = mood
            label = "mood"
        case 4:
            data = steps
            label = "step count"
        default:
            data = sleep
            label = "sleep"
        }
        return (data, label)
    }
    
    func generateBarData(values: [Double], label: String)-> BarChartData{
        
        var entries : [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<values.count {

            entries.append(BarChartDataEntry(x: Double(i), y: Double(values[i])))

        }
        entries.sort(by: { $0.x < $1.x })
        let set = BarChartDataSet(entries: entries, label: label)
        set.valueTextColor = UIColor.ClogColors.MetalBlue
        set.valueFont = UIFont.appRegularFontWith(size: 14)
        let colors = [UIColor.ClogColors.ActionPink]
        set.setColors(colors, alpha: 1.0)
        set.axisDependency = YAxis.AxisDependency.right
        //set.valueFormatter2 = BarValueFormatter()
        
        let data = BarChartData(dataSet: set)
        return data
    }
    
    func generateLineData(values: [Double], label: String) -> LineChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            var value = values[i]
            value.round()
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(value))
          dataEntries.append(dataEntry)
        }
        dataEntries.sort(by: { $0.x < $1.x })
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        chartDataSet.lineWidth = 1.75
        chartDataSet.circleRadius = 5.0
        chartDataSet.circleHoleRadius = 2.5
        chartDataSet.setColor(UIColor.ClogColors.MetalBlue)
        chartDataSet.setCircleColor(UIColor.ClogColors.MetalBlue)
        chartDataSet.highlightColor = UIColor.ClogColors.MetalBlue
        chartDataSet.drawValuesEnabled = true
        chartDataSet.axisDependency = YAxis.AxisDependency.left
        let chartData = LineChartData(dataSet: chartDataSet)
        return chartData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchRecordsForEntity(_ entity: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var result = [NSManagedObject]()

        do {
            let records = try container.viewContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }

    func getSteps(day: Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = day.startOfDay
        var endOfDay = Date()
        if Calendar.current.isDate(day, inSameDayAs: now){
            endOfDay = now
        }else{
            endOfDay = day.endOfDay
        }
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }

}

extension ExploreViewController: AxisValueFormatter{
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd-MMM"

        return formatter.string(from: dates[Int(value) % dates.count])
    }
}

