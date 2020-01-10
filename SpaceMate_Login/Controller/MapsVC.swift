//
//  MapsVC.swift
//  SpaceMate_Login
//
//  Created by Devyan on 2019/12/20.
//  Copyright © 2019 양승현. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Photos

private let reuseMapIdentifier = "cell"
private let MapheaderIdentifier = "headerMapIdentifier"

class MapsVC: UICollectionViewController, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout {
	
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
	
	
	
	// image controller
	var images = [UIImage]()
	var assets = [PHAsset]()
	var selectedImage: UIImage?
	var header: SelectPhotoHeader?



	//MARK: - View
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// set default background color to white
		collectionView.backgroundColor = .white
		
		// reigister
		self.collectionView!.register(MapsCell.self, forCellWithReuseIdentifier: reuseMapIdentifier)
		self.collectionView!.register(MapsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MapheaderIdentifier)
		
		// configure navigation controller
		configureNavController()
		
		// fetch Photos
		fetchPhotos()


        
	}
	
	//MARK: - Data Source
	// UICollectionView data source
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: (view.frame.height / 2) - 40)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		// declare header
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MapheaderIdentifier, for: indexPath) as! MapsHeader
		
		// set the user in header
//		if let user = self.currentUser {
//			header.user = user
//		} else if let userToLoadFromSearchVC = self.userToLoadFromSearchVC {
//			header.user = userToLoadFromSearchVC
//			navigationItem.title = userToLoadFromSearchVC.username
//		}
		
		// return header
		return header
		
	}
	
	
	// setting cells
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	// what the fuck
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseMapIdentifier, for: indexPath) as! MapsCell
		
		// is this override function get called for each cells
		print("cell called")
		
		// this whole function means enumerating?
		cell.photoImageView.image = images[indexPath.row]
		
		// reload data
		// cell.collectionView.reloadData()
		
		return cell
	}
	
	
	//MARK: - Handler
	
	func getAssetFetchOption() -> PHFetchOptions {
		
		let options = PHFetchOptions()
		
		// fetch limit
		options.fetchLimit = 30
		
		// sort photos by date
		let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
		
		// set sortDescriptor by options
		options.sortDescriptors = [sortDescriptor, ]
		
		// return options
		return options
	}
	func fetchPhotos() {
		
		let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOption())
		
		// fetch images on background thread
		DispatchQueue.global(qos: .background).async {
			
			// enumerate objects
			allPhotos.enumerateObjects { (asset, count, stop) in
				
				// print count to check
				print("count is \(count)")
				
				let imageManager = PHImageManager.default()
				let targetSize = CGSize(width: 200, height: 200)
				let options = PHImageRequestOptions()
				options.isSynchronous = true
				
				// request image representation for specified asset
				imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
					
					if let image = image {
						
						// append image to data source
						self.images.append(image)
						
						// append asset to data source
						self.assets.append(asset)
						
						// set slected image with first image
						if self.selectedImage == nil {
							self.selectedImage = image
						}
						
						// reload collection view with images once count has completeed
						if count == allPhotos.count - 1 {
							
							// reload collection view on main thread
							DispatchQueue.main.async {
								self.collectionView.reloadData()
							}
						}
					}
				}
			}
		}
		
	}

	
    
	//MARK: - Configuration
	
	func configureNavController() {
		navigationController?.isNavigationBarHidden = true
		navigationItem.title = "Space Mate"
	}
	
	
	//MARK: - Handlers
	
	func configureMaps() {
		// Create a GMSCameraPosition that tells the map to display the
		// coordinate -33.86,151.20 at zoom level 6.
		let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.mapType = .terrain
		// mapView.isIndoorEnabled = false
		view = mapView

		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
		marker.title = "Sydney"
		marker.snippet = "Australia"
		
		let image = UIImage(named: "coffee")
		marker.icon = image
		
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
