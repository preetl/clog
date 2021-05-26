import UIKit

class SetNotificationViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    func scheduleNotification(){
        
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minutes = components.minute!
        print(hour, minutes)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minutes
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // 2
        let content = UNMutableNotificationContent()
        content.title = "Please complete the daily questionnaire"
        content.body = "It's that time of day again!"

        let randomIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

        // 3
        UNUserNotificationCenter.current().add(request) { error in
          if error != nil {
            print("something went wrong")
          }
        }
    }
    
    @IBAction func nextButtonTapped(button: UIButton) {
        scheduleNotification()
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 10
    }
}
