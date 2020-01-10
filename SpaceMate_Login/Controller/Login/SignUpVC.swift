//
//  SignUpVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/10.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
// import firebase for utils
// can use after configuring in AppDelegate
import Firebase

									// need for importing image		// need for extra view (sign up)
class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// boolean value for profile image uploaded
	var imageSelected = false
	
	// defining adding photo button (actually button, but image)
	let plusPhotoBtn: UIButton = {
		let button = UIButton(type: .system)
		
		button.setImage(UIImage(named:"plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
		
		return button
	}()

	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
		return tf
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.isSecureTextEntry = true
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
		return tf
	}()
	
	let fullNameTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Full Name"
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)

		return tf
	}()
	
	let userNameTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "User Name"
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)

		return tf
	}()
	
	let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign Up", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
		button.layer.cornerRadius = 5
		
		button.isEnabled = false
		button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
		
		return button
	}()
	
	let alreadyHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		
		let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
		attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
		
		button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		
		return button
	}()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// background color
		view.backgroundColor = .white
		
		view.addSubview(plusPhotoBtn)
		plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
		plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		configureViewComponents()
		
		view.addSubview(alreadyHaveAccountButton)
		alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 40)
		
    }
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		// selected image
		guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
			imageSelected = false
			return
			
		}
		
		// set imageSelected to true
		imageSelected = true
		
		// configure plusPhotoButton with selected image
		plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
		plusPhotoBtn.layer.masksToBounds = true
		plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
		plusPhotoBtn.layer.borderWidth = 2
		plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
		
		self.dismiss(animated: true, completion: nil)
		
	}
	
	@objc func handleSelectProfilePhoto() {
		// configure image picker
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		
		// present image picker
		self.present(imagePicker, animated: true, completion: nil)
	}
    
	@objc func handleShowLogin() {
		_ = navigationController?.popViewController(animated: true)
	}
	
	@objc func handleSignUp() {
		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }
		guard let fullName = fullNameTextField.text else { return }
		guard let userName = userNameTextField.text?.lowercased() else { return }
		
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            // handle error
            if let error = error {
                print("DEBUG: Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            guard let profileImg = self.plusPhotoBtn.imageView?.image else { return }
            guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            // UPDATE: - In order to get download URL must add filename to storage ref like this
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                // handle error
                if let error = error {
                    print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    return
                }
                
                // UPDATE: - Firebase 5 must now retrieve download url
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    guard let profileImageUrl = downloadURL?.absoluteString else {
                        print("DEBUG: Profile image url is nil")
                        return
                    }

                    // user id
                    guard let uid = authResult?.user.uid else { return }

                    let dictionaryValues = ["name": fullName,
                                            "username": userName,
                                            "profileImageUrl": profileImageUrl]

                    let values = [uid: dictionaryValues]

                    // save user info to database
					Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in

                        guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabVC else { return }

                        // configure view controllers in maintabvc
                        mainTabVC.configureViewController()

						// dismiss login controller
						self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
	}
	
	@objc func formValidation() {
		
		guard
			emailTextField.hasText,
			passwordTextField.hasText,
			fullNameTextField.hasText,
			userNameTextField.hasText,
			imageSelected == true else {
				signUpButton.isEnabled = false
				signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
				
				return
		}
		
		signUpButton.isEnabled = true
		signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
		
	}
	
	func configureViewComponents() {
		let stackView = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, userNameTextField, passwordTextField, signUpButton])
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fillEqually
		
		view.addSubview(stackView)
		stackView.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
	}
	
}
