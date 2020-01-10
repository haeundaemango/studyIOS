//
//  FeedVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/11.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	// MARK: -Properties

    override func viewDidLoad() {
        super.viewDidLoad()

		self.collectionView.backgroundColor = .white
		
		configureNavigationBar()

		
        // Register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
    }

	// MARK: UICollectionViewFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = view.frame.width
		var height = width + 8 + 40 + 8
		height += 50
		height += 60
		
		return CGSize(width: width, height: height)
	}
	


    // MARK: -UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        return cell
    }
	
	// MARK: -Handlers
	
	func configureNavigationBar() {
		self.navigationItem.title = "Feed"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
	}

	@objc func handleShowMessages() {
		print("handle show messages")
	}
	
}
