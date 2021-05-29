import UIKit
import Firebase
import CoreData
import HealthKit

class DataUploadViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    var container: NSPersistentContainer!
    var surveyResults: [NSManagedObject] = []
    var activations: [NSManagedObject] = []
    var id = ""
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var icon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.string(forKey: "RANDOM-UNIQUE-ID") == nil) {
            id = randomString(length: 5)
            UserDefaults.standard.set(id, forKey: "RANDOM-UNIQUE-ID")
        }else{
            id = UserDefaults.standard.string(forKey: "RANDOM-UNIQUE-ID")!
        }
        
        print("id", id)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        // Do any additional setup after loading the view.
        let heading = "share your data anonymously"
        let subHeading = "Your data has been stored locally until now but clog. would like to collect it for research purposes. Your data will be stored against a randomly generated ID and will not be personally identifiable. \n\n Please make sure you have a stable internet connection before pressing the button below."
        setLabelText(heading: heading, subHeading: subHeading)
        
        uploadButton.layer.cornerRadius = 10
        loading.isHidden = true

    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        
        surveyResults = fetchRecordsForEntity("Survey")
        activations = fetchRecordsForEntity("Activation")
        
        print("found", surveyResults.count)
        print(surveyResults.first)
        print(surveyResults.last)
        
        print("found", activations.count)
        print(activations.first)
        print(activations.last)
        
        if !(surveyResults.count<1){
            
            loading.isHidden = false
            loading.startAnimating()
            uploadButton.isHidden = true
            
            let db = Firestore.firestore()
            
            var success = true
            
            for i in 0..<surveyResults.count {
                let date = surveyResults[i].value(forKey: "date") as! Date
                var data = formatSurvey(entry: surveyResults[i])
                var stepCount = 0.0
                getSteps(day: date) { (result) in
                    DispatchQueue.main.async {
                        stepCount = result
                    }
                }
                data["stepCount"] = stepCount
                print("STEPCOUNT", stepCount)
                print("firebase data",data)
                db.collection("surveydata").document("users").collection(id).document(String(i)).setData(data) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        success = success && false
                    } else {
                        print("Document successfully written!")
                        success = success && true
                    }
                }
            }
            
            for i in 0..<activations.count {
                db.collection("usagedata").document("users").collection(id).document(String(i)).setData(formatActivation(entry: activations[i])) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        success = success && false
                    } else {
                        print("Document successfully written!")
                        success = success && true
                    }
                }
            }
            
            loading.stopAnimating()
            loading.isHidden = true
            
            if success {
                setLabelText(heading: "success!", subHeading: "Thank you for uploading your data and participating in this study!")
                icon.image = UIImage(systemName:"checkmark.circle")
                icon.tintColor = UIColor.ClogColors.ActionPink
                
            } else {
                setLabelText(heading: "oh no!", subHeading: "It looks like something went wrong on our end, please try again later! Please make sure you have a stable internet connection.")
                uploadButton.isHidden = false
                icon.image = UIImage(systemName:"xmark")
                icon.tintColor = UIColor.ClogColors.ActionPink
                
            }
            
        } else {
            setLabelText(heading: "oops!", subHeading: "It looks like you haven't reached the end of the study yet!")
        }
        

    }
    
    func setLabelText(heading: String, subHeading: String){
        let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24
        ), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])

        attributedText.append(NSAttributedString(string: "\n\n\(subHeading)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))

        infoLabel.attributedText = attributedText
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
    
    func formatSurvey(entry: NSManagedObject) -> [String: Any] {
        let data: [String: Any] = [
            "date": entry.value(forKey: "date") as! Date,
            "sleep": (entry.value(forKey: "sleep") as! Int16)/60,
            "sleepQuality": entry.value(forKey: "sleepQuality") as! Int16,
            "phoneBed": (entry.value(forKey: "phoneBed") as! Int16)/60,
            "mood": entry.value(forKey: "mood") as! Int16,
            "interest": entry.value(forKey: "interest") as! Bool,
            "worry": entry.value(forKey: "worry") as! Bool,
            "down": entry.value(forKey: "down") as! Bool,
            "anxiety": entry.value(forKey: "anxiety") as! Bool
        ]
        return data
    }
    
    func formatActivation(entry: NSManagedObject) -> [String: Any] {
        let data: [String: Any] = [
            "date": entry.value(forKey: "date") as! Date,
            "push": entry.value(forKey: "push") as! Bool
        ]
        return data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
