import Foundation
import UIKit

class Message{
    let userName:String!
    let pictureURL:String!
    let message:String!
    let bgColor:UIColor!
    let messagePictureURL:String!
    
    init(userName:String, pictureURL:String, message:String) {
        self.userName = userName
        self.pictureURL = pictureURL
        self.message = message
        self.bgColor = UIColor.random
        self.messagePictureURL = nil
    }
    
    init(userName:String, pictureURL:String, messagePictureURL:String) {
        self.userName = userName
        self.pictureURL = pictureURL
        self.message = nil
        self.messagePictureURL = messagePictureURL
        self.bgColor = UIColor.random
    }
}
