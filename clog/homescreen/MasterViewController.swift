import UIKit
import CoreData
import HealthKit

class MasterViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataIcon: UIImageView!
    
    var allViewControllers: [DailyViewController] = []
    
    var container: NSPersistentContainer!
    
    var currentViewControllerIndex = 0
    
    var numSegments = 1
    
    let healthStore = HKHealthStore()

    var surveyResults: [NSManagedObject] = []
    
    var sleepQuality: [Double] = []
    var sleep: [Double] = []
    var phoneBed: [Double] = []
    var mood: [Double] = []
    var dates: [Date] = []
    var steps: [Double] = []
    
//    private lazy var dailyViewController: DailyViewController = {
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//
//        // Instantiate View Controller
//        var viewController = storyboard.instantiateViewController(withIdentifier: "homedailyVC") as! DailyViewController
//
//        // Add View Controller as Child View Controller
//        self.add(asChildViewController: viewController)
//
//        return viewController
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        loadData()
        if surveyResults.count<1{
            setupEmptyView()
        }else{
            setupView()
        }

    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.isHidden = false
        
        var title = ""
        
        for i in 0..<dates.count{
            title = dateToString(date: dates[i])
            if Calendar.current.isDateInToday(dates[i]){
                title = "TODAY"
            }
            segmentedControl.insertSegment(withTitle: title, at: i, animated: false)
        }

        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = dates.count - 1
        let font = UIFont.appRegularFontWith(size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    private func setupView() {
        
        setupSegmentedControl()
        self.view.backgroundColor = .white
        noDataIcon.isHidden = true
        noDataLabel.isHidden = true
        
        for i in 0..<surveyResults.count{
            if let vc = setupDailyViewController(at: i){
                allViewControllers.append(vc)
            }
        }
    }
    
    private func setupEmptyView() {
        segmentedControl.isHidden = true
        noDataIcon.isHidden = false
        noDataLabel.isHidden = false
        self.view.backgroundColor = UIColor.ClogColors.WarmBeige
        let heading = "are you a waiter? ... because you're really good at waiting!"
        let subHeading = "Thank you for downloading and setting up clog! Check here again after completing your first questionnaire for insights."
        let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])

        attributedText.append(NSAttributedString(string: "\n\n\(subHeading)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))

        noDataLabel.attributedText = attributedText
    }
    
    private func updateView() {
        remove(asChildViewController: allViewControllers[currentViewControllerIndex])
        add(asChildViewController: allViewControllers[segmentedControl.selectedSegmentIndex])
        currentViewControllerIndex = segmentedControl.selectedSegmentIndex
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupDailyViewController(at index: Int) -> DailyViewController? {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
            if let dailyContentViewController = storyBoard.instantiateViewController(withIdentifier: "homedailyVC") as? DailyViewController {
                dailyContentViewController.date = dates[index]
                dailyContentViewController.sleep = sleep[index]
                dailyContentViewController.sleepQuality = sleepQuality[index]
                dailyContentViewController.mood = mood[index]
                //dailyContentViewController.steps = steps[index]
                dailyContentViewController.phoneBed = phoneBed[index]
                self.add(asChildViewController: dailyContentViewController)
                return dailyContentViewController
            }
        return nil
    }

    func loadData(){
        surveyResults = fetchRecordsForEntity("Survey")
        
        sleepQuality = []
        sleep = []
        phoneBed = []
        mood = []
        steps = []
        dates = []
        
        if surveyResults.count >= 1 {
            for i in 0..<surveyResults.count{
                sleepQuality.append(surveyResults[i].value(forKey: "sleepQuality") as! Double)
                mood.append(surveyResults[i].value(forKey: "mood") as! Double)
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
        }
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
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd-MMM"

        return formatter.string(from: date)
    }

}
