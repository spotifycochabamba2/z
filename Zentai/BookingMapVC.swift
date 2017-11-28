//
//  BookingMapVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/18/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLocation
import SVProgressHUD

class BookingMapVC: UIViewController, GMSMapViewDelegate {
  @IBOutlet weak var selectBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var infoStackView: UIStackView!
  
  @IBOutlet weak var mapViewOnScreen: UIView!
  
  var marker: GMSMarker!
  var mapView: GMSMapView!
  var lastPositionSelected: (latitude: Double, longitude: Double)?
  
  var didSelectPosition: ((Double, Double) -> Void)?
  var setAddressInfo: ((_ address: String, _ city: String, _ state: String, _ zip: String) -> Void)?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    var currentLatitude = Constants.Google.Maps.latitudeUS
    var currentLongitude = Constants.Google.Maps.longitudeUS
    
    if let lastPositionSelected = lastPositionSelected {
      currentLatitude = lastPositionSelected.latitude
      currentLongitude = lastPositionSelected.longitude
    }
    
    let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 13)
    mapView = GMSMapView.map(withFrame: mapViewOnScreen.frame, camera: camera)
    
    mapView.delegate = self
    
    if lastPositionSelected != nil {
      let coordinate = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
      marker = GMSMarker(position: coordinate)
      marker.icon = GMSMarker.markerImage(with: UIColor.zentaiPrimaryColor)
      marker.map = mapView
      
      mapView.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), zoom: 13))
    } else {
      _ = Location.getLocation(
        withAccuracy: .ipScan,
        frequency: .significant,
        onSuccess: { (location) in
          //stanford
          let latitude = 37.429275
          let longitude = -122.162173
          
          DispatchQueue.main.async {
            self.mapView.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2DMake(latitude, longitude), zoom: 13))
          }
      }) { (lastValidationLocation, error) in
        print(lastValidationLocation)
        print(error)
      }
    }
    
    mapViewOnScreen.addSubview(mapView)
  }
  
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    print("wtf setting up: coordinate.latitude: \(coordinate.latitude)")
    print("wtf setting up: coordinate.longitude: \(coordinate.longitude)")
    
    lastPositionSelected = (coordinate.latitude, coordinate.longitude)
    if marker != nil {
      marker.map = nil
    }
    
    marker = GMSMarker(position: coordinate)
    marker.icon = GMSMarker.markerImage(with: UIColor.zentaiPrimaryColor)
    marker.map = mapView
    
    //
    //    //        37.429275, -122.162173  stanford
    //    let latitude = 37.429275
    //    let longitude = -122.162173
    //
    //    //        let latitude = location.coordinate.latitude
    //    //        let longitude = location.coordinate.longitude
    //    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    //    _ = Location.reverse(coordinates: coordinates, using: ReverseService.google, onSuccess: { (placemark) in
    //      print(placemark)
    //    }) { (error) in
    //      print(error)
    //    }
    //
    
  }
  
  @IBAction func selectAddress(_ sender: AnyObject) {
    guard let position = lastPositionSelected else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    var coordinates = CLLocationCoordinate2D()
    coordinates.latitude = position.latitude
    coordinates.longitude = position.longitude
    
    //    Spinner.show(currentViewController: self)
    SVProgressHUD.show()
    _ = Location.reverse(coordinates: coordinates, using: .google, onSuccess: { [weak weakSelf = self] (placemark) in
      Spinner.dismiss()
      
      let city = placemark.locality ?? ""
      let zip = placemark.postalCode ?? ""
      let state = placemark.administrativeArea ?? ""
      let address = "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
      
      DispatchQueue.main.async {
        weakSelf?.setAddressInfo?(address, city, state, zip)
        weakSelf?.didSelectPosition?(coordinates.latitude, coordinates.longitude)
        weakSelf?.dismiss(animated: true, completion: nil)
      }
      
    }) { [weak weakSelf = self] (error) in
      Spinner.dismiss()
      weakSelf?.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func dismiss(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
}




















