import UIKit

class TimeQuestionViewController: QuizContentViewController {

    @IBOutlet weak var questionTitle: UILabel!{
        didSet {
            questionTitle.numberOfLines = 3
        }
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func doSomething(sender: UIDatePicker){
        numResult = Int(timePicker.countDownDuration)
        print(numResult)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
        view.backgroundColor = UIColor.ClogColors.WarmBeige
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        numResult = (hour*60 + minute) * 60
        timePicker.setDate(date as Date, animated: true)
        timePicker.tintColor = UIColor.ClogColors.MetalBlue
        timePicker.setValue(UIColor.ClogColors.MetalBlue, forKeyPath: "textColor")
    }
    
    func loadQuestion(){
        
        questionTitle.attributedText = NSMutableAttributedString(string: question, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
        
        questionTitle.textAlignment = .center
    }

}
