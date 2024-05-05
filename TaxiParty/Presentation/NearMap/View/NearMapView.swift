//
//  NearMapView.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import NMapsMap
import SnapKit
import Then
import Kingfisher

final class NearMapView: BaseView {
    
    var clusterer: NMCClusterer<ItemKey>?
    var delegate: transferData?
    
    let mapView = BaseMapView()
    let backView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayBorder.cgColor
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 7
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.backgroundColor = .white
    }
    let creatorImage = RoundImageView(frame: .zero)
    let creatorNick = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
    }
    private let title = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
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
    let dueDateLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .light)
        $0.text = "7시간 남음"
    }
    let leftNum = UILabel().then {
        $0.font = .Spoqa(size: 16, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backView.isHidden = true
    }
    
    override func setHierarchy() {
        addSubViews(views: [mapView, backView])
        backView.addSubViews(views: [creatorImage, creatorNick, title, startPointIcon, destinationIcon, interLineImage, interLineImage, startPointLabel, destinationLabel, startInfoLabel, destinationInfoLabel, dueDateLabel, leftNum])
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        backView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
            make.centerX.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        creatorImage.snp.makeConstraints { make in
            make.top.leading.equalTo(backView).offset(20)
            make.size.equalTo(24)
        }
        creatorNick.snp.makeConstraints { make in
            make.leading.equalTo(creatorImage.snp.trailing).offset(4)
            make.centerY.equalTo(creatorImage)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(creatorImage.snp.bottom).offset(10)
            make.leading.equalTo(creatorImage)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-20)
            make.centerY.equalTo(creatorImage)
        }
        startPointIcon.snp.makeConstraints { make in
            make.top.equalTo(creatorImage.snp.bottom).offset(40)
            make.leading.equalTo(backView).offset(20)
            make.size.equalTo(24)
        }
        startPointLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon)
            make.leading.equalTo(startPointIcon.snp.trailing).offset(12)
            make.trailing.equalTo(backView.snp.trailing).offset(-12)
        }
        startInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel.snp.bottom).offset(0)
            make.leading.equalTo(startPointLabel)
        }
        destinationIcon.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom).offset(30)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(18.45)
            make.height.equalTo(24)
        }
        destinationLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationIcon)
            make.leading.equalTo(startPointLabel)
            make.trailing.equalTo(backView.snp.trailing).offset(-12)
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
        leftNum.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-20)
            make.bottom.equalTo(backView.snp.bottom).offset(-20)
        }
    }
    
    func configureInfoView(post: Post) {
        delegate?.transferData(item: post)
        backView.isHidden = false
        title.text = post.title
        creatorImage.image = UIImage(systemName: "person")
        creatorNick.text = post.creator.nick
        let startPlaceData = post.startPlaceData.split(separator: ",")
        startPointLabel.text = String(startPlaceData[0])
        let destinationData = post.destinationData.split(separator: ",")
        destinationLabel.text = String(destinationData[0])
        let availableNum = (Int(post.numberOfPeople) ?? 4) - 1 - post.together.count
        leftNum.text = availableNum <= 0 ? "마감!" : "\(availableNum)자리 남음"
        dueDateLabel.text = calculateLeftTime(post.dueDate) + " 출발"
        guard let url = URL(string: APIKey.baseURL.rawValue + "/v1/" +  (post.creator.profileImage ?? "default")) else { return }
        let options: KingfisherOptionsInfo = [
            .requestModifier(ImageDownloadRequest())
        ]
        creatorImage.kf.setImage(with: url, options: options)
        if url.absoluteString == APIKey.baseURL.rawValue + "/v1/" + "default" {
            creatorImage.image = UIImage(named: "defaultProfile")
        }
    }
    
    func configureMap(items: [Post]) {
        
        let builder = NMCBuilder<ItemKey>()
        let leafMarkerUpdater = LeafMarkerUpdater()
        leafMarkerUpdater.postItems = items
        leafMarkerUpdater.nearMapView = self
        builder.minZoom = 3
        builder.leafMarkerUpdater = leafMarkerUpdater
        self.clusterer = builder.build()
        leafMarkerUpdater.clusterer = self.clusterer
        var keyTagMap: [ItemKey: NSNull] = [:]
        var index = 0
        
        for post in items {
            let startData = post.startPlaceData.split(separator: ",")
            
            index += 1
            let newItem = ItemKey(identifier: index, position: NMGLatLng(lat: Double(startData[2]) ?? 37.654165, lng: Double(startData[1]) ?? 127.049696))
            keyTagMap[newItem] = NSNull()
        }
        
        clusterer?.addAll(keyTagMap)
        clusterer?.mapView = self.mapView.naverMapView.mapView
        
    }
    
}

extension NearMapView {
    class ItemKey: NSObject, NMCClusteringKey {
        let identifier: Int
        let position: NMGLatLng
        
        init(identifier: Int, position: NMGLatLng) {
            self.identifier = identifier
            self.position = position
        }
        
        static func markerKey(withIdentifier identifier: Int, position: NMGLatLng) -> ItemKey {
            return ItemKey(identifier: identifier, position: position)
        }
        
        override func isEqual(_ o: Any?) -> Bool {
            guard let o = o as? ItemKey else {
                return false
            }
            if self === o {
                return true
            }
            
            return o.identifier == self.identifier
        }
        
        override var hash: Int {
            return self.identifier
        }
        
        func copy(with zone: NSZone? = nil) -> Any {
            return ItemKey(identifier: self.identifier, position: self.position)
        }
    }
    
    class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
        var clusterer: NMCClusterer<ItemKey>?
        var postItems: [Post] = []
        var nearMapView: NearMapView?
        
        override func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
            super.updateLeafMarker(info, marker)
            if let key = info.key as? ItemKey {
                marker.iconImage = NMFOverlayImage(image: (UIImage(systemName: "car.circle.fill") ?? UIImage(named: "destination")!))
                marker.width = 24
                marker.height = 24
                marker.iconTintColor = .black
                
                if let postItem = postItems.first(where: { $0.startPlaceData.contains(String(key.position.lat)) }) {
                    let destinationData = postItem.destinationData.split(separator: ",")
                    let destination = destinationData[0].split(separator: " ")
                    
                    var captionText: String
                    if destination.count >= 2 {
                        captionText = destination[0] + " " + destination[1]
                    } else {
                        captionText = String(destination[0])
                    }
                    
                    marker.captionText = captionText
                }
                
                marker.touchHandler = { [weak self] (o: NMFOverlay) -> Bool in
                    if let postItem = self?.postItems.first(where: { $0.startPlaceData.contains(String(key.position.lat)) }) {
                        self?.nearMapView?.configureInfoView(post: postItem)
                    }
                    return true
                }
            }
        }
    }
    
}

