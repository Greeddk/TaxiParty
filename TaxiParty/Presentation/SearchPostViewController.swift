//
//  SearchPostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import UIKit
import SwiftUI

struct SearchPostRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        SearchPostViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class SearchPostViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        label.text = "파티 찾는 글이라 생각하셈"
    }

}
