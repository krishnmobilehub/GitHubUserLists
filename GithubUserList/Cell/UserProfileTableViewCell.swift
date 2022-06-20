//
//  UserProfileTableViewCell.swift
//  GithubUserList
//

import UIKit

class UserProfileTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = self.userAvatarImageView {
            self.userAvatarImageView.cornerViewWithShadow(isShadow: false, cornerRadius: 8.0)
        }
    }
    
    func setupCell(userDetail: UserDetail?) {
        if let userImageUrl = userDetail?.avatarURL, !userImageUrl.isEmpty {
            self.userAvatarImageView.downloaded(from: userImageUrl)
        } else {
            self.userAvatarImageView.image = UIImage(named: "userProfile")
        }
        if let followers = userDetail?.followers {
            self.followerLabel.text = "\(followers)\n Followers"
        } else {
            self.followerLabel.text = "No Followers"
        }
        
        if let following = userDetail?.following {
            self.followingLabel.text = "\(following)\n Following"
        } else {
            self.followingLabel.text = "No Following"
        }
    }
}
