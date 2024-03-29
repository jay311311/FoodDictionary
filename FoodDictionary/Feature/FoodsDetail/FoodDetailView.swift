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
    let dataRelay = BehaviorRelay<Food?>(value: nil)
    let recipeRelay = BehaviorRelay<[Recipe]>(value: [])
    let actionRelay = PublishRelay<FoodDetailActionType>()
    
    lazy var backgroundView = UIView()
    lazy var bottomSheet: UIView = {
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
    
    lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    lazy var foodName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(FoodDetailRecipeCell.self, forCellReuseIdentifier: FoodDetailRecipeCell.id)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configure()
        setupAddGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDI(relay: BehaviorRelay<Food?>) {
        relay.bind(to: self.dataRelay).disposed(by: disposeBag)
    }
    func setupDI(relay: PublishRelay<FoodDetailActionType>) {
        actionRelay.bind(to: relay).disposed(by: disposeBag)
    }
    
    func setupLayout() {
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.addSubview(bottomSheet)
        bottomSheet.addSubview(divider)
        bottomSheet.addSubview(saveBtn)
        bottomSheet.addSubview(foodName)
        bottomSheet.addSubview(foodCategory)
        bottomSheet.addSubview(tableView)
        
        bottomSheet.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(345)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(bottomSheet.snp.top).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(5)
        }
        
        foodName.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalTo(saveBtn.snp.leading)
            $0.top.equalTo(divider.snp.bottom).inset(-35)
        }
        foodCategory.snp.makeConstraints {
            $0.leading.equalTo(foodName.snp.leading)
            $0.top.equalTo(foodName.snp.bottom).inset(-5)
        }
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(foodName.snp.top)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(30)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(foodCategory.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure() {
        dataRelay.bind { [weak self] data in
            guard let data = data else { return }
            self?.foodName.text = data.RCP_NM
            self?.foodCategory.text = data.RCP_PAT2
            self?.saveBtn.isSelected = data.RCP_SAVE 
            self?.recipeRelay.accept(data.RCP_STEP )
        }
        .disposed(by: disposeBag)
        
        recipeRelay.bind(to: tableView.rx.items(cellIdentifier: "FoodDetailRecipeCell", cellType: FoodDetailRecipeCell.self)) { index, data, cell in
            cell.configure(index: index,data: data)
            cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
        
        saveBtn.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.saveBtn.isSelected = !(self.saveBtn.isSelected)
            actionRelay.accept(.tapSaveBtn(name: dataRelay.value?.RCP_NM ?? "", isSelected: self.saveBtn.isSelected))
        }
        .disposed(by: disposeBag)
    }
    
    func setupAddGesture(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanView))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))

        bottomSheet.addGestureRecognizer(panGestureRecognizer)
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didPanView(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self.bottomSheet)

        if velocity.y < 0 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self]  in
                    // 위로 올리기
                    self?.bottomSheet.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(145)
                    }
                    self?.bottomSheet.superview?.layoutIfNeeded()
                })
           } else if velocity.y > 0 {
               UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self]  in
                   // 아래로 내리기
                   self?.bottomSheet.snp.updateConstraints {
                       $0.top.equalToSuperview().offset(345)
                   }
                   self?.bottomSheet.superview?.layoutIfNeeded()
               })
           }
    }
    
    @objc func didTapView(_ sender: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self]  in
            // 아래로 내리기
            self?.bottomSheet.snp.updateConstraints {
                $0.top.equalToSuperview().offset(345)
            }
            self?.bottomSheet.superview?.layoutIfNeeded()
        })
    }
}
