import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    var imageHeightConstraint: NSLayoutConstraint!
    
    let storyTitle: UILabel = {
        let st = UILabel()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.text = "Walking in the Forest"
        st.numberOfLines = 1
        st.lineBreakMode = .byTruncatingTail
        st.clipsToBounds = true
        st.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        st.textColor = mainTextColor
        
        return st
    }()
    
    let personImageView: UIImageView = {
        let piv = UIImageView()
        piv.image = UIImage(named: "me")
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.layer.masksToBounds = true
        piv.clipsToBounds = true
        
        return piv
    }()
    
    let nameLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.text = "Anthony Fiorito"
        nl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nl.textColor = secondaryTextColor
        return nl
    }()
    
    let storyTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Active"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upvoteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "up")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let upvoteLabel: UILabel = {
        let label = UILabel()
        label.text = "556"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 0.5
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        personImageView.layer.cornerRadius = personImageView.frame.width / 2
        imageHeightConstraint.constant = upvoteLabel.frame.height - 2
    }
    
    fileprivate func setupSubviews() {
        contentView.addSubview(storyTitle)
        contentView.addSubview(nameLabel)
        contentView.addSubview(personImageView)
        contentView.addSubview(storyTimeLabel)
        contentView.addSubview(upvoteImage)
        contentView.addSubview(upvoteLabel)
        
        storyTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        storyTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        storyTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        personImageView.leftAnchor.constraint(equalTo: storyTitle.leftAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: storyTitle.bottomAnchor, constant: 8).isActive = true
        personImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor, constant: 0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: personImageView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: personImageView.rightAnchor, constant: 8).isActive = true
        imageHeightConstraint = upvoteImage.heightAnchor.constraint(equalToConstant: 30)
        imageHeightConstraint.isActive = true
        upvoteImage.widthAnchor.constraint(equalTo: upvoteImage.heightAnchor, constant: 0).isActive = true
        upvoteImage.leftAnchor.constraint(equalTo: storyTimeLabel.rightAnchor, constant: 8).isActive = true
        upvoteImage.centerYAnchor.constraint(equalTo: storyTimeLabel.centerYAnchor).isActive = true
        upvoteLabel.leftAnchor.constraint(equalTo: upvoteImage.rightAnchor, constant: 2).isActive = true
        upvoteLabel.centerYAnchor.constraint(equalTo: upvoteImage.centerYAnchor, constant: 0).isActive = true
        storyTimeLabel.leftAnchor.constraint(equalTo: storyTitle.leftAnchor).isActive = true
        storyTimeLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8).isActive = true
        
    }
}
