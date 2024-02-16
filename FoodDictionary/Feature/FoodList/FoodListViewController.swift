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
    let actionTrigger = PublishRelay<ListActionType>()
    
    lazy var searchBar = ListSesrchBarController(searchResultsController: nil)
    lazy var foodListView = FoodListView()
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.searchController = searchBar
        navigationController?.navigationBar.topItem?.title = "Recipe"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        bindViewModel()
        setupLayout()
        requestTrigger.accept(())
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
                                            actionTrigger: actionTrigger.asObservable())
        let output = viewModel.transform(req: input)
        
        foodListView.setupDI(relay: output.foodList)
        foodListView.setupDI(relay: actionTrigger)
        
        loadingView.setupDI(relay: output.isLoading)
        
        searchBar.setupDI(relay: actionTrigger)
    }
}
