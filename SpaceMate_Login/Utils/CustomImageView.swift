//
//  CustomImageView.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2020/01/07.
//  Copyright © 2020 양승현. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
	
	var lastImgUrlUsedtoLoadImage: String?
	
	func loadImage(with urlString: String) {
		
		// set image to nil
		self.image = nil
		
		//set lastImgUrlUsedtoLoadImage
		lastImgUrlUsedtoLoadImage = urlString
		
		// check if image exist in cache
		if let cachedImage = imageCache[urlString] {
			self.image = cachedImage
			return
		}
		
		// if image does not exist in cache
		
		// url for image location
		guard let url = URL(string: urlString) else { return }
		
		// fetch contents of URL
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			// handle error
			if let error = error {
				print("Failed to load image with error", error.localizedDescription)
			}
			
			if self.lastImgUrlUsedtoLoadImage != url.absoluteString {
				return
			}
			
			// image data
			guard let imageData = data else { return }
			
			// create image using image data
			let photoImage = UIImage(data: imageData)
			
			// set key and value for image cache
			imageCache[url.absoluteString] = photoImage
			
			// set image
			DispatchQueue.main.async {
				self.image = photoImage
			}
		}.resume()
		
	}
}
