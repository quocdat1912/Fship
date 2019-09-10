
//  ViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/2/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//
class HomeViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var saveOrderButton: UIButton!
    @IBOutlet weak var mapGoogleView: UIView!
    @IBOutlet weak var sourcePlaceTextField: UITextField!
    var mapView : GMSMapView!
    @IBOutlet weak var destinationPlaceTextField: UITextField!
    
    @IBOutlet weak var showOrder: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    var destinationPlace : GMSPlace!
    var sourcePlace : GMSPlace!
    var boolCheck : Bool!
    var costDistance : Double!//sourcePlaceTextField = true,destinationPlaceTextField = false
    var number = 1
    var compliionhander : DownloadComplete!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        sourcePlaceTextField.delegate = self
        destinationPlaceTextField.delegate = self
        locationManager.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: mapGoogleView.frame, camera: camera)
        mapGoogleView.addSubview(mapView)
        mapView.delegate = self
        initializeTheLocationManager {
            if let location = self.currentLocation {
                self.cameraMoveToLocation(toLocation: location)
//                let marker = GMSMarker(position: location)
//                                marker.title = "my location"
//                marker.map = self.mapView
            }
        }

        
    }
    @IBAction func listOrderTap(_ sender: Any) {
        performSegue(withIdentifier: "showOrder", sender: nil)
    }
    func setUI (){
        let session = UserDefaults.standard.value(forKey: "UserSession") as! Int
        print(session)
        if session == 0 {
            sourcePlaceTextField.isHidden = true
            destinationPlaceTextField.isHidden = true
            saveOrderButton.isHidden = true
        }
        else{
            showOrder.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        if let desti = destinationPlace {
//                let marker = GMSMarker(position: desti.coordinate)
//                marker.title = desti.name
//                marker.map = mapView
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if let location = currentLocation {
//            cameraMoveToLocation(toLocation: location)
//        }
//
//    }
    
    @IBAction func addOrderTapped(_ sender: Any) {
    guard let des = destinationPlaceTextField.text, let sou = sourcePlaceTextField.text, sou != "", des != "" else {
        showAlert(titleAlert: "Chưa có địa chỉ nơi đi, đến")
        return  }
    Location.shared.origin = sourcePlace
    Location.shared.destination = destinationPlace
        print(Location.shared.origin.name)
        print(Location.shared.destination.name)
        //distance.downloadDistance()
        //print("\(self.distance.distanceCost!)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showOrder":
            break
        case "saveOrderSegue":
            let vc = segue.destination as! SaveOrderViewController
            vc.destinationPlace = destinationPlace
            vc.sourcePlace = sourcePlace
            break
        default:
            break
        }
        
//        guard let distanceCost = distance.distanceCost else{ return}
//        vc.cost = distanceCost

    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.addTarget(self, action: #selector(autocompleteClicked), for: .editingDidBegin)
        if textField == sourcePlaceTextField {
            boolCheck = true
            
        }
        else {
        boolCheck = false
        }
        print(boolCheck!)
        return true
    }
    
    func initializeTheLocationManager(completed: @escaping DownloadComplete) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        compliionhander = completed
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        Location.shared.latitude = locationManager.location?.coordinate.latitude
//        Location.shared.longitude = locationManager.location?.coordinate.longitude
        currentLocation = locationManager.location?.coordinate
        //cameraMoveToLocation(toLocation: currentLocation)
        mapView.isMyLocationEnabled = true
        if self.number == 1 {
            compliionhander()
            self.number += 1
        }
    }
    
//    func callCamera (Latitude: Double, Longitude: Double){
//        let camera = GMSCameraPosition.camera(withLatitude: Latitude, longitude: Longitude, zoom: 6.0)
    
//        let marker = GMSMarker()
//             marker.position = CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
//               marker.title = "My location"
//               marker.snippet = "hihi"
//              marker.map = mapView
        
//    }
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
   
    @IBAction func unwindSegue(Segue: UIStoryboardSegue) {
    }
    
    
    @objc func autocompleteClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
}

extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
//        if(boolCheck == true){
//            destinationPlace = place
//            destinationPlaceTextField.text = place.formattedAddress
//        }
//        else {sourcePlace = place
//            sourcePlaceTextField.text = place.formattedAddress
//        }
//        dismiss(animated: true, completion: nil)
//
//    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
                print("Place name: \(place.name)")
                print("Place ID: \(place.placeID)")
                print(boolCheck)
                if(boolCheck == false){
                    destinationPlace = place
                    destinationPlaceTextField.text = place.name
                }
                else {sourcePlace = place
                    sourcePlaceTextField.text = place.name
                }
                //destinationPlaceTextField.text = "hihi"
                dismiss(animated: true, completion: nil)
    }
    
//    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//
//        return false
//    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func showAlert (titleAlert: String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}



