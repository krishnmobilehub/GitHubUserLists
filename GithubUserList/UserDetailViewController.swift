//
//  UserDetailViewController.swift
//  GithubUserList
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userDetailTableView: UITableView!
    
    var userName: String = ""
    var userId: Int = 0
    lazy var viewModel = UserDetailViewModel(viewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.title = self.userName
        self.userDetailTableView.registerCell(UserProfileTableViewCell.self)
        self.userDetailTableView.registerCell(UserDetailTableViewCell.self)
        self.viewModel.getGithubUsers(userName: userName, userId: userId)
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveClicked))

        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveClicked() {
        let cell = self.userDetailTableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? UserDetailTableViewCell
        let userNotes = cell?.userNotesTextView.text
        self.viewModel.userDetail?.userNotes = userNotes
        
        if let savedObjects = CoreDataManager.sharedInstance.fetchWithPredicate(entityName: Constants.CoreData.githubUser as NSString, predicate: NSPredicate(format: "userId = \(self.userId )")) as? [GithubUser], savedObjects.count > 0 {
            savedObjects.first?.noteAdded = !(userNotes?.isEmpty ?? false)
            do {
                try savedObjects.first?.managedObjectContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        do {
            try  self.viewModel.userDetail?.managedObjectContext?.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(UserProfileTableViewCell.self)
            cell.setupCell(userDetail: self.viewModel.userDetail)
            return cell
        }
        let cell = tableView.dequeueReusableCell(UserDetailTableViewCell.self)
        cell.setupCell(userDetail: self.viewModel.userDetail)
        return cell
    }
}

extension UserDetailViewController: UserDetailDelegate {
    func getUserDetail() {
        self.userDetailTableView.delegate = self
        self.userDetailTableView.dataSource = self
        self.userDetailTableView.reloadData()
    }
    
    func showAlert(alertMessage: String) {
        self.showAlert(withMessage: alertMessage, rightButton: Constants.Alert.ok, completion: { tag in
            self.userDetailTableView.reloadData()
        })
    }
}
