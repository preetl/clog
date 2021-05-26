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
        timePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        timePicker.minuteInterval = 5
        timePicker.countDownDuration = 10
        timePicker.setValue(UIColor.ClogColors.MetalBlue, forKeyPath: "textColor")
    }
    
    func loadQuestion(){
        
        questionTitle.attributedText = NSMutableAttributedString(string: question, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
        
        questionTitle.textAlignment = .center
    }

}
