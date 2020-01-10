//
//  UploadPostVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/11.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController, UITextViewDelegate {
	
	//MARK: - Properties
	
	var selectedImage: UIImage?
	
	let photoImageView: UIImageView = {
		let iv = UIImageView()
	
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .blue
		
		return iv
	}()
	
	let captionTextView: UITextView = {
		let tv = UITextView()
		
		tv.layer.cornerRadius = 5
		tv.backgroundColor = .systemGroupedBackground
		tv.font = UIFont.systemFont(ofSize: 12)
		
		return tv
	}()
	
	let shareButton: UIButton = {
		let btn = UIButton(type: .system)
		
		btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
		btn.setTitle("Share", for: .normal)
		btn.setTitleColor(.white, for: .normal)
		btn.layer.cornerRadius = 6
		btn.isEnabled = false
		btn.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
		
		return btn
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .white
		
		configureViewComponents()
		
		loadImage()
		
		// text view delegate
		captionTextView.delegate = self
		
	}
	
	//MARK: UITextView
	
	func textViewDidChange(_ textView: UITextView) {

		guard !textView.text.isEmpty else {
			shareButton.isEnabled = false
			shareButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
			return
		}
		
		shareButton.isEnabled = true
		shareButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
		
	}
	
	//MARK: Handlers
	
	@objc func handleSharePost() {
		print("handle post share here")
		
		// parameters
		guard
			let caption = captionTextView.text,
			let postImg = photoImageView.image,
			let currentUid = Auth.auth().currentUser?.uid else { return }
		
		// image upload data
		guard let uploadData = postImg.jpegData(compressionQuality: 0.5) else { return }
		
		// creation date
		let creationDate = Int(NSDate().timeIntervalSince1970)
		
		// update storage
		let filename = NSUUID().uuidString
		let storageRef = Storage.storage().reference().child("post_images").child(filename)
		
		storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
			
			if let error = error {
				print("failed to upload posting image to storage bu error: ", error.localizedDescription)
				return
			}
			
			// image url
			storageRef.downloadURL(completion: { (downloadUrl, error) in
				guard let postImageUrl = downloadUrl?.absoluteString else {
					print("error getting image url, ", error?.localizedDescription as Any)
					return
				}
				
				let values = ["caption": caption,
							  "creationDate": creationDate,
							  "likes": 0,
							  "imageUrl": postImageUrl,
							  "ownerUid": currentUid] as [String: Any]
				
				// post id
				let postId = POSTS_REF.childByAutoId()
				guard let postKey = postId.key else { return }
				
				// upload information to database
				postId.updateChildValues(values) { (error, ref) in
					
					// upload user-posts structure
					USER_POSTS_REF.child(currentUid).updateChildValues([postKey: 1], withCompletionBlock: { (error, ref) in
						
						if let error = error {
							print(error.localizedDescription)
						} else {
							print("did update user-posts DB")
						}
						
					})
					
					// back to home feed
					self.dismiss(animated: true) {
						self.tabBarController?.selectedIndex = 0
					}
				}
			})
		}
		
		

	}
	
	
	func configureViewComponents() {
		
		view.addSubview(photoImageView)
		photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
		
		view.addSubview(captionTextView)
		captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
		
		view.addSubview(shareButton)
		shareButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 60)
		
	}
	
	func loadImage() {
		
		guard let selectedImage = self.selectedImage else { return }
		photoImageView.image = selectedImage
	}

}
