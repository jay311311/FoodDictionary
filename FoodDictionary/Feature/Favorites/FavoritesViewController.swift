//
//  FavoritesViewController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FavoritesViewController: UIViewController {

    var viewModel: FavoritesViewModel!
    let requestTrigger = PublishRelay<Void>()
    let actionTrigger = PublishRelay<ListActionType>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        navigationController?.navigationBar.topItem?.title = "Saved"
        navigationController?.navigationBar.prefersLargeTitles = true
        bindViewModel()
        setupLayout()
        requestTrigger.accept(())
    }
    
    lazy var foodListView = FoodListView()
    
    deinit {
        print("FavoritesViewController yellow deinit")
    }
    
    func setupLayout() {
        view.addSubview(foodListView)
        foodListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = FavoritesViewModel.Input(requestTrigger: requestTrigger,
                                            actionTrigger: actionTrigger.asObservable())
        let output = viewModel.transform(req: input)
        
        foodListView.setupDI(relay: output.foodList)
        foodListView.setupDI(relay: actionTrigger)
        
    }
}
