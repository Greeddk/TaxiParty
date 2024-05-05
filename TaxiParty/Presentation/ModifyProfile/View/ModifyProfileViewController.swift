//
//  CompleteSignUpViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI

final class ModifyProfileViewController: BaseViewController {
    
    let mainView = ModifyProfileView()
    let viewModel = ModifyProfileViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenViewIsTapped()
        setNavigationBackButton()
    }
    
    override func bind() {

        let input = ModifyProfileViewModel.Input(
            profileImageTapped: mainView.profileImageView.rx.tapGesture().when(.recognized),
            nicknameTextFieldText: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
            modifyButtonTapped: mainView.modifyButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.openImagePickerTrigger
            .drive(with: self) { owner, value in
                owner.openPicker()
            }
            .disposed(by: disposeBag)
        
        output.backToSettingViewTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func openPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

}

extension ModifyProfileViewController: PHPickerViewControllerDelegate {
 
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    let newImage = image as? UIImage
                    self.mainView.profileImageView.image = newImage
                    self.viewModel.profileImage.accept(newImage?.jpegData(compressionQuality: 0.3) ?? Data())
                }
            }
        }
    }
}
