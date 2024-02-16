//
//  ListSesrchBarController.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class ListSesrchBarController: UISearchController {
    let actionRelay = PublishRelay<ListActionType>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    func bindAction() {
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] value in
                self?.actionRelay.accept(.changeKeyWorod(word: value))
            }
            .disposed(by: disposeBag)
    }
    
    
    func setupDI(relay: PublishRelay<ListActionType>) {
        actionRelay.bind(to: relay).disposed(by: disposeBag)
    }
}
