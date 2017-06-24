//
//  ViewController.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 20.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacesSearchController
import PKHUD

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var locationManager = CLLocationManager()
    var mainMarker : GMSMarker?
    var address : Address?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView setup
        let camera = GMSCameraPosition.camera(withLatitude: 29.364813, longitude: 47.982395, zoom: 15)
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        //locationManager setup
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (mainMarker != nil) {
            mainMarker?.map = mapView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if (mainMarker != nil) {
            mainMarker?.map = nil
            mainMarker = nil
        }

        mainMarker = GMSMarker(position: coordinate)
        mainMarker?.title = "Address location"
        mainMarker?.map = mapView
        mainMarker?.icon = UIImage(named: "marker")
        
        let newCamera = GMSCameraPosition.camera(withLatitude:(mainMarker?.position.latitude)!,
                                              longitude: (mainMarker?.position.longitude)!,
                                              zoom: mapView.camera.zoom)
        
        DispatchQueue.main.async {
            mapView.animate(to: newCamera)
        }
        
        confirmButton.isHighlighted = false
        confirmButton.isUserInteractionEnabled = true
    }
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: mapView.camera.zoom)
        
        DispatchQueue.main.async {
            self.mapView?.animate(to: camera)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    //Buttons touches
    @IBAction func confirmTouchUpInside(_ sender: Any) {
        
        HUD.show(.progress)
        
        AddressNetworkManager.shared.getAddressWithCoordinate(coordinate: (mainMarker?.position)!) { (success, addressFromAPI, error) in
            
            if success {
                HUD.flash(.success, delay: 1.0)
                self.address = Address()
                self.address?.coordinate = (self.mainMarker?.position)!
                self.address?.block = (addressFromAPI?.block)!
                self.address?.area = (addressFromAPI?.area)!
                self.address?.street = (addressFromAPI?.street)!
            
                self.performSegue(withIdentifier: "DetailSegue", sender: self)
            }
            else {
                HUD.flash(.labeledError(title: "Error", subtitle: error), delay: 2.0)
            }
        }
    }
    
    @IBAction func skipTouchUpInside(_ sender: Any) {
        mainMarker?.map = nil
        mainMarker = nil
        
        confirmButton.isHighlighted = true
        confirmButton.isUserInteractionEnabled = false
    }
    
    @IBAction func myLocationTouchUpInside(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func searchButtonTouch(_ sender: Any) {
        
        let searchController = GooglePlacesSearchController(
            apiKey: (UIApplication.shared.delegate as! AppDelegate).googleWebServiseKey,
            placeType: PlaceType.address
        )
        setTextFieldTintColor(to: UIColor.darkText, for: searchController.searchBar)
        
        searchController.didSelectGooglePlace { (place) -> Void in
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: self.mapView.camera.zoom)
            
            DispatchQueue.main.async {
                self.mapView?.animate(to: camera)
            }
            
            searchController.isActive = false
        }
        
        present(searchController, animated: true, completion: nil)
    }
    
    
    //Open segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue"{
            if let addressViewController = segue.destination as? AddressViewController{
                addressViewController.currentCamera = mapView.camera
                addressViewController.mainMarker = mainMarker
                addressViewController.address = address
            }
        }
    }
    
    func setTextFieldTintColor(to color: UIColor, for view: UIView) {
        if view is UITextField {
            view.tintColor = color
        }
        for subview in view.subviews {
            setTextFieldTintColor(to: color, for: subview)
        }
    }
}

