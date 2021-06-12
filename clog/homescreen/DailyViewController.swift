import UIKit
import Charts
import CoreData

class DailyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate var numberFormatter: NumberFormatter?
    
    @IBOutlet weak var chartView: PieChartView!
    
    var sleepQuality = 0.0
    var sleep = 0.0
    var phoneBed = 0.0
    var mood = 0.0
    var date = Date()
    var steps = 0.0
    
    let subheadings = ["mood", "steps", "sleep", "phone use in bed"]
    let moodIcons = ["cloud.rain.fill", "cloud.fill", "cloud", "cloud.sun", "sun.max"]
    
    let reuseIdentifier = "mycell"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPieChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func loadPieChart(){
        
        print("pie chart loading")
        
        chartView.holeColor = .white
        chartView.transparentCircleColor = NSUIColor.white.withAlphaComponent(0.43)
        chartView.holeRadiusPercent = 0.58
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = true
        
        chartView.maxAngle = 180 // Half chart
        chartView.rotationAngle = 180 // Rotate to make the half on the upper side
        chartView.centerTextOffset = CGPoint(x: 0, y: -20)
        
        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = UIFont.appRegularFontWith(size: 14)
        //chartView.legend = l

        // entry label styling
        chartView.drawEntryLabelsEnabled = false
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont.appRegularFontWith(size: 14)
        
        self.updateChartData()
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    

    func updateChartData() {
        let values = [sleep, phoneBed]
        let labels = ["sleep", "phone use in bed"]
        var entries = (0..<2).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: values[i % values.count],
                                     label: labels[i % labels.count])
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 3
        set.selectionShift = 5
        set.colors = [UIColor.ClogColors.ActionPink, UIColor.ClogColors.MetalBlue]
        set.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: set)
        
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(self)
    
        data.setValueFont(UIFont.appBoldFontWith(size: 14))
        data.setValueTextColor(UIColor.ClogColors.MetalBlue)
        
        chartView.data = data
        
        chartView.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("daily now")
        loadPieChart()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("daily out")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        let text = getText(index: Int(indexPath.item))
        let image = getImage(index: Int(indexPath.item))
        
        if Int(indexPath.item) == 0 {
            cell.butt.isHidden = false
        }else{
            cell.butt.isHidden = true
        }
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.attributedText = text
        cell.label.textAlignment = .center
        cell.icon.image = image
        cell.icon.tintColor = UIColor.ClogColors.MetalBlue
        cell.backgroundColor = UIColor.ClogColors.WarmBeige
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        if indexPath.item == 0{
            
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "moodinfo")
            nextVC.modalPresentationStyle = .popover
            nextVC.preferredContentSize = CGSize(width: 100, height: 30)
            show(nextVC, sender: self)
        }
    }
    
    func getText(index: Int)-> NSMutableAttributedString{
        let subHeading = subheadings[index]
        var heading = ""
        switch index{
            case 0:
                heading = ""
            case 1:
                heading = String(Int(steps))
            case 2:
                heading = String(timeToString(time: sleep))
            case 3:
                heading = String(timeToString(time: phoneBed))
            default:
                heading = "yeet"
        }
        
        let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])

        attributedText.append(NSAttributedString(string: "\n\(subHeading)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))
        
        return attributedText
            
    }
    
    func getImage(index: Int)-> UIImage{
        switch index{
            case 0:
                return UIImage(systemName:moodIcons[Int(mood)]) ?? UIImage(systemName: "sun.max")!
            case 1:
                return UIImage(named:"walking")!
            case 2:
                return UIImage(systemName:"moon.zzz.fill")!
            case 3:
                return UIImage(systemName:"iphone.homebutton")!
            default:
                return UIImage(systemName:"iphone.homebutton")!
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

}

extension DailyViewController {
    public func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }

        public func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                let frameSize = collectionView.frame.size
//                let size = (frameSize.width - 60.0) / 2.0 // 27 px on both side, and within, there is 10 px gap.
//                print("fram", frameSize, "size", size)
//                return CGSize(width: size, height: size)
//
//        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height - 260
        let width = view.frame.size.width
        
        let cellHeight = (height - 30.0)/2.0
        let cellWidth = (width - 60.0)/2.0
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func timeToString(time: Double) -> String{
        let intTime = Int(time)
        let hours = intTime / 60
        let mins = intTime % 60
        if hours == 0{
            return"\(mins) mins"
        }
        return "\(hours)h \(mins)mins"
    }
}

extension DailyViewController: ValueFormatter {

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        let intVal = Int(value)
//        let hours = intVal / 60
//        let mins = intVal % 60
//        if hours == 0 {
//            return String("\(mins) mins")
//        }
//        else{
//            return String("\(hours)h \(mins)mins")
//        }
        return ""
    }
}
