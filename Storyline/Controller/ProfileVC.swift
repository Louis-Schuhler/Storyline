import UIKit
import FirebaseDatabase
class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    var stories = [StoryModel]()
    var totalUpvotes: Int = 0 {
        didSet {
            ProfileUpvotes.text = "\(totalUpvotes)"
        }
    }

    
    @IBOutlet weak var storyTable: UICollectionView!
    @IBOutlet weak var ProfileStories: UITextField!
    @IBOutlet weak var ProfileUpvotes: UITextField!
    @IBOutlet weak var upImg: UIImageView!
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var ProfileName: UITextField!
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        if let layout = storyTable.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        self.ProfileImg.layer.cornerRadius = self.ProfileImg.frame.size.width/2;
        //self.ProfileImg.layer.shadowColor = #colorLiteral(red: 0.009499914944, green: 0.00950041879, blue: 0.009500147775, alpha: 1)
        //self.ProfileImg.layer.shadowRadius = 30
        self.ProfileImg.layer.borderWidth = 1.0;
        self.ProfileImg.layer.borderColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        self.ProfileImg.clipsToBounds = true
        setProfileImage(str: currentUserStoryline.imageUrl)
        
        self.ProfileName.text = currentUserStoryline.name
        self.ProfileName.borderStyle = UITextBorderStyle.none
        
        self.ProfileUpvotes.text = String(currentUserStoryline.upVoteCount)
        self.ProfileStories.text = String(currentUserStoryline.storiesCount)
        //self.upImg.image = UIImage(currentUserStoryline.imageUrl:currentUserStoryline.imageUrl)
        
        storyTable.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        storyTable.dataSource=self
        storyTable.delegate=self
        
        ref.child("stories").queryOrdered(byChild: "username").queryEqual(toValue: self.ProfileName.text).observe(.value) { (snapshot) in
            self.stories.removeAll()
            self.totalUpvotes = 0
            for child in snapshot.children.reversed() as! [DataSnapshot] {
                let value = child.value as? [String: Any] ?? [:]
                
                let uuid = child.key
                let name = value["name"] as? String ?? ""
                let userImage = self.getImage(str: value["userImage"] as? String ?? "") ?? UIImage(named: "profile")
                let userName = value["username"] as? String ?? ""
                let upvotes = value["upvotes"] as? Int ?? 0
                self.totalUpvotes += upvotes
                let storyStatus = value["isOpen"] as? Bool ?? true
                
                self.stories.append(StoryModel(uuid: uuid, name: name, userImage: userImage, userName: userName, storyStatus: storyStatus ? "Active" : "Closed", upvotes: upvotes))
                
                self.storyTable.reloadData()
                
            }
        }
    }
    
    func setProfileImage(str: String){
        
        if let imageUrl = URL(string: str) {
            let imagedata = try! Data(contentsOf: imageUrl)
            
            self.ProfileImg.image = UIImage(data: imagedata)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.ProfileStories.text = String(stories.count)
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCollectionViewCell
        let story = stories[indexPath.item]
        
        cell.storyTitle.text = story.name
        cell.personImageView.image = story.userImage
        cell.nameLabel.text = story.userName
        cell.storyTimeLabel.text = story.storyStatus
        cell.upvoteLabel.text = "\(story.upvotes)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width, height: view.frame.height * 0.2)

    }
    
    func getImage(str: String) -> UIImage? {
        
        if let imageUrl = URL(string: str) {
            let imagedata = try! Data(contentsOf: imageUrl)
            
            return UIImage(data: imagedata)
        }
        
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
