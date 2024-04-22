//
//  SearchPostView.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import SnapKit
import Then

final class SearchPostView: BaseView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 400, height: 220)
        return layout
    }
    
    override func setHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
        }
    }
    
    override func setupData() {
        collectionView.register(PartyPostCollectionViewCell.self, forCellWithReuseIdentifier: PartyPostCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }

}
