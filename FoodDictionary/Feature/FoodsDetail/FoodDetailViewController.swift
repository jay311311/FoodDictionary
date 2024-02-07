//
//  FoodDetailViewController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FoodDetailViewController: UIViewController {
    
    var viewModel: FoodDetailViewModel!
    let requestTregger = PublishRelay<Void>()
    let actionTrigger = PublishRelay<FoodDetailActionType>()
    
    lazy var backgroundView = FoodDetailBGView()
    lazy var foodDetailView = FoodDetailView()
    
    deinit {
        print("FoodDetailViewController green deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false 
        bindViewModel()
        setupLayout()
        requestTregger.accept(())
    }
    
    func bindViewModel() {
        let input = FoodDetailViewModel.Input(trigger: requestTregger, actionTrigger: actionTrigger.asObservable())
        let output = viewModel.transform(req: input)
        
        backgroundView.setupDI(relay: output.foodDetailRely)
        
        foodDetailView.setupDI(relay: output.foodDetailRely)
        foodDetailView.setupDI(relay: actionTrigger)
    }
    
    func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(foodDetailView)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.width)
        }
        
        foodDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
