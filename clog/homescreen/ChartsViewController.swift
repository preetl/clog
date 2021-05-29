//import UIKit
//import CoreData
//import Charts
//
//class ChartsViewController: UITableViewController {
//
//    var container: NSPersistentContainer!
//
//    @IBOutlet weak var lineChart1: LineChartView!
//    @IBOutlet weak var lineChart2: LineChartView!
//    @IBOutlet weak var lineChart3: LineChartView!
//    @IBOutlet weak var lineChart4: LineChartView!
//    
//    let day = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
//    let sleepQuality = [4.0, 3.0, 8.0, 10.0, 4.0]
//    let sleep = [360.0, 335.0, 450.0, 540.0, 450.0]
//
//    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//    let unitsSold = [2.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 17.0, 2.0, 4.0, 5.0, 4.0]
//
//    func fetchRecordsForEntity(_ entity: String) -> [NSManagedObject] {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        var result = [NSManagedObject]()
//
//        do {
//            let records = try container.viewContext.fetch(fetchRequest)
//
//            if let records = records as? [NSManagedObject] {
//                result = records
//            }
//
//        } catch {
//            print("Unable to fetch managed objects for entity \(entity).")
//        }
//
//        return result
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        container = appDelegate.persistentContainer
//
////        setChart(xValues: day, yValuesLineChart: sleepQuality, yValuesBarChart: sleep)
////
////        let surveyResults = fetchRecordsForEntity("Survey")
////        var sleepQuality: [Int16] = []
////        for i in 0..<surveyResults.count{
////            sleepQuality.append(surveyResults[i].value(forKey: "sleepQuality") as! Int16)
////        }
////        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhak", "Torreira"]
////        let goals: [Double] = [6, 8, 26, 30, 8, 10]
////        let preet = ["Preet"]
////        customizeChart(dataPoints: preet, values:sleepQuality)
//
//        let colors = [UIColor(red: 137/255, green: 230/255, blue: 81/255, alpha: 1),
//                      UIColor(red: 240/255, green: 240/255, blue: 30/255, alpha: 1),
//                      UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
//                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1)]
//
////        let data1 = customizeData()
////        data1.setValueFont(UIFont(name: "Montserrat", size: 7)!)
////        setupChart(lineChart1, data: data1, color: colors[0])
////
////        let data2 = customizeData()
////        data2.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
////        setupChart(lineChart1, data: data2, color: colors[1])
////
////        let data3 = customizeData()
////        data3.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
////        setupChart(lineChart1, data: data3, color: colors[2])
////
////        let data4 = customizeData()
////        data4.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
////        setupChart(lineChart1, data: data4, color: colors[3])
//
//    }
//
//    func setupChart(_ chart: LineChartView, data: LineChartData, color: UIColor) {
//        (data[0] as! LineChartDataSet).circleHoleColor = color
//
//        //chart.delegate = self
//        chart.backgroundColor = color
//
//        chart.chartDescription.enabled = false
//
//        chart.dragEnabled = true
//        chart.setScaleEnabled(true)
//        chart.pinchZoomEnabled = false
//        chart.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0)
//
//        chart.legend.enabled = false
//
//        chart.leftAxis.enabled = true
//        chart.leftAxis.spaceTop = 0.4
//        chart.leftAxis.spaceBottom = 0.4
//        chart.rightAxis.enabled = false
//        chart.xAxis.enabled = true
//
//        chart.data = data
//
//        chart.animate(xAxisDuration: 2.5)
//    }
//
//    func dataWithCount(_ count: Int, range: UInt32) -> LineChartData {
//        let yVals = (0..<count).map { i -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range)) + 3
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//
//        let set1 = LineChartDataSet(entries: yVals, label: "DataSet 1")
//
//        set1.lineWidth = 1.75
//        set1.circleRadius = 5.0
//        set1.circleHoleRadius = 2.5
//        set1.setColor(.white)
//        set1.setCircleColor(.white)
//        set1.highlightColor = .white
//        set1.drawValuesEnabled = false
//
//        return LineChartData(dataSet: set1)
//    }
//
//    func customizeData() -> LineChartData {
//        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<sleepQuality.count {
//          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(sleepQuality[i]))
//          dataEntries.append(dataEntry)
//        }
//        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Bar Chart View")
//        chartDataSet.lineWidth = 1.75
//        chartDataSet.circleRadius = 5.0
//        chartDataSet.circleHoleRadius = 2.5
//        chartDataSet.setColor(.white)
//        chartDataSet.setCircleColor(.white)
//        chartDataSet.highlightColor = .white
//        chartDataSet.drawValuesEnabled = false
//
//        let chartData = LineChartData(dataSet: chartDataSet)
//        return chartData
//    }
//
////    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
////        combinedChartView.noDataText = "Please provide data for the chart."
////
////        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
////        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
////
////        for i in 0..<xValues.count {
////
////            yVals1.append(ChartDataEntry(x: yValuesLineChart[i], y: Double(i)))
////            yVals2.append(BarChartDataEntry(x: yValuesBarChart[i], y: Double(i)))
////
////        }
////
////        let lineChartSet = LineChartDataSet(entries: yVals1, label: "Line Data")
////        let barChartSet: BarChartDataSet = BarChartDataSet(entries: yVals2, label: "Bar Data")
////
////        let lineChartData = LineChartData(dataSets: [lineChartSet])
////        let barChartData = BarChartData(dataSets: [barChartSet])
////
////        let data: CombinedChartData = CombinedChartData()
////        data.barData = barChartData
////        data.lineData = lineChartData
////
////        combinedChartView.data = data
////
////    }
//
//   }
