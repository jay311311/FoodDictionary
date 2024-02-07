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
        navigationController?.navigationBar.topItem?.title = "Saved"
        navigationController?.navigationBar.prefersLargeTitles = true
        bindViewModel()
        setupLayout()
        requestTrigger.accept(())
    }
    
    lazy var foodListView = FoodListView()
    lazy var emtpyView = EmptyView()

    deinit {
        print("FavoritesViewController yellow deinit")
    }
    
    func setupLayout() {
        view.addSubview(foodListView)
        view.addSubview(emtpyView)

        foodListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emtpyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = FavoritesViewModel.Input(requestTrigger: requestTrigger,
                                            actionTrigger: actionTrigger.asObservable())
        let output = viewModel.transform(req: input)
        
        foodListView.setupDI(relay: output.foodList)
        foodListView.setupDI(relay: actionTrigger)
        
        emtpyView.setupDI(relay: output.isEmptyView)
        
    }
}
