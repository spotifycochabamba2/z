//
//  AddressMap.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/21/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLocation
import SVProgressHUD
import Ax

class AddressMapVC: UIViewController {
  
  var myCurrentLocation: CLLocationCoordinate2D?
  var sessionLocation: (latitude: Double, longitude: Double)?
  
  var mapView: GMSMapView!
  
  var meMarker: GMSMarker?
  var sessionMarker: GMSMarker?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func loadView() {
    super.loadView()
    
    var latitude = Constants.Google.Maps.latitudeUS
    var longitude = Constants.Google.Maps.longitudeUS
    
    if let location = sessionLocation {
      latitude = location.latitude
      longitude = location.longitude
    }
    
    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13)
    mapView = GMSMapView.map(withFrame: .zero, camera: camera)
    view = mapView
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    Spinner.show(currentViewController: self)
    SVProgressHUD.show()
    Ax.parallel(tasks: [
      { [weak self] done in
        if let sessionLocation = self?.sessionLocation {
          let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: sessionLocation.latitude, longitude: sessionLocation.longitude))
          marker.icon = GMSMarker.markerImage(with: .zentaiPrimaryColor)
          marker.title = "Session"
          marker.map = self?.mapView
          
          self?.sessionMarker = marker
          done(nil)
        } else {
          done(nil)
        }
      },
      { [weak self] done in
        DispatchQueue.main.async {
          _ = Location.getLocation(
            withAccuracy: .city,
            frequency: .oneShot,
            onSuccess: { (location) in
              SVProgressHUD.dismiss()
              
              // far away
              // 42.3402365
              // -71.1058683
              
              // near
              // 34.115779 lat
              // -118.281544 long
              //            self?.myCurrentLocation = CLLocationCoordinate2D(latitude: 34.115779, longitude: -118.281544)
              self?.myCurrentLocation = location.coordinate
              
              if let myLocation = self?.myCurrentLocation {
                let marker = GMSMarker(position: myLocation)
                marker.icon = GMSMarker.markerImage(with: .zentaiPrimaryColor)
                marker.title = "Me"
                marker.map = self?.mapView
                
                self?.meMarker = marker
                done(nil)
              }
          }) { (lastValidationLocation, error) in
            done(error as Optional<NSError>)
          }
        }
      }
    ]) { [weak self] (error) in
      SVProgressHUD.dismiss()
      
      if let meMarker = self?.meMarker,
        let sessionMarker = self?.sessionMarker
      {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(meMarker.position)
        bounds = bounds.includingCoordinate(sessionMarker.position)
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 90)
        
        DispatchQueue.main.async {
          self?.mapView.selectedMarker = meMarker
          self?.mapView.animate(with: update)
        }
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  @IBAction func back(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
}






















