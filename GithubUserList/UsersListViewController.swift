//
//  UsersListViewController.swift
//  GithubUserList
//

import UIKit
import Alamofire

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    lazy var viewModel = GithubUsersViewModel(viewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userListTableView.reloadData()
    }
    
    func setupView() {
        self.userListTableView.registerCell(UserTableViewCell.self)
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        self.userSearchBar.delegate = self
    }

    @IBAction func searchUserClicked(_ sender: Any) {
        self.userSearchBar.isHidden = !self.userSearchBar.isHidden
        if self.userSearchBar.isHidden {
            self.view.endEditing(true)
            self.viewModel.fetchLocalData()
        }
    }
}

extension UsersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.viewModel.fetchLocalData(isDelegate: false)
            self.viewModel.githubUsers = self.viewModel.githubUsers.filter{ $0.userName?.contains(searchText.lowercased()) as? Bool ?? false }
            self.userListTableView.reloadData()
        } else {
            self.viewModel.fetchLocalData(isDelegate: false)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.githubUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        cell.setupCell(user: self.viewModel.githubUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController
        userDetailViewController?.userName = self.viewModel.githubUsers[indexPath.row].userName ?? ""
        userDetailViewController?.userId = Int(self.viewModel.githubUsers[indexPath.row].userId ?? 0)
        self.navigationController?.pushViewController(userDetailViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.githubUsers.count - 1  && NetworkReachabilityManager()!.isReachable {
            self.viewModel.getGithubUsers()
        }
    }
}

extension UsersListViewController: GithubUsersDelegate {
    func getUserList() {
        self.userListTableView.reloadData()
    }
    
    func showAlert(alertMessage: String) {
        self.showAlert(withMessage: alertMessage, rightButton: Constants.Alert.ok, completion: { tag in
            self.userListTableView.reloadData()
        })
    }
}
