//
//  BaseMapView.swift
//  TaxiParty
//
//  Created by Greed on 4/24/24.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class BaseMapView: BaseView {
    
    let naverMapView = NMFNaverMapView()
    let locationManager = CLLocationManager()
    var currentPosition = NMGLatLng()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkDeviceLocationAuthorization()
    }
    
    override func setHierarchy() {
        addSubview(naverMapView)
    }
    
    override func setupLayout() {
        naverMapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        locationManager.delegate = self
        naverMapView.showLocationButton = true
        naverMapView.showZoomControls = false
        naverMapView.mapView.logoAlign = .leftTop
        naverMapView.mapView.positionMode = .compass
    }
}

extension BaseMapView: CLLocationManagerDelegate {
    
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
        case .authorizedAlways, .authorizedWhenInUse:
            fetchUserLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            break
        }
    }
    
    @objc func fetchUserLocation() {
        currentPosition = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)

        let cameraUpdate = NMFCameraUpdate(scrollTo: currentPosition)
        cameraUpdate.animation = .none
        cameraUpdate.animationDuration = 0
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
}
