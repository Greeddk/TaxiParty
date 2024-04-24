//
//  AddPostView.swift
//  TaxiParty
//
//  Created by Greed on 4/22/24.
//

import UIKit
import SnapKit
import NMapsMap

final class AddPostView: BaseMapView {

    let startPointMarker = NMFMarker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        let bottomSpacing = UIScreen.main.bounds.height * 0.3
        naverMapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self).offset(-bottomSpacing + 10)
        }
    }
    
    override func setupAttributes() {
        naverMapView.mapView.zoomLevel = 17
    }

}

extension AddPostView {
    
    override func fetchUserLocation() {
        super.fetchUserLocation()
        startPointMarker.position = currentPosition
        startPointMarker.iconImage = NMFOverlayImage(name: "startPoint")
        startPointMarker.captionText = "출발"
        startPointMarker.captionAligns = [NMFAlignType.top]
        startPointMarker.width = 16
        startPointMarker.height = 16
        startPointMarker.mapView = naverMapView.mapView
    }
    
}
