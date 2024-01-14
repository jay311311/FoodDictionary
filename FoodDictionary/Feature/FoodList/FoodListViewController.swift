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
    let requestTregger = PublishRelay<Void>()
    
    lazy var foodList = FoodListView()
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        bindViewModel()
        setLayout()
        requestTregger.accept(())
    }
    

    deinit {
        print("FoodListViewController purple deinit")
    }
    
    func setLayout() {
        view.addSubview(foodList)
        view.addSubview(loadingView)
        foodList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = FoodListViewModel.Input(trigger: requestTregger)
        let output = viewModel.transform(req: input)

        foodList.setupDI(relay: output.foodList)
        loadingView.setupDI(relay: output.isLoading)
    }

}
