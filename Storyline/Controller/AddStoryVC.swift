import UIKit
import FirebaseDatabase

protocol GotoStoryDelegate {
    func goToStory(uid:String, title:String)
}

class AddStoryVC: UIViewController {
    
    var storyDelegate: GotoStoryDelegate?
    @IBOutlet weak var nameText: UITextField!
    
    let top = CALayer()
    let bottom = CALayer()
    
    @IBOutlet weak var newStoryImage: UIImageView!
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        newStoryImage.tintColor = mainTextColor
        
//        let top = CALayer()
        top.backgroundColor = secondaryTextColor.cgColor
        
        top.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 1.0)
        self.nameText.layer.addSublayer(top)
        
//        let bottom = CALayer()
        bottom.backgroundColor = secondaryTextColor.cgColor
        bottom.frame = CGRect(x: 0.0, y: self.nameText.frame.height - 1, width: self.view.frame.width, height: 1.0)
        self.nameText.layer.addSublayer(bottom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        top.frame = CGRect(x: 0.0, y: 0.0, width: self.nameText.frame.width, height: 1.0)
        bottom.frame = CGRect(x: 0.0, y: self.nameText.frame.height - 1, width: self.nameText.frame.width, height: 1.0)
    }
    
    @IBAction func addStory(_ sender: Any) {
        let uuid = UUID().uuidString
        ref.child("stories").child(uuid).setValue([
            "name": nameText.text ?? "",
            "uuid": uuid,
            "userid": currentUserStoryline.uid,
            "username": currentUserStoryline.name,
            "userImage": currentUserStoryline.imageUrl,
            "upvotes": 0,
            "isOpen":true
            ])
        let chatVC = ChatVC()
        chatVC.storyID = uuid
        
        self.dismiss(animated: true) {
            self.storyDelegate?.goToStory(uid:uuid,title: self.nameText.text!)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.resignFirstResponder()
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

extension AddStoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
