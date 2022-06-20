//
//  Constant.swift
//  GithubUserList
//

import Foundation

struct Constants {
    struct Server {
        static let baseURL = "https://api.github.com/"
    }
    
    struct Message {
        static let failureReason = "There was an error creating or loading the application's saved data."
        static let dictSavedFailed = "Failed to initialize the application's saved data"
        static let couldFetch = "Could not fetch."
        static let unresolvedError = "Unresolved error"
    }
    
    struct Alert {
        static let title = "Github User List"
        static let noInternetTitle = "No Internet Connection"
        static let noInternetMessage = "Please make sure that Internet is turned on, then try again."
        static let genericMessage = "Something went wrong. Please try again."
        static let ok = "Ok"
    }
    
    struct CoreData {
        static let dbName = "GithubUserList"
        static let githubUser = "GithubUser"
        static let userDetail = "UserDetail"
    }
}
