//
//  SearchVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/11.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

private let reuserIdentifier = "SearchUserCell"

class SearchVC: UITableViewController {
	
	// MARK: -Properties
	var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

		// register cell classes
		tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuserIdentifier)
		
		// separator insets, 8 + 48 + 8
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
		
		
		configureNavController()
		
		//fetch users
		fetchUsers()
		
		
    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
    }
	
	// when a row clicked
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let user = users[indexPath.row]
		print("user name is \(user.username!)")
		
		// create instance of user profile vc
		let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
		
		// passes user from searchVC to userProfileVC
		userProfileVC.userToLoadFromSearchVC = user
		
		// push view controller
		navigationController?.pushViewController(userProfileVC, animated: true)
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! SearchUserCell
		
		cell.user = users[indexPath.row]
		
		return cell
	}
	
	// MARK: -Handlers
	
	func configureNavController() {
		navigationItem.title = "Explore"
	}

	
	
	// MARK: -API
	
	func fetchUsers() {
		Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
			
			// uid
			let uid = snapshot.key
			
			// snapshot value cast as dictionary
			guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
			
			// construct user
			let user = User(uid: uid, dictionary: dictionary)
			
			// append users to data source
			self.users.append(user)
			
			// reload our table view
			self.tableView.reloadData()
			
			
		}
	}
	
}
