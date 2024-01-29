//
//  FoodDetailView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/29.
//

import UIKit
import RxSwift
import RxCocoa

class FoodDetailView: UIView {
    let disposeBag = DisposeBag()
    var dataRelay = BehaviorRelay<Food?>(value: nil)
    
    lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var divider: UIView = {
        let view  = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var foodName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var foodCategory: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDI(relay: BehaviorRelay<Food?>) {
        relay.bind(to: self.dataRelay).disposed(by: disposeBag)
    }
    
    func setupLayout() {
        addSubview(detailView)
        detailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        detailView.addSubview(divider)
        detailView.addSubview(foodName)
        detailView.addSubview(foodCategory)
        
        
        divider.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.top).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(5)
        }
        
        foodName.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(divider.snp.bottom).inset(-35)
        }
        foodCategory.snp.makeConstraints {
            $0.leading.equalTo(foodName.snp.leading)
            $0.top.equalTo(foodName.snp.bottom).inset(-5)
        }
    }
    
    func configure() {
        dataRelay.bind { [weak self] data in
            self?.foodName.text = data?.RCP_NM ?? ""
            self?.foodCategory.text = data?.RCP_PAT2 ?? ""
        }
    }
}
