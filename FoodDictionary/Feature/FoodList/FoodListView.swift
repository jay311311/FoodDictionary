//
//  FoodListView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/11.
//

import UIKit
import RxSwift
import RxCocoa

class FoodListView: UIView {
    let disposeBag = DisposeBag()
    let dataRelay = BehaviorRelay<[Food]>(value: [])
    let actionRelay = PublishRelay<FoodListActionType>()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width / 2) - 15
        
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        
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
    
    func setupDI(relay: PublishRelay<FoodListActionType>) {
        actionRelay.bind(to: relay).disposed(by: disposeBag)
    }
    
    func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTableView() {
        dataRelay.bind(to:collectionView.rx.items(cellIdentifier:"FoodListCell", cellType: FoodListCell.self)) {
            [weak self] index, data, cell in
            guard let self = self else { return }
            cell.configure(data: data)
            
            cell.saveBtn.rx.tap
                .bind {[weak self] _ in
                    guard let self = self else { return }
                    cell.saveBtn.isSelected = !cell.saveBtn.isSelected
                    actionRelay.accept(.tapSaveBtn(name: data.RCP_NM, isSelected: cell.saveBtn.isSelected))
                }.disposed(by: cell.disposeBag)

        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Food.self)
            .subscribe(onNext: { [weak self] observe in
                self?.actionRelay.accept(.tapFoodList(name: observe.RCP_NM))
            })
            .disposed(by: disposeBag)
    }
    
}
