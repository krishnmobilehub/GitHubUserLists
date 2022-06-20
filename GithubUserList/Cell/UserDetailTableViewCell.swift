//
//  UserDetailTableViewCell.swift
//  GithubUserList
//

import UIKit

class UserDetailTableViewCell: UITableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var twitterUserNameLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var publicGistsLabel: UILabel!
    @IBOutlet weak var userNotesTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = self.userNotesTextView {
            self.userNotesTextView.cornerViewWithShadow(isShadow: false, cornerRadius: 10.0, borderColor: .gray)
        }
        // Initialization code
    }
    
    func setupCell(userDetail: UserDetail?) {
        if let email = userDetail?.email, !email.isEmpty {
            self.emailLabel.isHidden = false
            self.emailLabel.text = "Email: \(email)"
        } else {
            self.emailLabel.isHidden = true
        }
        
        if let name = userDetail?.name, !name.isEmpty {
            self.nameLabel.isHidden = false
            self.nameLabel.text = "Name: \(name)"
        } else {
            self.nameLabel.isHidden = true
        }
        
        if let company = userDetail?.company, !company.isEmpty {
            self.companyLabel.isHidden = false
            self.companyLabel.text = "Company: \(company)"
        } else {
            self.companyLabel.isHidden = true
        }
        
        if let blogURL = userDetail?.blogURL, !blogURL.isEmpty {
            self.blogLabel.isHidden = false
            self.blogLabel.text = "Blog: \(blogURL)"
        } else {
            self.blogLabel.isHidden = true
        }
        
        if let location = userDetail?.location, !location.isEmpty {
            self.locationLabel.isHidden = false
            self.locationLabel.text = "Location: \(location)"
        } else {
            self.locationLabel.isHidden = true
        }
        
        if let twitterUsername = userDetail?.twitterUsername, !twitterUsername.isEmpty {
            self.twitterUserNameLabel.isHidden = false
            self.twitterUserNameLabel.text = "Twitter: \(twitterUsername)"
        } else {
            self.twitterUserNameLabel.isHidden = true
        }
        
        if let publicRepos = userDetail?.publicRepos, publicRepos != 0 {
            self.publicReposLabel.isHidden = false
            self.publicReposLabel.text = "Public Repos: \(publicRepos)"
        } else {
            self.publicReposLabel.isHidden = true
        }
        
        if let publicGists = userDetail?.publicGists, publicGists != 0 {
            self.publicGistsLabel.isHidden = false
            self.publicGistsLabel.text = "Public Gists: \(publicGists)"
        } else {
            self.publicGistsLabel.isHidden = true
        }
        
        if let userNotes = userDetail?.userNotes, !userNotes.isEmpty {
            userNotesTextView.text = userNotes
        }
    }
}
