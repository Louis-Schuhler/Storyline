import UIKit
import SDWebImage

class ChatCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Code d'initialisation
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configurez la vue pour l'état sélectionné
    }
    
    func setupViews(name: String, profileUrl: String, message: String, bgColor: UIColor) {
        self.profileNameLabel.text = name
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.sd_setImage(with: URL(string: profileUrl), completed: nil)
        messageLabel.text = message
        container.layer.cornerRadius = container.frame.height / 10
        container.backgroundColor = bgColor
    }
}
