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

extension BaseMapView {
    
    func updateMapRoute(item: DirectionModel) {
        
        let boundItems = item.route.traoptimal[0].summary.bbox
        let southWest = NMGLatLng(lat: boundItems[0][1], lng: boundItems[0][0])
        let northEast = NMGLatLng(lat: boundItems[1][1], lng: boundItems[1][0])
        let bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        naverMapView.mapView.extent = bounds
        
        let midIndex = item.route.traoptimal[0].path.count / 2
        let midPosition = item.route.traoptimal[0].path[midIndex]
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: midPosition[1], lng: midPosition[0]))
        naverMapView.mapView.moveCamera(cameraUpdate)
        naverMapView.mapView.zoomLevel = 10
        
        let pathOverlay = NMFPath()
        var convertedPath: [NMGLatLng] = []
        for position in item.route.traoptimal[0].path {
            convertedPath.append(NMGLatLng(lat: position[1], lng: position[0]))
        }
        pathOverlay.path = NMGLineString(points: convertedPath)
        pathOverlay.color = .pointPurple
        pathOverlay.mapView = naverMapView.mapView
        
        let startMarker = NMFMarker()
        startMarker.position = NMGLatLng(lat: item.route.traoptimal[0].summary.start.location[1], lng: item.route.traoptimal[0].summary.start.location[0])
        startMarker.iconImage = NMFOverlayImage(name: "startPoint")
        startMarker.width = 20
        startMarker.height = 20
        startMarker.mapView = naverMapView.mapView
        
        let goalMarker = NMFMarker()
        goalMarker.position = NMGLatLng(lat: item.route.traoptimal[0].summary.goal.location[1], lng: item.route.traoptimal[0].summary.goal.location[0])
        goalMarker.iconImage = NMFOverlayImage(name: "destination")
        goalMarker.width = 20
        goalMarker.height = 26
        goalMarker.mapView = naverMapView.mapView
        
    }
    
}
