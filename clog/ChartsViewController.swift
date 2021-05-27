import UIKit
import CoreData
import Charts

class ChartsViewController: UIViewController {
    
    var container: NSPersistentContainer!

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [2.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 17.0, 2.0, 4.0, 5.0, 4.0]
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        
        setChart(xValues: months, yValuesLineChart:  unitsSold, yValuesBarChart: unitsSold)
        
        let surveyResults = fetchRecordsForEntity("Survey")
        var sleepQuality: [Int16] = []
        for i in 0..<surveyResults.count{
            sleepQuality.append(surveyResults[i].value(forKey: "sleepQuality") as! Int16)
        }
        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhak", "Torreira"]
        let goals: [Double] = [6, 8, 26, 30, 8, 10]
        let preet = ["Preet"]
        customizeChart(dataPoints: preet, values:sleepQuality)
    }
    
    func customizeChart (dataPoints: [String], values: [Int16]){
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = "Please provide data for the chart."

        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()

        for i in 0..<xValues.count {

            yVals1.append(ChartDataEntry(x: yValuesLineChart[i], y: Double(i)))
            yVals2.append(BarChartDataEntry(x: yValuesBarChart[i] - 1, y: Double(i)))

        }

        let lineChartSet = LineChartDataSet(entries: yVals1, label: "Line Data")
        let barChartSet: BarChartDataSet = BarChartDataSet(entries: yVals2, label: "Bar Data")
        
        let lineChartData = LineChartData(dataSets: [lineChartSet])
        let barChartData = BarChartData(dataSets: [barChartSet])

        let data: CombinedChartData = CombinedChartData()
        data.barData = barChartData
        data.lineData = lineChartData

        combinedChartView.data = data

    }
}
