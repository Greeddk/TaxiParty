//
//  AddPostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/22/24.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import NMapsMap

struct AddPostRepresentableView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        AddPostViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class AddPostViewController: BaseViewController {
    
    let mainView = AddPostView()
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetColor = .white
        return view
    }()
    let modalView = ConfigurePostViewController()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomSheet()
        setAttribute()
    }
    
    private func configureBottomSheet() {
        view.addSubview(self.bottomSheetView)
        bottomSheetView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setAttribute() {
        mainView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
}

extension AddPostViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let camPosition = mapView.cameraPosition
        mainView.startPointMarker.position = camPosition.target
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        let camPosition = mapView.cameraPosition
        mainView.startPointMarker.position = camPosition.target
    }
}


