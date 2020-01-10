//
//  TestVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2020/01/02.
//  Copyright © 2020 양승현. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
	
	var testImageView: UIImageView?
	
	
	// MARK: View Did Load
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		let navigationAppearance = UINavigationBarAppearance()
		navigationAppearance.backgroundColor = .red
		navigationAppearance.configureWithDefaultBackground()
		// self.navigationController?.navigationBar.standardAppearance = navigationAppearance
		
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		self.tabBarController?.tabBar.isHidden = true
		
		guard let testImage = UIImage(named:"무제-2") else { return }
		testImageView = UIImageView()
		testImageView?.image = testImage
		
		view.addSubview(testImageView!)
		testImageView?.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 140, paddingLeft: 0, paddingBottom: 140, paddingRight: 0, width: 0, height: 0)
		
		
		
		
		
				
		
	}
	
}
