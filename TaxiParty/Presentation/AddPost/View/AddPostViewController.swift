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
    let viewModel = AddPostViewModel()
    
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetColor = .white
        return view
    }()
    
    let coordinate = PublishRelay<String>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomSheet()
        setAttribute()
        hideKeyboardWhenViewIsTapped()
    }
    
    override func bind() {
        
        let currentPosition = "\(mainView.currentPosition.lng),\(mainView.currentPosition.lat)"
        coordinate.accept(currentPosition)
        
        let sheetView = bottomSheetView.bottomSheetView
        let input = AddPostViewModel.Input(
            coordinate: coordinate.asObservable(),
            startPointText: sheetView.startPointTextField.rx.text.orEmpty.asObservable(),
            destinationText: sheetView.destinationTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.startPoint
            .drive(bottomSheetView.bottomSheetView.startPointTextField.rx.text).disposed(by: disposeBag)
        
        Observable.merge(output.startPointList, output.destinationList)
            .bind(to: sheetView.tableView.rx.items(cellIdentifier: SearchedAddressTableViewCell.identifier, cellType: SearchedAddressTableViewCell.self)) { index, element, cell in
                cell.placeName.text = element.placeName
                cell.address.text = element.address
            }
            .disposed(by: disposeBag)
            
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
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let camposition = "\(mapView.cameraPosition.target.lng),\(mapView.cameraPosition.target.lat)"
        coordinate.accept(camposition)
    }
    
}


