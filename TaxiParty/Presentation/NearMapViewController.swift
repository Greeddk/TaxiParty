//
//  NearMapViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import UIKit
import SwiftUI

struct NearMapRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        NearMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class NearMapViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        label.text = "map이라고 생각하셈"
    }
    
}
