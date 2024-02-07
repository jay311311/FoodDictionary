//
//  EmptyView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2/6/24.
//

import UIKit
import RxRelay
import RxSwift

class EmptyView: UIView {

    let disposeBag = DisposeBag()
    let isEmptyView = BehaviorRelay<Bool>(value: true)
    
    lazy var backgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    lazy var containerView = UIView()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.slash.fill")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        label.text = "저장된 요리가 없어요.\n 새로운 요리를 저장해 주세요"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(backgroundView)
        self.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.top.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    // MARK: Dependency Injection
    func setupDI(relay: BehaviorRelay<Bool>) {
        relay.bind(to: self.isEmptyView).disposed(by: disposeBag)
    }
    
    func configure() {
        self.isEmptyView.bind { [weak self] bool in
            self?.isHidden = !bool
        }
        .disposed(by: disposeBag)
    }
}
