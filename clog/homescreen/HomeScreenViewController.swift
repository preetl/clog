import UIKit
import Charts
import CoreData
import HealthKit

class HomeScreenViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var lineChart1: LineChartView!
    @IBOutlet weak var lineChart2: LineChartView!
    @IBOutlet weak var lineChart3: LineChartView!
    @IBOutlet weak var lineChart4: LineChartView!
    
    let colors = [UIColor.ClogColors.ActionPink,
                  UIColor(red: 240/255, green: 240/255, blue: 30/255, alpha: 1),
                  UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
                  UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1)]
    
//    let day = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
//    let sleepQuality = [4.0, 3.0, 8.0, 10.0, 4.0]
//    let sleep = [360.0, 335.0, 450.0, 540.0, 450.0]
    
    var surveyResults: [NSManagedObject] = []
    
    var sleepQuality: [Double] = []
    var sleep: [Double] = []
    var phoneBed: [Double] = []
    var mood: [Double] = []
    var dates: [Date] = []
    var steps: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("weekly in")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("weekly out")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        surveyResults = fetchRecordsForEntity("Survey")
        
        sleepQuality = []
        sleep = []
        phoneBed = []
        steps = []
        dates = []
        
        if surveyResults.count >= 1 {
            for i in 0..<surveyResults.count{
                sleepQuality.append(surveyResults[i].value(forKey: "sleepQuality") as! Double)
                sleep.append((surveyResults[i].value(forKey: "sleep") as! Double)/60)
                phoneBed.append((surveyResults[i].value(forKey: "phoneBed") as! Double)/60)
                dates.append(surveyResults[i].value(forKey: "date") as! Date)
            }
            
            for date in dates{
                getSteps(day: date) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Double(result)
                        self.steps.append(stepCount)
                        print("step count", result)
                    }
                }
            }
            
            createCharts()
        }
        
    }
    
    func createCharts(){
        
        let metalBlue = UIColor.ClogColors.MetalBlue
        let actionPink = UIColor.ClogColors.ActionPink
        let warmBeige = UIColor.ClogColors.WarmBeige
        let lessBlue = UIColor.ClogColors.LessBlue

        let data1 = customizeData()
        data1.setValueFont(UIFont(name: "Montserrat", size: 7)!)
        setupChart(lineChart1, data: generateLineData(values: sleep, label: "sleep", color: metalBlue), color: warmBeige)

        let data2 = data1
        data2.setValueFont(UIFont(name: "Montserrat", size: 7)!)
        setupChart(lineChart2, data: generateLineData(values: sleepQuality, label: "sleep quality", color: .white), color: warmBeige)

        let data3 = data1
        data3.setValueFont(UIFont(name: "Montserrat", size: 7)!)
        setupChart(lineChart3, data: generateLineData(values: phoneBed, label: "phone in bed", color: metalBlue), color: warmBeige)

        let data4 = data1
        data4.setValueFont(UIFont(name: "Montserrat", size: 7)!)
        setupChart(lineChart4, data: generateLineData(values: steps, label: "step count", color: .white), color: warmBeige)
    }
    
    func setupChart(_ chart: LineChartView, data: LineChartData, color: UIColor) {
        (data[0] as! LineChartDataSet).circleHoleColor = color
        
        //chart.delegate = self
        chart.backgroundColor = color
        
        chart.chartDescription.enabled = false
        
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = false
        chart.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
        chart.legend.enabled = false
        
        chart.leftAxis.enabled = false
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = true
        chart.xAxis.valueFormatter = self
        
        chart.data = data
        
        chart.animate(xAxisDuration: 2.5)
        chart.fitScreen()
    }
    
    func customizeData() -> LineChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<sleepQuality.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(sleepQuality[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Bar Chart View")
        chartDataSet.lineWidth = 2 //1.75
        chartDataSet.circleRadius = 6.0 //5.0
        chartDataSet.circleHoleRadius = 3 //2.5
        chartDataSet.setColor(.white)
        chartDataSet.setCircleColor(.white)
        chartDataSet.highlightColor = .white
        chartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSet: chartDataSet)
        return chartData
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
    
    func generateLineData(values: [Double], label: String, color: UIColor) -> LineChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        chartDataSet.lineWidth = 1.75
        chartDataSet.circleRadius = 5.0
        chartDataSet.circleHoleRadius = 2.5
        chartDataSet.setColor(UIColor.ClogColors.MetalBlue)
        chartDataSet.setCircleColor(UIColor.ClogColors.MetalBlue)
        chartDataSet.highlightColor = UIColor.ClogColors.MetalBlue
        chartDataSet.drawValuesEnabled = true
        chartDataSet.axisDependency = YAxis.AxisDependency.right
        let chartData = LineChartData(dataSet: chartDataSet)
        return chartData
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

extension HomeScreenViewController: AxisValueFormatter {
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd-MMM"

        return formatter.string(from: dates[Int(value)])
    }
}
