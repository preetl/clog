import UIKit

protocol quizPageViewControllerDelegate: class {
    func setupPageController(numberOfPage: Int)
    func turnPageController(to index: Int)
}

class QuizPageViewController: UIPageViewController {

    weak var pageViewControllerDelagate: quizPageViewControllerDelegate?
    
    struct Question {
        let question: String
        let id: String
        let type: String
    }
    
    var views: [QuizContentViewController] = []
    
    var questions: [Question] = [
        Question(question: "How long did you sleep last night?", id: "sleep", type: "time"),
        Question(question: "How long did you use your phone in bed last night?", id: "phoneBed", type: "time"),
        Question(question: "How would you rate last night's sleep?", id: "sleepQuality", type: "scale"),
        Question(question: "Have you felt down or hopeless today?", id: "down", type: "bool"),
        Question(question: "Have you felt little interest or pleasure in doing things today?", id: "interest", type: "bool"),
        Question(question: "Have you felt unable to stop or control worrying today?", id: "worry", type: "bool"),
        Question(question: "Have you felt nervous, anxious or on edge today?", id: "anxiety", type: "bool")]
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        for i in 0..<questions.count{
            if let view = contentViewController(at: i){
                views.append(view)
            }
        }
        setViewControllers([views[0]], direction: .forward, animated: true, completion: nil)
    }

}

extension QuizPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? QuizContentViewController)?.index {
            index -= 1
            currentIndex -= 1
            if index < 0 || index >= questions.count {
                return nil
            }
            return views[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? QuizContentViewController)?.index {
            index += 1
            currentIndex += 1
            if index < 0 || index >= questions.count {
                return nil
            }
            return views[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let pageContentViewController = pageViewController.viewControllers?.first as? QuizContentViewController {
            currentIndex = pageContentViewController.index
            self.pageViewControllerDelagate?.turnPageController(to: currentIndex)
        }
    }
    
    func contentViewController(at index: Int) -> QuizContentViewController? {
        if index < 0 || index >= questions.count {
            return nil
        }
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        if questions[index].type == "time" {
            if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "timeVC") as? TimeQuestionViewController {
                pageContentViewController.question = questions[index].question
                pageContentViewController.index = index
                self.pageViewControllerDelagate?.setupPageController(numberOfPage: 7)
                return pageContentViewController
            }
        }
        if questions[index].type == "bool"{
            if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "boolVC") as? BoolQuestionViewController {
                pageContentViewController.question = questions[index].question
                pageContentViewController.index = index
                self.pageViewControllerDelagate?.setupPageController(numberOfPage: 7)
                return pageContentViewController
            }
        }
        if questions[index].type == "scale" {
            if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "scaleVC") as? ScaleQuestionViewController {
                pageContentViewController.question = questions[index].question
                pageContentViewController.index = index
                self.pageViewControllerDelagate?.setupPageController(numberOfPage: 7)
                return pageContentViewController
            }
        }
        return nil
    }
}
