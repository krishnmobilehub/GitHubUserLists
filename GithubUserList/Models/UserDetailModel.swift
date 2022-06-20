//
//  UserDetailModel.swift
//  GithubUserList
//

import Foundation
import CoreData

class UserDetailModel: Codable {
    var userName: String?
    var userId: Int?
    var avatarURL: String?
    var githubURL: String?
    var userType: String?
    var siteAdmin: Bool?
    var name: String?
    var company: String?
    var blogURL: String?
    var location: String?
    var email: String?
    var twitterUsername: String?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var following: Int?
    
    let entityName: String = Constants.CoreData.userDetail
    let managedContext = CoreDataManager.sharedInstance.getManagedContext()

    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case userId = "id"
        case avatarURL = "avatar_url"
        case githubURL = "html_url"
        case userType = "type"
        case siteAdmin = "site_admin"
        case name = "name"
        case company = "company"
        case blogURL = "blog"
        case location = "location"
        case email = "email"
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers = "followers"
        case following = "following"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String?.self, forKey: .userName)
        userId = try container.decode(Int?.self, forKey: .userId)
        avatarURL = try container.decode(String?.self, forKey: .avatarURL)
        githubURL = try container.decode(String?.self, forKey: .githubURL)
        userType = try container.decode(String?.self, forKey: .userType)
        siteAdmin = try container.decode(Bool?.self, forKey: .siteAdmin)
        name = try container.decode(String?.self, forKey: .name)
        company = try container.decode(String?.self, forKey: .company)
        blogURL = try container.decode(String?.self, forKey: .blogURL)
        location = try container.decode(String?.self, forKey: .location)
        email = try container.decode(String?.self, forKey: .email)
        twitterUsername = try container.decode(String?.self, forKey: .twitterUsername)
        publicRepos = try container.decode(Int?.self, forKey: .publicRepos)
        publicGists = try container.decode(Int?.self, forKey: .publicGists)
        followers = try container.decode(Int?.self, forKey: .followers)
        following = try container.decode(Int?.self, forKey: .following)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(userId, forKey: .userId)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(githubURL, forKey: .githubURL)
        try container.encode(userType, forKey: .userType)
        try container.encode(siteAdmin, forKey: .siteAdmin)
        try container.encode(name, forKey: .name)
        try container.encode(company, forKey: .company)
        try container.encode(blogURL, forKey: .blogURL)
        try container.encode(location, forKey: .location)
        try container.encode(email, forKey: .email)
        try container.encode(twitterUsername, forKey: .twitterUsername)
        try container.encode(publicRepos, forKey: .publicRepos)
        try container.encode(publicGists, forKey: .publicGists)
        try container.encode(followers, forKey: .followers)
        try container.encode(following, forKey: .following)
    }
    
    func saveObject() {
        if let savedObjects = CoreDataManager.sharedInstance.fetchWithPredicate(entityName: entityName as NSString, predicate: NSPredicate(format: "userId = \(self.userId ?? 0)")) as? [UserDetail], savedObjects.count > 0 {
             self.update(object: savedObjects[0])
         } else {
            CoreDataManager.sharedInstance.deleteWithPrediecate(entityName: entityName as NSString,
                                                                predicate: NSPredicate(format: "userId = \(self.userId ?? 0)"))
            insertNewObject()
         }

     }
    
    func insertNewObject() {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object: UserDetail = NSManagedObject(entity: entity, insertInto: managedContext) as! UserDetail

        self.update(object: object)
    }
    
    func update(object: UserDetail) {
        object.userId = Int64(self.userId ?? 0)
        object.userName = self.userName ?? ""
        object.avatarURL = self.avatarURL ?? ""
        object.userType = self.userType ?? ""
        object.siteAdmin = self.siteAdmin ?? false
        object.blogURL = self.blogURL ?? ""
        object.company = self.company ?? ""
        object.email = self.email ?? ""
        object.followers = Int64(self.followers ?? 0)
        object.following = Int64(self.following ?? 0)
        object.githubURL = self.githubURL ?? ""
        object.location = self.location ?? ""
        object.name = self.name ?? ""
        object.publicGists = Int64(self.publicGists ?? 0)
        object.publicRepos = Int64(self.publicRepos ?? 0)
        object.twitterUsername = self.twitterUsername ?? ""
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
