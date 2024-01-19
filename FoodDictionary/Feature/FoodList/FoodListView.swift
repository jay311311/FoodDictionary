//
//  FoodListView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/11.
//

import UIKit
import RxRelay
import RxSwift

class FoodListView: UIView {
    let disposeBag = DisposeBag()
    let dataRelay = BehaviorRelay<[Food]>(value: [])
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width / 2) - 20

        flowLayout.itemSize = CGSize(width: width, height: 200)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(FoodListCell.self, forCellWithReuseIdentifier: FoodListCell.id)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dependency Injection
    func setupDI(relay: BehaviorRelay<[Food]>) {
        relay.bind(to: self.dataRelay).disposed(by: disposeBag)
    }

    func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTableView() {
        dataRelay.bind(to:collectionView.rx.items(cellIdentifier:"FoodListCell", cellType: FoodListCell.self)) { index, data, cell in
            cell.configure(data: data)
        }.disposed(by: disposeBag)
    }
    
}
