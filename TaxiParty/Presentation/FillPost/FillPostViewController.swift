//
//  FillPostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/29/24.
//

import UIKit

final class FillPostViewController: BaseViewController {
    
    let mainView = FillPostView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }


}
