//
//  UserProfileHeader.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/12.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
	
	var user: User? {
		
		didSet {
			
			// configure edit profile button
			configureEditProfileFollowButton()
			
			let fullName = user?.name
			nameLabel.text = fullName
			
			guard let profileImageUrl = user?.profileImageUrl else { return }
			profileImageView.loadImage(with: profileImageUrl)
		}
		
	 }

	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .lightGray
		
		return iv
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		
		label.text = "Yang"
		label.font = UIFont.boldSystemFont(ofSize: 12)
		label.textAlignment = .center
		
		return label
	}()
	
	let postsLabel: UILabel = {
		let label = UILabel()
		
		label.numberOfLines = 0
		label.textAlignment = .center
		
		let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
		label.attributedText = attributedText
		
		
		return label
	}()
	
	let followersLabel: UILabel = {
		let label = UILabel()
		
		label.numberOfLines = 0
		label.textAlignment = .center
		
		let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
		label.attributedText = attributedText
		
		return label
	}()
	
	let followingLabel: UILabel = {
		let label = UILabel()
		
		label.numberOfLines = 0
		label.textAlignment = .center
		
		let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
		label.attributedText = attributedText
		
		return label
	}()
	
	// button not being clicked
	let editProfileFollowButton: UIButton = {
		let button = UIButton(type: .system)
		
		button.setTitle("Loading", for: .normal)
		button.layer.cornerRadius = 5
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 0.5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
		
		return button
	}()
	
	let gridButton: UIButton = {
		let button = UIButton(type: .system)
		
		button.setImage(UIImage(named: "grid"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.8)
		
		return button
	}()
	
	let listButton: UIButton = {
		let button = UIButton()
		
		button.setImage(UIImage(named: "list"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		
		return button
	}()
	
	let bookmarkButton: UIButton = {
		let button = UIButton()
		
		button.setImage(UIImage(named: "ribbon"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		
		return button
	}()
	
	
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
		profileImageView.layer.cornerRadius = 80 / 2
		
		addSubview(nameLabel)
		nameLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: profileImageView.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		configureUserStats()
		
		addSubview(editProfileFollowButton)
		editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
		
		configureBottomToolBar()
	}
	
	
	@objc func handleEditProfileFollow() {
		print("button clicked")
		
		guard let user = self.user else { return }
		
		if editProfileFollowButton.titleLabel?.text == "Edit Profile" {
			print("handle edit profile")
		} else {
			if editProfileFollowButton.titleLabel?.text == "Follow" {
				editProfileFollowButton.setTitle("Following", for: .normal)
				user.follow()
				print("user.follow() had called")
			} else {
				editProfileFollowButton.setTitle("Follow", for: .normal)
				user.unFollow()
				print("user.unFollow() had called")
			}
		}
		
	}
	
	func configureBottomToolBar() {
		let topDividerView = UIView()
		topDividerView.backgroundColor = .lightGray

		let bottomDividerView = UIView()
		bottomDividerView.backgroundColor = .lightGray
		
		let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])

		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		addSubview(topDividerView)
		addSubview(bottomDividerView)
		
		stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		
		topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
		
		bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	
	func configureUserStats() {
		let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
		
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
	}
	
	func configureEditProfileFollowButton() {
		
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		guard let user = self.user else { return }
		
		if currentUid == user.uid {
			
			// configure button as edit profile
			editProfileFollowButton.setTitle("Edit Profile", for: .normal)
		} else {
			
			// configure button as follow
			editProfileFollowButton.setTitleColor(.white, for: .normal)
			editProfileFollowButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
			
			user.checkIfUserIsFollowed(completion: { (followed) in
				
				print("Completion value that sent is ", followed)
				if followed {
					self.editProfileFollowButton.setTitle("Following", for: .normal)
				} else {
					self.editProfileFollowButton.setTitle("Follow", for: .normal)
				}
			})
			
		}
		
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
