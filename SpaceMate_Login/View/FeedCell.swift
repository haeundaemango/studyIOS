//
//  FeedCell.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2020/01/07.
//  Copyright © 2020 양승현. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
	
	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .lightGray
		return iv
	}()
	
	let usernameButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.setTitle("Username", for: .normal)
		btn.setTitleColor(.black, for: .normal)
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		return btn
	}()
	
	let optionsButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.setTitle("•••", for: .normal)
		btn.setTitleColor(.black, for: .normal)
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		return btn
	}()
	
	let postImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .lightGray
		return iv
	}()
	
	let likeButton: UIButton = {
		let btn = UIButton(type: .system)
		// set image instead of set title
		btn.setImage(UIImage(named: "like_unselected"), for: .normal)
		btn.tintColor = .black
		return btn
	}()
	
	let commentButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.setImage(UIImage(named: "comment"), for: .normal)
		btn.tintColor = .black
		return btn
	}()
	
	let messageButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.setImage(UIImage(named: "send2"), for: .normal)
		btn.tintColor = .black
		return btn
	}()
	
	let savePostButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.setImage(UIImage(named: "ribbon"), for: .normal)
		btn.tintColor = .black
		return btn
	}()
	
	let likesLabel: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.boldSystemFont(ofSize: 12)
		lbl.text = "0 likes"
		return lbl
	}()
	
	let captionLabel: UILabel = {
		let lbl = UILabel()
		let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
		attributedText.append(NSAttributedString(string: " Some test caption for now", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
		// add to label
		lbl.attributedText = attributedText
		return lbl
	}()
	
	let postTimeLabel: UILabel = {
		let lbl = UILabel()
		lbl.textColor = .lightGray
		lbl.font = UIFont.boldSystemFont(ofSize: 10)
		lbl.text = "방금"
		return lbl
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
		profileImageView.layer.cornerRadius = 40 / 2
		
		addSubview(usernameButton)
		usernameButton.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		usernameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		
		addSubview(optionsButton)
		optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		
		addSubview(postImageView)
		postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
		
		configureActionButton()
		
		addSubview(likesLabel)
		// even though like button is in stavk view, it can be referenced
		likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		addSubview(captionLabel)
		captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
		
		addSubview(postTimeLabel)
		postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
	}
	
	func configureActionButton() {
		let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
		
		addSubview(savePostButton)
		savePostButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 20, height: 24)
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
