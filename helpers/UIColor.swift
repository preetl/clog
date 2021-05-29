import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    struct ClogColors {
            static let MetalBlue = UIColor(netHex: 0x0C2A45)
            static let WarmBeige = UIColor(netHex: 0xFAF8F2)
            static let ActionPink = UIColor(netHex: 0xF71965)
            static let LessBlue = UIColor(netHex: 0x2166A5)
        }
}
