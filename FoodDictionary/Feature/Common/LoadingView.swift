//
//  LoadingView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/14.
//

import UIKit
import RxRelay
import RxSwift

class LoadingView: UIView {
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: true)
    
    lazy var backgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
      let view = UIActivityIndicatorView(style: .large)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.activityIndicatorView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Dependency Injection
    func setupDI(relay: BehaviorRelay<Bool>) {
        relay.bind(to: self.isLoading).disposed(by: disposeBag)
    }
    
    func configure() {
        self.isLoading.bind { [weak self] bool in
            self?.isHidden = !bool
            bool ? self?.activityIndicatorView.startAnimating() : self?.activityIndicatorView.stopAnimating()
        }
    }
}
