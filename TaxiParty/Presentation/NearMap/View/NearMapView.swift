//
//  NearMapView.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import NMapsMap
import SnapKit
import CoreLocation


final class NearMapView: BaseView {

    let mapView = NMFNaverMapView(frame: .zero)
    
    var locationManager = CLLocationManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
    }
    
    override func setHierarchy() {
        addSubview(mapView)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-45)
        }
    }
    
    override func setupAttributes() {
        mapView.showLocationButton = true
        mapView.showZoomControls = false
        mapView.mapView.positionMode = .compass
    }


}

extension NearMapView: CLLocationManagerDelegate {
    
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                print("위치 권한을 켜!")
            }
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedAlways, .authorizedWhenInUse:
            fetchUserLocation()

        case .authorized:
            print("authorized")
        @unknown default:
            break
        }
    }
    
    func fetchUserLocation() {
        
        let currentPosition = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)
        print("지금 위치", currentPosition)

        let cameraUpdate = NMFCameraUpdate(scrollTo: currentPosition)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1

        mapView.mapView.moveCamera(cameraUpdate)
    }
    
}
