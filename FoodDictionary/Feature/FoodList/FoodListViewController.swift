//
//  FoodListViewController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FoodListViewController: UIViewController {
    
    var viewModel: FoodListViewModel!
    let requestTrigger = PublishRelay<Void>()
    let refreshTrigger = PublishRelay<Void>()
    let actionTrigger = PublishRelay<FoodListActionType>()
    
    lazy var foodListView = FoodListView()
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "Recipe"
        navigationController?.navigationBar.prefersLargeTitles = true
        bindViewModel()
        setupLayout()
        requestTrigger.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshTrigger.accept(())
    }
    
    deinit {
        print("FoodListViewController purple deinit")
    }
    
    func setupLayout() {
        view.addSubview(foodListView)
        view.addSubview(loadingView)
        foodListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = FoodListViewModel.Input(requestTrigger: requestTrigger,
                                            refreshTrigger: refreshTrigger,
                                            actionTrigger: actionTrigger.asObservable())
        let output = viewModel.transform(req: input)
        
        foodListView.setupDI(relay: output.foodList)
        foodListView.setupDI(relay: actionTrigger)
        
        loadingView.setupDI(relay: output.isLoading)
    }
}
