//
//  User.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/16.
//  Copyright © 2019 양승현. All rights reserved.
//

import Firebase

// custom object
class User {
	
	// attributes
	var username: String!
	var name: String!
	var profileImageUrl: String!
	var uid: String!
	var isFollowed = false
	
	init(uid: String, dictionary: Dictionary<String, AnyObject>) {
		
		self.uid = uid
		
		if let username = dictionary["username"] as? String {
			self.username = username
		}
		
		if let name = dictionary["name"] as? String {
			self.name = name
		}
		
		if let profileImageUrl = dictionary["profileImageUrl"] as? String {
			self.profileImageUrl = profileImageUrl
		}
	}
	
	func follow() {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		guard let uid = self.uid else { return }
		
		//set isFollowed to true
		self.isFollowed = true
		
		// add followed user to current user-following structure
		USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1])
		
		// add current user to followed user-followed structure
		USER_FOLLOWER_REF.child(uid).updateChildValues([currentUid: 1])
	}
	
	func unFollow() {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		guard let uid = self.uid else { return }

		// set isFollowed to false
		self.isFollowed = false
		
		// remove user from current user-following structure
		USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
		
		// remove current user from user-follower structure
		USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue()
	}
	
	func checkIfUserIsFollowed(completion: @escaping(Bool) -> () ) {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }

		USER_FOLLOWING_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
			
			if snapshot.hasChild(self.uid) {
				
				self.isFollowed = true
				completion(true)
				print("user is followed")
				
			} else {
				
				self.isFollowed = false
				completion(false)
				print("user is unfollowed")
				
			}
		}
		
		
	}
	
}
