//
//  UserProfileVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/11.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	// MARK: -Properties
	
	var currentUser: User?
	var posts = [Post]()
	var userToLoadFromSearchVC: User?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

		// background color
		self.collectionView?.backgroundColor = .white
		
		// attach logout button
		if userToLoadFromSearchVC == nil {
			configureLogoutButton()
		}
		
		// fetch user data
		if userToLoadFromSearchVC == nil {
			fetchCurrentUserData()
		}
		
		// fetch posts
		fetchPosts()
		
		
		if let userToLoadFromSearchVC = self.userToLoadFromSearchVC {
			print("username from previous controller is \(userToLoadFromSearchVC.username!)")
		}
		
	}
	
	
	// MARK: UICollectionViewFlowLayout
	// had to bring flowlayout protocol
	// making cells
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		
		return CGSize(width: view.frame.width, height: 200)
	}
	

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		// but isn't this function called before fetching posts in end of the viewDidLoad function
		// and this is for the cell for your reminder
		return posts.count
    }
	
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		// declare header
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
		
		// set the user in header
		if let user = self.currentUser {
			header.user = user
		} else if let userToLoadFromSearchVC = self.userToLoadFromSearchVC {
			header.user = userToLoadFromSearchVC
			navigationItem.title = userToLoadFromSearchVC.username
		}
		
		// return header
		return header
		
	}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
    
        // Configure the cell
		print("index path . item: ", indexPath.item," and index path is: ", indexPath)
		cell.post = posts[indexPath.item]
    
        return cell
    }
	
	//MARK: - Handler
	
	func configureLogoutButton() {
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
	}
	
	@objc func handleLogout() {
		
		// declare alert controller
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		// declare alert action
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			// firebase works like this
			do {
				// attempt log out
				try Auth.auth().signOut()
				
				// present login controller
				let loginVC = LoginVC()
				let navController = UINavigationController(rootViewController: loginVC)
				self.present(navController, animated: true, completion: nil)
				
				
				// configure
				print("Successfully logged user out")
				
			} catch {
				// handle error
				print("failed to sign out")
			}
		}))
	
		// cancel action
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		// present
		/*self.*/present(alertController, animated: true, completion: nil)
	}

    // MARK: -API
	
	func fetchPosts() {
		
		var uid: String!
		
		if let user = self.userToLoadFromSearchVC {
			uid = user.uid
		} else {
			uid = Auth.auth().currentUser?.uid
		}
				
		USER_POSTS_REF.child(uid).observe(.childAdded) {(snapshot) in

			let postId = snapshot.key
			
			POSTS_REF.child(postId).observeSingleEvent(of: .value, with: {(snapshot) in
				
				guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
				
				let post = Post(postId: postId, dictionary: dictionary)
				
				self.posts.append(post)
				
				// sorting by date
				self.posts.sort { (post1, post2) -> Bool in
					return post1.creationDate > post2.creationDate
				}
				
				self.collectionView?.reloadData()
				
			})
			
		}
		
	}
	
	func fetchCurrentUserData() {
		
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		
		Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
			guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
			let uid = snapshot.key
			let user = User(uid: uid, dictionary: dictionary)
			
			self.currentUser = user
			self.navigationItem.title = user.username
			self.collectionView?.reloadData()
		}
	}

}
