import UIKit
import FirebaseAuth
import FirebaseGoogleAuthUI
import FirebaseDatabase

class SignInVC: UIViewController, FUIAuthDelegate {

    
    let signInButton:UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = mainTextColor
        view.setTitle("Start Storytelling", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.addTarget(self, action: #selector(getIn), for: .touchUpInside)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()
    
    let appName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .white
        label.text = "StoryLine"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let logoImgView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logo")
        view.tintColor = mainColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let authUI = FUIAuth.defaultAuthUI()
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        logoImgView.tintColor = .white
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 48.0 / 255.0, green: 35.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0).cgColor,
            UIColor(red: 200.0 / 255.0, green: 109.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        
        view.layer.addSublayer(gradient)
        
        setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupViews(){
        self.view.addSubview(logoImgView)
        logoImgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImgView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        logoImgView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        logoImgView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(appName)
        appName.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 16).isActive = true
        appName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        

        
        self.view.addSubview(signInButton)
        signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64).isActive = true
        signInButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        signInButton.setNeedsLayout()
        signInButton.layoutIfNeeded()
        signInButton.layer.cornerRadius = signInButton.frame.height/2
    }
    
    @objc func getIn(){
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if (error != nil){
            print("cannot log in")
            return
        }
        
        guard let user = authDataResult?.user else {
            return
        }
        
        var uid = user.uid
        var storiesCount = 0
        var upVoteCount =  0
        var name = user.displayName!
        var photoURL = user.photoURL!.absoluteString
        
        let userID = user.uid
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary {
                uid = value["uid"] as? String ?? ""
                name = value["name"] as? String ?? ""
                photoURL = value["photoURL"] as? String ?? ""
                storiesCount = value["storiesCount"] as? Int ?? 0
                upVoteCount =  value["upVoteCount"] as? Int ?? 0
                currentUserStoryline = UserStoryline(uid: uid, imageUrl: photoURL, name: name, storiesCount: storiesCount, upVoteCount: upVoteCount)
            } else {
                self.ref.child("users").child(user.uid).setValue(["uid":uid, "name":name, "photoURL":photoURL, "storiesCount": storiesCount, "upVoteCount":upVoteCount])
                currentUserStoryline = UserStoryline(uid: uid, imageUrl: photoURL, name: name, storiesCount: storiesCount, upVoteCount: upVoteCount)
            }
            self.present(UINavigationController(rootViewController: StoriesVC()), animated: true, completion: nil)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

}
