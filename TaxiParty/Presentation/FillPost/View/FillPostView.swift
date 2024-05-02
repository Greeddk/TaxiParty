//
//  FillPostView.swift
//  TaxiParty
//
//  Created by Greed on 4/30/24.
//

import UIKit
import SnapKit
import Then
import NMapsMap

final class FillPostView: BaseView {
    
    let title = PointBorderTextField().then {
        $0.placeholder = "택시팟 모집 문구를 작성해주세요"
        $0.font = .Spoqa(size: 16, weight: .medium)
    }
    private let routeLabel = UILabel().then {
        $0.text = "택시팟 루트"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let startPointIcon = UIImageView().then {
        $0.image = UIImage(named: "startPoint")
    }
    private let destinationIcon = UIImageView().then {
        $0.image = UIImage(named: "destination")
    }
    private let interLineImage = UIImageView().then {
        $0.image = UIImage(named: "dotLine")
    }
    let startPointLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
    }
    let destinationLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
    }
    private let startInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "출발지"
    }
    private let destinationInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "도착지"
    }
    private let taxiFareInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "예상 택시비"
    }
    private let taxiFareLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.textColor = .pointPurple
    }
    private let taxiFarePerOneInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "1인당 예상 택시비"
    }
    private let taxiFarePerOneLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.textColor = .pointPurple
    }
    private let countStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    private let countLabel = UILabel().then {
        $0.text = "몇 분과 파티 하실래요? (본인포함)"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let countContentView = UIView()
    let countMinusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .pointPurple
    }
    let countPlusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .pointPurple
    }
    let peopleCount = UILabel().then {
        $0.text = "2"
        $0.textAlignment = .center
    }
    private let dueDateLabel = UILabel().then {
        $0.text = "언제 출발하세요?"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    let dueDate = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .dateAndTime
        $0.locale = Locale(identifier: "ko_KR")
        $0.tintColor = .pointPurple
    }
    let mapView = NMFMapView().then {
        $0.layer.cornerRadius = 20
    }
    let postButton = PointColorButton().then {
        $0.setTitle("파티 구하기", for: .normal)
    }
    
    override func setHierarchy() {
        addSubViews(views: [title, routeLabel, startPointIcon, destinationIcon, interLineImage, startPointLabel, destinationLabel, startInfoLabel, destinationInfoLabel, taxiFareLabel, taxiFareInfoLabel, taxiFarePerOneInfoLabel, taxiFarePerOneLabel, countLabel, countStackView, dueDateLabel, dueDate, mapView, postButton])
        countStackView.addArrangedSubview(countMinusButton)
        countStackView.addArrangedSubview(peopleCount)
        countStackView.addArrangedSubview(countPlusButton)
    }
    
    override func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(self).inset(30)
            make.height.equalTo(50)
        }
        routeLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
        }
        startPointIcon.snp.makeConstraints { make in
            make.top.equalTo(routeLabel.snp.bottom).offset(10)
            make.leading.equalTo(title)
            make.size.equalTo(24)
        }
        startPointLabel.snp.makeConstraints { make in
            make.leading.equalTo(startPointIcon.snp.trailing).offset(12)
            make.centerY.equalTo(startPointIcon)
        }
        startInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel.snp.bottom).offset(0)
            make.leading.equalTo(startPointLabel)
        }
        destinationIcon.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom).offset(20)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(18.45)
            make.height.equalTo(24)
        }
        destinationLabel.snp.makeConstraints { make in
            make.leading.equalTo(startPointLabel)
            make.centerY.equalTo(destinationIcon)
        }
        destinationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel.snp.bottom).offset(0)
            make.leading.equalTo(destinationLabel)
        }
        interLineImage.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom)
            make.bottom.equalTo(destinationIcon.snp.top)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(5)
        }
        taxiFareInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel)
            make.trailing.equalTo(self).offset(-100)
        }
        taxiFareLabel.snp.makeConstraints { make in
            make.top.equalTo(taxiFareInfoLabel.snp.bottom)
            make.leading.equalTo(taxiFareInfoLabel)
        }
        taxiFarePerOneInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel)
            make.leading.equalTo(taxiFareInfoLabel)
        }
        taxiFarePerOneLabel.snp.makeConstraints { make in
            make.top.equalTo(taxiFarePerOneInfoLabel.snp.bottom)
            make.leading.equalTo(taxiFarePerOneInfoLabel)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationInfoLabel.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(20)
        }
        countStackView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(120)
            make.height.equalTo(50)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(countStackView.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
        }
        dueDate.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(dueDate.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(20)
            make.bottom.equalTo(postButton.snp.top).offset(-10)
        }
        postButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func updateMapRoute(item: DirectionModel, currentNum: String) {
        let boundItems = item.route.traoptimal[0].summary.bbox
        let southWest = NMGLatLng(lat: boundItems[0][1], lng: boundItems[0][0])
        let northEast = NMGLatLng(lat: boundItems[1][1], lng: boundItems[1][0])
        let bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        mapView.extent = bounds
        
        let midIndex = item.route.traoptimal[0].path.count / 2
        let midPosition = item.route.traoptimal[0].path[midIndex]
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: midPosition[1], lng: midPosition[0]))
        mapView.moveCamera(cameraUpdate)
        mapView.zoomLevel = 10
        
        let pathOverlay = NMFPath()
        var convertedPath: [NMGLatLng] = []
        for position in item.route.traoptimal[0].path {
            convertedPath.append(NMGLatLng(lat: position[1], lng: position[0]))
        }
        pathOverlay.path = NMGLineString(points: convertedPath)
        pathOverlay.color = .pointPurple
        pathOverlay.mapView = mapView
        
        let startMarker = NMFMarker()
        startMarker.position = NMGLatLng(lat: item.route.traoptimal[0].summary.start.location[1], lng: item.route.traoptimal[0].summary.start.location[0])
        startMarker.iconImage = NMFOverlayImage(name: "startPoint")
        startMarker.width = 20
        startMarker.height = 20
        startMarker.mapView = mapView
        
        let goalMarker = NMFMarker()
        goalMarker.position = NMGLatLng(lat: item.route.traoptimal[0].summary.goal.location[1], lng: item.route.traoptimal[0].summary.goal.location[0])
        goalMarker.iconImage = NMFOverlayImage(name: "destination")
        goalMarker.width = 20
        goalMarker.height = 26
        goalMarker.mapView = mapView
        
        taxiFareLabel.text = "\(item.route.traoptimal[0].summary.taxiFare)원"
        taxiFarePerOneLabel.text =
        "\(item.route.traoptimal[0].summary.taxiFare / (Int(currentNum) ?? 4))원"    }
    
}
