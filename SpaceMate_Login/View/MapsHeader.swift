//
//  MapsHeader.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/21.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapsHeader: UICollectionViewCell, CLLocationManagerDelegate {
	
	//MARK: - Properties
	
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	var mapView: GMSMapView!
	var placesClient: GMSPlacesClient!
	var zoomLevel: Float = 15.0
	
	// An array to hold the list of likely places.
	var likelyPlaces: [GMSPlace] = []

	// The currently selected place.
	var selectedPlace: GMSPlace?
	
	
	var coffeeImage: UIImage!
	
	
	//MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		

		// configure map api sample
		configureMaps()
		
				
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	//MARK: - Handler
	
	func configureMaps() {
		// Create a GMSCameraPosition that tells the map to display the
		// coordinate -33.86,151.20 at zoom level 6.
		let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.mapType = .normal
		// mapView.isIndoorEnabled = false
		let view = mapView
		self.addSubview(view)
		view.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 1, paddingRight: 0, width: 0, height: 0)
		
		
		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
		marker.title = "Sydney"
		marker.snippet = "Australia"
		
		coffeeImage = UIImage(named: "coffee")
		marker.icon = coffeeImage
		
		marker.map = mapView
		
		
	}
	
	func configureLocation() {
		locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		locationManager.distanceFilter = 50
		locationManager.startUpdatingLocation()
		locationManager.delegate = self

		placesClient = GMSPlacesClient.shared()

	}
}
