import Foundation
import UIKit

extension UIFont {
    class func appRegularFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "Montserrat-Regular", size: size)!
    }
    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "Montserrat-Bold", size: size)!
    }
}
