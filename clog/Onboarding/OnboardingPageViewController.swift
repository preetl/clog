import UIKit

protocol onboardingPageViewControllerDelegate: class {
    func setupPageController(numberOfPage: Int)
    func turnPageController(to index: Int)
}

class OnboardingPageViewController: UIPageViewController {

    weak var pageViewControllerDelagate: onboardingPageViewControllerDelegate?

    var pageTitle = ["welcome!", "check-in daily", "easy tracking", "private and secure"]
    var pageImages: [UIImage] = [UIImage(named:"clogfunky")!, UIImage(named:"dailycheckin")!, UIImage(named:"dailycheckin")!, UIImage(named:"privsecure")!]
    var pageDescriptionText = ["clog. will run in the background to log your mood and activity to help you know yourself better", "Help us, help you by completing the daily questionnaire at the end of everyday. We'll send you a notification to remind you", "simply go about your day as normal and check clog. when you want an update", "clog. will only collect data through phone sensors and screen on/off activities and store it locally. Your camera and microphone will not be monitored"]
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let firstViewController = contentViewController(at: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? OnboardingContentViewController)?.index {
            index -= 1
            return contentViewController(at: index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? OnboardingContentViewController)?.index {
            index += 1
            return contentViewController(at: index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let pageContentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
            currentIndex = pageContentViewController.index
            self.pageViewControllerDelagate?.turnPageController(to: currentIndex)
        }
    }
    
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= pageTitle.count {
            return nil
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "onboardingContentVC") as? OnboardingContentViewController {
            pageContentViewController.subHeading = pageDescriptionText[index]
            pageContentViewController.heading = pageTitle[index]
            pageContentViewController.image = pageImages[index]
            pageContentViewController.index = index
            self.pageViewControllerDelagate?.setupPageController(numberOfPage: 4)
            return pageContentViewController
        }
        return nil
    }
}
