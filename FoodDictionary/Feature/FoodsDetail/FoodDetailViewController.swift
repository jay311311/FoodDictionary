//
//  FoodDetailViewController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    var viewModel: FoodDetailViewModel!
    
    deinit {
        print("FoodDetailViewController green deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

}
