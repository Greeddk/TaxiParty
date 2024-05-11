//
//  SearchPostView.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import SnapKit

final class SearchPostView: BaseView {

    let title = UILabel().then {
        $0.text = "택시팟"
        $0.font = .Spoqa(size: 16, weight: .bold)
        $0.textColor = .pointPurple
        $0.textAlignment = .center
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 400, height: 220)
        return layout
    }
    
    override func setHierarchy() {
        addSubViews(views: [title, collectionView])
    }
    
    override func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    override func setupData() {
        collectionView.register(PartyPostCollectionViewCell.self, forCellWithReuseIdentifier: PartyPostCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }

}
