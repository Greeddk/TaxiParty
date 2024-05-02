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
    var startCoords = ""
    
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
        
        let sheetView = bottomSheetView.bottomSheetView
        let input = AddPostViewModel.Input(
            coordinate: coordinate.asObservable(),
            startPointText: sheetView.startPointTextField.rx.text.orEmpty.asObservable(),
            destinationText: sheetView.destinationTextField.rx.text.orEmpty.asObservable(),
            startPointTextFieldSelected: sheetView.startPointTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            destinationTextFieldSelected: sheetView.destinationTextField.rx.controlEvent(.editingDidBegin)
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.startPoint
            .drive(bottomSheetView.bottomSheetView.startPointTextField.rx.text).disposed(by: disposeBag)
        
        output.focusStartPoint
            .drive(with: self) { owner, value in
                owner.bottomSheetView.toggleTextFieldFocus(isStartPoint: value)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(output.startPointList, output.destinationList)
            .bind(to: sheetView.tableView.rx.items(cellIdentifier: SearchedAddressTableViewCell.identifier, cellType: SearchedAddressTableViewCell.self)) { index, element, cell in
                cell.configureCell(item: element)
            }
            .disposed(by: disposeBag)
        
        bottomSheetView.bottomSheetView.tableView.rx
            .modelSelected(SearchedAddress.self)
            .withLatestFrom(output.focusStartPoint) { item, isStartPoint in
                return (item: item, isStartPoint: isStartPoint)
            }
            .subscribe(with: self) { owner, value in
                if value.isStartPoint {
                    owner.bottomSheetView.bottomSheetView.startPointTextField.text = value.item.placeName
                } else {
                    owner.bottomSheetView.bottomSheetView.destinationTextField.text = value.item.placeName
                    let fillPostVC = FillPostViewController()
                    fillPostVC.viewModel.route = (startPlaceName: owner.bottomSheetView.bottomSheetView.startPointTextField.text ?? "출발지 설정 필요", startPlaceCoord: owner.startCoords, destinationName: value.item.placeName, destinationAddress: value.item.address)
                    owner.navigationController?.pushViewController(fillPostVC, animated: true)
                }
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
        startCoords = camposition
        coordinate.accept(camposition)
    }
    
}


