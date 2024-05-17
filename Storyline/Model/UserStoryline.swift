
import Foundation

class UserStoryline{
    let uid:String!
    let imageUrl:String!
    let name:String!
    let storiesCount:Int!
    let upVoteCount:Int!
    
    init(uid:String, imageUrl:String, name:String, storiesCount:Int, upVoteCount:Int) {
        self.uid = uid
        self.imageUrl = imageUrl
        self.name = name
        self.storiesCount = storiesCount
        self.upVoteCount = upVoteCount
    }
}
