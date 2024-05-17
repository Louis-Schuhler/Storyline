import Foundation
import UIKit

let mainColor = UIColor(red: 95/255.0, green: 225/255.0, blue: 200/255.0, alpha: 1.0)
let mainTextColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0)
let secondaryTextColor = UIColor(hue: 0, saturation: 0, brightness: 0.4, alpha: 1.0)
var currentUserStoryline:UserStoryline!

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
