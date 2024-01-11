//
//  FoodListViewController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import UIKit

class FoodListViewController: UIViewController {

    var viewModel: FoodListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        viewModel.getData()
    }
    

    deinit {
        print("FoodListViewController purple deinit")
    }

}
