import UIKit
import FirebaseDatabase
import FirebaseStorage

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextView!                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldTopConstraint: NSLayoutConstraint!
    
    var messages = [Message]()
    let ref = Database.database().reference()
    var storyID:String!
    var storyTitle:String!
    var currentInputType = "text"
    var nextInputType:String!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        buttonSend.backgroundColor = mainTextColor
        buttonSend.layer.cornerRadius = buttonSend.frame.height / 2
        
        let nibName1 = UINib(nibName: "ChatCell", bundle: nil)
        tableView.register(nibName1, forCellReuseIdentifier: "cell1")
        
        let nibName2 = UINib(nibName: "ChatPictureCell", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "cell2")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100;
        
        self.inputTextField.delegate = self
        self.title = storyTitle;
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "up"), style: .plain, target: self, action: #selector(upvote))
        cameraButton.contentMode = .center
        cameraButton.imageView?.contentMode = .scaleAspectFit
        cameraButton.imageView?.tintColor = UIColor.white
        cameraButton.backgroundColor = mainTextColor
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.isHidden = true
        
        ref.child("messages").child(storyID).observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                var name = value["name"] as? String ?? ""
                name = name.components(separatedBy: " ").first!
                let pictureURL = value["profileURL"] as? String ?? ""
                let message = value["message"] as? String ?? ""
                self.currentInputType = value["nextInputType"] as? String ?? ""
                let newMessage:Message!
                if let messagePictureURL = value["messagePictureURL"] as! String! {
                    newMessage = Message(userName: name, pictureURL: pictureURL, messagePictureURL: messagePictureURL)
                } else {
                    newMessage = Message(userName: name, pictureURL: pictureURL, message: message)
                }
                self.messages.append(newMessage)
                self.tableView.reloadData()
                self.scrollToBottom()
                self.showInputType()
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    @objc
    func upvote() {
        ref.child("stories").child(storyID).child("upvotes").runTransactionBlock { (upvotes) -> TransactionResult in
            if let totalVotes = upvotes.value as? Int {
                upvotes.value = totalVotes + 1
                
            }
            
            return TransactionResult.success(withValue: upvotes)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if (message.messagePictureURL != nil){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ChatPictureCell
            cell.setupViews(profileName: message.userName, profileImgURL: message.pictureURL, messageImgURL: message.messagePictureURL)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ChatCell
            cell.setupViews(name: message.userName, profileUrl: message.pictureURL, message: message.message, bgColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1))
            return cell
        }
    }

  
    
    @IBAction func sendAction(_ sender: Any) {
        if (inputTextField.text == ""){
            return
        }
        
        let uid = currentUserStoryline.uid
        let name = currentUserStoryline.name
        let profileURL = currentUserStoryline.imageUrl
        let message = inputTextField.text
        let storyID = self.storyID
        self.getNextInput()
        
        self.ref.child("messages").child(storyID!).childByAutoId().setValue(["uid": uid, "name": name, "profileURL": profileURL, "message": message, "storyID": storyID, "nextInputType":nextInputType])
        inputTextField.text = ""
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = UIImage(cgImage: (image?.cgImage!)!, scale: (image?.scale)!, orientation: .right)
        imagePicker.dismiss(animated: true, completion: nil)
        uploadMedia(image: image!) { (url) in
            if url != nil{
                let uid = currentUserStoryline.uid
                let name = currentUserStoryline.name
                let profileURL = currentUserStoryline.imageUrl
                let storyID = self.storyID
                
                self.ref.child("messages").child(storyID!).childByAutoId().setValue(["uid": uid, "name": name, "profileURL": profileURL, "message": nil, "storyID": storyID, "nextInputType":"text", "messagePictureURL":url])
            }
        }
        
    }
    
    func scrollToBottom(){
        if (messages.count < 1){
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.tableView.contentInset.bottom = 0
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textfieldBottomConstraint?.constant = 0.0
            } else {
                self.textfieldBottomConstraint?.constant = endFrame?.size.height ?? 0.0
                scrollToBottom()
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func getNextInput(){
        let percentage = Double(arc4random() % 1000) / 10.0;
        
        if (percentage >= 80){
            nextInputType = "camera"
        } else {
            nextInputType = "text"
        }
    }
    
    func showInputType(){
        if (currentInputType == "text"){
            self.inputTextField.isHidden = false
            self.buttonSend.isHidden = false
            self.cameraButton.isHidden = true
        } else {
            self.inputTextField.isHidden = true
            self.buttonSend.isHidden = true
            self.cameraButton.isHidden = false
            self.inputTextField.resignFirstResponder()
            self.resignFirstResponder()
        }
    }
    
    func uploadMedia(image:UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child(NSUUID().uuidString)
        if let uploadData = UIImageJPEGRepresentation(image, 0.025) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion(metadata?.downloadURL()?.absoluteString)
                    // your uploaded photo url.
                }
            })
        }
    }

    

}
