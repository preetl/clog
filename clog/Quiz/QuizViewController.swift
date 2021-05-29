import UIKit
import CoreData

class QuizViewController: UIViewController {
    
    var container: NSPersistentContainer!

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var quizPageViewController: QuizPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10
        nextButton.isHidden = true
        pageControl.pageIndicatorTintColor = UIColor.ClogColors.MetalBlue.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.ClogColors.MetalBlue
        cancelButton.tintColor = UIColor.ClogColors.MetalBlue
        // Do any additional setup after loading the view.
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}
    
    @IBAction func nextButtonTapped(button: UIButton) {
        print("Submitted!!!")

        let entity =
            NSEntityDescription.entity(forEntityName: "Survey", in: container.viewContext)!
        let questionnaire = NSManagedObject(entity: entity, insertInto: container.viewContext)

        let date = NSDate()
        questionnaire.setValue(date, forKeyPath: "date")
        questionnaire.setValue(quizPageViewController?.views[0].numResult, forKeyPath: "sleep")
        questionnaire.setValue(quizPageViewController?.views[1].numResult, forKeyPath: "phoneBed")
        questionnaire.setValue(quizPageViewController?.views[2].numResult, forKeyPath: "sleepQuality")
        questionnaire.setValue(quizPageViewController?.views[3].boolResult, forKeyPath: "down")
        questionnaire.setValue(quizPageViewController?.views[4].boolResult, forKeyPath: "interest")
        questionnaire.setValue(quizPageViewController?.views[5].boolResult, forKeyPath: "worry")
        questionnaire.setValue(quizPageViewController?.views[6].boolResult, forKeyPath: "anxiety")
        
        var moodScore = 0
        for i in 0..<4{
            let result = (quizPageViewController?.views[i+3].boolResult)! ? 1 : 0
            moodScore += result
        }
        
        questionnaire.setValue(4-moodScore, forKeyPath: "mood")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()

        for i in 0..<(quizPageViewController?.views.count)!{
            print(quizPageViewController?.views[i].numResult)
        }
        UserDefaults.standard.set(true, forKey: "SURVEY-COMPLETED")
        self.performSegue(withIdentifier: "endQuiz", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quizViewController = segue.destination as? QuizPageViewController {
            quizViewController.pageViewControllerDelagate = self
            quizPageViewController = quizViewController
        }
    }
}

extension QuizViewController: quizPageViewControllerDelegate {

    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }

    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        if index == 6 {
            nextButton.isHidden = false
            nextButton.backgroundColor = UIColor.ClogColors.ActionPink
        }
    }
}
