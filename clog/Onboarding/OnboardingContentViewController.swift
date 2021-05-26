import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var image = UIImage()
    var bgColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLabel()
        contentImageView.image = image
        view.backgroundColor = UIColor.ClogColors.WarmBeige
    }
    
    func setupTextLabel() {
        let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.appBoldFontWith(size: 36), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue])

        attributedText.append(NSAttributedString(string: "\n\n\(subHeading)", attributes: [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 14), NSAttributedString.Key.foregroundColor: UIColor.ClogColors.MetalBlue]))

        titleLabel.attributedText = attributedText
        titleLabel.textAlignment = .center
    }
}
