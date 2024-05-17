import UIKit
import SDWebImage

class ChatPictureCell: UITableViewCell {
    @IBOutlet weak var profilePictureImgView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var messagePictureImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Code d'initialisation
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configurez la vue pour l'état sélectionné
    }
    
    func setupViews(profileName: String, profileImgURL: String, messageImgURL: String) {
        profileNameLabel.text = profileName
        profilePictureImgView.layer.cornerRadius = profilePictureImgView.frame.height / 2
        profilePictureImgView.sd_setImage(with: URL(string: profileImgURL), completed: nil)
        messagePictureImgView.sd_setImage(with: URL(string: messageImgURL), completed: nil)
    }
}
