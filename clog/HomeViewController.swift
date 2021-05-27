import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    var people: [NSManagedObject] = []
    
    @IBOutlet weak var surveyButton: UIButton!
    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.numberOfLines = 5
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        
        var text = ""
        var subtext = ""
        surveyButton.layer.cornerRadius = 10
        
        let surveyResults = fetchRecordsForEntity("Survey")
        let dateCompleted = surveyResults.last?.value(forKey: "date")
        
        if surveyResults.count > 0 && Calendar.current.isDateInToday(dateCompleted as! Date){
            text = "woohoo!!!"
            subtext = "You've already completed the questionnaire today! Thank you! Check here tomorrow."
            surveyButton.isHidden = true
        }else{
            text = "please complete the questionnaire this evening!"
            subtext = "There are 7 questions and it shouldn't take more than 2 minutes to complete"
            surveyButton.isHidden = false
        }
                
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
        
        attributedText.append(NSAttributedString(string: "\n\n\(subtext)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 14), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))
        
        labelTitle.attributedText = attributedText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? QuizViewController {
            nextVC.container = container
        }
    }
    
    @IBAction func surveyTapped(_ sender: Any) {
//        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
//        taskViewController.delegate = self
//        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}
    
}

//extension HomeViewController : ORKTaskViewControllerDelegate {
//    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//
//        let taskResult = taskViewController.result
//
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//            return
//          }
//
//          let managedContext =
//            appDelegate.persistentContainer.viewContext
//          let entity =
//            NSEntityDescription.entity(forEntityName: "Questionnaire",
//                                       in: managedContext)!
//          let questionnaire = NSManagedObject(entity: entity,
//                                       insertInto: managedContext)
//
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "sleepQuestion")?.results?.first!) as! ORKTimeIntervalQuestionResult).intervalAnswer, forKeyPath: "sleep")
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "sleepQualityQuestion")?.results?.first!) as! ORKScaleQuestionResult).scaleAnswer, forKeyPath: "sleepQuality")
////       questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "phoneBedQuestion")?.results?.first!) as! ORKTimeIntervalQuestionResult).intervalAnswer, forKeyPath: "phoneBed")
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "worryQuestion")?.results?.first!) as! ORKBooleanQuestionResult).booleanAnswer, forKeyPath: "worry")
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "anxietyQuestion")?.results?.first!) as! ORKBooleanQuestionResult).booleanAnswer, forKeyPath: "anxiety")
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "downQuestion")?.results?.first!) as! ORKBooleanQuestionResult).booleanAnswer, forKeyPath: "down")
//        questionnaire.setValue(((taskResult.stepResult(forStepIdentifier: "interestQuestion")?.results?.first!) as! ORKBooleanQuestionResult).booleanAnswer , forKeyPath: "interest")
//
//          do {
//            try managedContext.save()
//            people.append(questionnaire)
//          } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//          }
//
//        // Then, dismiss the task view controller.
//        dismiss(animated: true, completion: nil)
//    }
//
//}
  
