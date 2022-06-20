//
//  GithubUserModel.swift
//  GithubUserList
//

import Foundation
import CoreData

class GithubUserModel: Codable {
    var userName: String?
    var userId: Int?
    var avatarURL: String?
    var userType: String?
    var siteAdmin: Bool?
    
    let entityName: String = Constants.CoreData.githubUser
    let managedContext = CoreDataManager.sharedInstance.getManagedContext()

    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case userId = "id"
        case avatarURL = "avatar_url"
        case userType = "type"
        case siteAdmin = "site_admin"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String?.self, forKey: .userName)
        userId = try container.decode(Int?.self, forKey: .userId)
        avatarURL = try container.decode(String?.self, forKey: .avatarURL)
        userType = try container.decode(String?.self, forKey: .userType)
        siteAdmin = try container.decode(Bool?.self, forKey: .siteAdmin)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(userId, forKey: .userId)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(userType, forKey: .userType)
        try container.encode(siteAdmin, forKey: .siteAdmin)
    }
    
    func saveObject() {
        if let savedObjects = CoreDataManager.sharedInstance.fetchWithPredicate(entityName: entityName as NSString, predicate: NSPredicate(format: "userId = \(self.userId ?? 0)")) as? [GithubUser], savedObjects.count > 0 {
             self.update(object: savedObjects[0])
         } else {
            CoreDataManager.sharedInstance.deleteWithPrediecate(entityName: entityName as NSString,
                                                                predicate: NSPredicate(format: "userId = \(self.userId ?? 0)"))
            insertNewObject()
         }

     }
    
    func insertNewObject() {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object: GithubUser = NSManagedObject(entity: entity, insertInto: managedContext) as! GithubUser

        self.update(object: object)
    }
    
    func update(object: GithubUser) {
        object.userId = Int64(self.userId ?? 0)
        object.userName = self.userName ?? ""
        object.avatarURL = self.avatarURL ?? ""
        object.userType = self.userType ?? ""
        object.siteAdmin = self.siteAdmin ?? false
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
