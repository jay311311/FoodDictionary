//
//  FoodListView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/11.
//

import UIKit
import RxRelay
import RxSwift

class FoodListView: UIView {
    let disposeBag = DisposeBag()
    let dataRelay = BehaviorRelay<[Food]>(value: [])
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.register(FoodListTableCell.self, forCellReuseIdentifier: FoodListTableCell.id)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dependency Injection
    func setupDI(relay: BehaviorRelay<[Food]>) {
        relay.bind(to: self.dataRelay).disposed(by: disposeBag)
    }

    func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTableView() {
        dataRelay.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { table, row, item in
                guard let cell = table.dequeueReusableCell(withIdentifier: FoodListTableCell.id) as? FoodListTableCell else { return UITableViewCell() }
                cell.configure(data: item)
                return cell
            }.disposed(by: disposeBag)
    }

}
