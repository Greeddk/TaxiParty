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
    
    let mainView = NearMapView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


