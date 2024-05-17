import UIKit
import Foundation
import FirebaseDatabase

struct StoryModel {
    let uuid: String
    let name: String
    let userImage: UIImage?
    let userName: String
    let storyStatus: String
    let upvotes: Int
}

class StoriesVC: UIViewController, GotoStoryDelegate {
    
    var stories = [StoryModel]()
    
    fileprivate let storyCellIdentifier = "storyCell"
    var addStoryButton: UIBarButtonItem!
    var profileButton: UIBarButtonItem!
    fileprivate let storiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let scv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        scv.translatesAutoresizingMaskIntoConstraints = false
        scv.backgroundColor = .white
        return scv
    }()
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 200.0 / 255.0, green: 109.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        title = "Stories"
        ref.child("stories").queryOrdered(byChild: "upvotes").observe(.value) { [unowned self] (snapshot) in
            self.stories.removeAll()
            for child in snapshot.children.reversed() as! [DataSnapshot] {
                let value = child.value as? [String: Any] ?? [:]
                
                let uuid = child.key
                let name = value["name"] as? String ?? ""
                let userImage = self.getImage(str: value["userImage"] as? String ?? "") ?? UIImage(named: "profile")
                let userName = value["username"] as? String ?? ""
                let upvotes = value["upvotes"] as? Int ?? 0
                let storyStatus = value["isOpen"] as? Bool ?? true
                
                self.stories.append(StoryModel(uuid: uuid, name: name, userImage: userImage, userName: userName, storyStatus: storyStatus ? "Active" : "Closed", upvotes: upvotes))
                
                self.storiesCollectionView.reloadData()
                print(self.stories)
            }
        }
        
        profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(goToProfile))
        addStoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStory))
        
        
        navigationItem.leftBarButtonItem = profileButton
        navigationItem.rightBarButtonItem = addStoryButton
        
        storiesCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: storyCellIdentifier)
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        let layout = view.safeAreaLayoutGuide
        view.addSubview(storiesCollectionView)
        storiesCollectionView.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        storiesCollectionView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        storiesCollectionView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        storiesCollectionView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
    }
    
    
    @objc
    func addStory(){
        let vc = AddStoryVC()
        vc.storyDelegate = self
        navigationController?.present(vc, animated: true)
    }
    
    func goToStory(uid:String, title:String) {
        let cvc = ChatVC()
        cvc.storyID = uid;
        cvc.storyTitle = title
        navigationController?.pushViewController(cvc, animated: true)
    }
    
    @objc
    func goToProfile(){
        navigationController?.pushViewController(ProfileVC(), animated: true)
    }
    
    func getImage(str: String) -> UIImage? {
        
        if let imageUrl = URL(string: str) {
            let imagedata = try! Data(contentsOf: imageUrl)
            
            return UIImage(data: imagedata)
        }
        
        return nil
    }

}

extension StoriesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellIdentifier, for: indexPath) as! StoryCollectionViewCell
        let story = stories[indexPath.item]
        
        cell.storyTitle.text = story.name
        cell.personImageView.image = story.userImage
        cell.nameLabel.text = story.userName
        cell.storyTimeLabel.text = story.storyStatus
        cell.upvoteLabel.text = "\(story.upvotes)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        let storyId = story.uuid
        let title = story.name
        let chatVC = ChatVC()
        chatVC.storyID = storyId
        chatVC.storyTitle = title
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    
}

extension StoriesVC: UICollectionViewDelegate {
    
}

extension StoriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.2)
    }
}
