//
//  MainTabVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/11.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// delegate
		self.delegate = self
		
		// configure view controller
		configureViewController()
		
		// user validation
		checkIfUserIsLoggedIn()
		
		
    }
    
	// function to create view controllers that exist within tab bar controller
	func configureViewController() {
		
		// home feed controller
		let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
		
		// let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: MapsVC(collectionViewLayout: UICollectionViewFlowLayout()))

		// test VC
		// let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: TestVC())
		
		// search feed controller
		let searchVC = constructNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchVC())
		
		// post controller
		let selectImageVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!)
		
		// notification controller
		let notificationVC = constructNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationVC())
		
		// profile controller
		let userProfileVC = constructNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
		
		// view controller to be added to tab controller
		viewControllers = [feedVC, searchVC, selectImageVC, notificationVC, userProfileVC]
		
		//tab bar tint color
		tabBar.tintColor = .black
		
	}

	// what is this and return what
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let index = viewControllers?.firstIndex(of: viewController)
		if index == 2 {
			
			let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
			let navController = UINavigationController(rootViewController: selectImageVC)
			navController.modalPresentationStyle = .fullScreen
			navController.navigationBar.tintColor = .black
			
			present(navController, animated: true, completion: nil)
			
			return false
		}
		return true
	}
	
	// construct navigation controllers
	func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
		
		// construct nav controller
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.tabBarItem.image = unselectedImage
		navController.tabBarItem.selectedImage = selectedImage
		navController.navigationBar.tintColor = .black
		
		// return nav controller
		return navController
	}
	
	func checkIfUserIsLoggedIn() {
		if Auth.auth().currentUser == nil {
			// what is this
			DispatchQueue.main.async {
				// present login controller
				let loginVC = LoginVC()
				let navController = UINavigationController(rootViewController: loginVC)
				self.present(navController, animated: true, completion: nil)
			}
			return
		}
	}
}
