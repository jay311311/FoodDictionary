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
    
    func setLayout(){
        view.addSubview(foodList)
        foodList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = FoodListViewModel.Input(trigger: requestTregger )
        let output = viewModel.transform(req: input)
        foodList.setupDI(relay: output.foodList)
    }

}
