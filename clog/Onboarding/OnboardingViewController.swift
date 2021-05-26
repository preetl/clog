import UIKit
import UserNotifications

class OnboardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var onBoardingPageViewController: OnboardingPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.pageIndicatorTintColor = UIColor.ClogColors.MetalBlue.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.ClogColors.MetalBlue
        nextButton.layer.cornerRadius = 10
        nextButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingViewController = segue.destination as? OnboardingPageViewController {
            onBoardingViewController.pageViewControllerDelagate = self
            onBoardingPageViewController = onBoardingViewController
        }
    }
}

extension OnboardingViewController: onboardingPageViewControllerDelegate {

    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }

    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        if pageControl.currentPage == 3 {
            nextButton.isHidden = false
        }
    }
}
