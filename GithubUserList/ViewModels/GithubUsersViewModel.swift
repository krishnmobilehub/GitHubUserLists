//
//  GithubUsersViewModel.swift
//  GithubUserList
//

import Foundation
import Alamofire

protocol GithubUsersDelegate: AnyObject {
    func getUserList()
    func showAlert(alertMessage: String)
}

class GithubUsersViewModel {
    
    var nextPage: Int? = 0
    weak private var viewDelegate: GithubUsersDelegate?
    var githubUsers: [GithubUser] = [GithubUser]()

    init(viewDelegate: GithubUsersDelegate) {
        self.viewDelegate = viewDelegate
            
        if NetworkReachabilityManager()!.isReachable == true {
            if self.nextPage != nil {
                self.getGithubUsers(nextPage: self.nextPage!)
            }
        } else {
            print(Constants.Alert.noInternetMessage)
            self.fetchLocalData()
            self.viewDelegate?.showAlert(alertMessage: Constants.Alert.noInternetMessage)
        }
    }
}

extension GithubUsersViewModel {
    
    func getGithubUsers(nextPage: Int = 0) {
        if !NetworkReachabilityManager()!.isReachable {
            self.viewDelegate?.showAlert(alertMessage: Constants.Alert.noInternetMessage)
            self.fetchLocalData()
            return
        }
        
        print("nextpage \(self.nextPage ?? 0)")
        NetworkManager.makeRequest(HttpRouter.getUserList(page: self.nextPage ?? 0), mode: [GithubUserModel].self) { (result) in
            switch result {
            case .success(let responseData):
                if responseData.count > 0 {
                    for object in responseData {
                        object.saveObject()
                    }
                    self.fetchLocalData()
                }
            case .failure(let errorMessage):
                print(errorMessage.errorTypes.1 ?? "")
                self.viewDelegate?.showAlert(alertMessage: errorMessage.errorTypes.1 ?? "")
            }
        }
    }
    
    func fetchLocalData(isDelegate: Bool = true) {
        if let savedObjects = CoreDataManager.sharedInstance.fetch(entityName: Constants.CoreData.githubUser as NSString) as? [GithubUser], savedObjects.count > 0  {
            self.githubUsers = savedObjects
            if isDelegate {
                self.nextPage = Int(self.githubUsers.last?.userId ?? 0)
                self.viewDelegate?.getUserList()
            }
        }
    }
}
