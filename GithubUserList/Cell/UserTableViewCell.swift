//
//  UserTableViewCell.swift
//  GithubUserList
//

import UIKit
import CoreData

class UserTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var userNoteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = self.userAvatarImageView {
            self.cellContentView.cornerViewWithShadow(cornerRadius: 5.0, borderColor: .lightGray, shadowColor: .lightGray)
            self.userAvatarImageView.cornerViewWithShadow(isShadow: false, cornerRadius: self.userAvatarImageView.frame.height / 2.0, borderColor: .lightGray)
        }
    }
    
    func setupCell(user: GithubUser?) {
        if let userImageUrl = user?.avatarURL, !userImageUrl.isEmpty {
            self.userAvatarImageView.downloaded(from: userImageUrl)
        } else {
            self.userAvatarImageView.image = UIImage(named: "userProfile")
        }
        self.userNameLabel.text = user?.userName ?? ""
        self.userTypeLabel.text = user?.userType ?? ""
        self.userNoteImageView.image = UIImage(named: "notes")
        self.userNoteImageView.isHidden = !(user?.noteAdded ?? false)
    }
}
