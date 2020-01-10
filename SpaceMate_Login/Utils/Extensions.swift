//
//  Extensions.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/10.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension UIView {
	
	// anchor extension method for UIView Class
	// specifying location of stacks and objects
	func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
		}
		
		if let left = left {
			self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
		}
		
		if let bottom = bottom {
			self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
		}
		
		if let right = right {
			self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
		}
		
		if width != 0 {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		
		if height != 0 {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
		
	}
	
	func resizeImage(_ image: UIImage, scale: CGFloat) -> UIImage {
		var new_image : UIImage!
		
		let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
		image.draw(in: rect)
		new_image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return new_image
	}
	
}

extension MapsVC {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

    // listLikelyPlaces()
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
		default:
		print("location manager status error...")

	}
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
