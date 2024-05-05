//
//  PostHistoryView.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import UIKit
import SnapKit

final class PostHistoryView: BaseView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 400, height: 220)
        return layout
    }
    
    override func setHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func setupAttributes() {
        collectionView.register(PartyPostCollectionViewCell.self, forCellWithReuseIdentifier: PartyPostCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
    
}
