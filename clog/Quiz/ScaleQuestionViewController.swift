import UIKit

class ScaleQuestionViewController: QuizContentViewController {

    @IBOutlet weak var questionTitle: UILabel!{
        didSet {
            questionTitle.numberOfLines = 3
        }
    }
    @IBOutlet weak var scale: UISlider!
    
    @IBAction func doSomething(sender: UISlider){
        numResult = Int(scale.value)
        print(numResult)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
        view.backgroundColor = UIColor.ClogColors.WarmBeige
    }
    
    func loadQuestion(){
        
        questionTitle.attributedText = NSMutableAttributedString(string: question, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 24), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])
        
        questionTitle.textAlignment = .center
    }

}
