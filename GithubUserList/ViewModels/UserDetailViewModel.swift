//
//  UserDetailViewModel.swift
//  GithubUserList
//

import Foundation
import Alamofire

protocol UserDetailDelegate: AnyObject {
    func getUserDetail()
    func showAlert(alertMessage: String)
}

class UserDetailViewModel {
    
    weak private var viewDelegate: UserDetailDelegate?
    var userDetail: UserDetail?

    init(viewDelegate: UserDetailDelegate) {
        self.viewDelegate = viewDelegate
            
        if !NetworkReachabilityManager()!.isReachable {
            print(Constants.Alert.noInternetMessage)
            self.viewDelegate?.showAlert(alertMessage: Constants.Alert.noInternetMessage)
        }
    }
}

extension UserDetailViewModel {
    
    func getGithubUsers(userName: String, userId: Int) {
        if !NetworkReachabilityManager()!.isReachable {
            self.viewDelegate?.showAlert(alertMessage: Constants.Alert.noInternetMessage)
            self.fetchLocalData(userId: userId)
            return
        }
        
        NetworkManager.makeRequest(HttpRouter.getUserDetail(userName: userName), mode: UserDetailModel?.self) { (result) in
            switch result {
            case .success(let responseData):
                responseData?.saveObject()
                self.fetchLocalData(userId: userId)
            case .failure(let errorMessage):
                print(errorMessage.errorTypes.1 ?? "")
                self.viewDelegate?.showAlert(alertMessage: errorMessage.errorTypes.1 ?? "")
            }
        }
    }
    
    func fetchLocalData(userId: Int) {
        if let userDetail = CoreDataManager.sharedInstance.fetchWithPredicate(entityName: Constants.CoreData.userDetail as NSString, predicate: NSPredicate(format: "userId = \(userId)")) as? [UserDetail], userDetail.count > 0 {
            self.userDetail = userDetail.first
            self.viewDelegate?.getUserDetail()
        }
    }
}
