import UIKit
import CoreData

class StartViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !UserDefaults.standard.bool(forKey: "SEEN-ONBOARDING") {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        print("toOnboarding")
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "onboardingVC")
        nextVC.modalPresentationStyle = .fullScreen
        show(nextVC, sender: self)
        } else {
            print("toHome")
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "tabVC")
            nextVC.modalPresentationStyle = .fullScreen
            show(nextVC, sender: self)
        }
    }
}
