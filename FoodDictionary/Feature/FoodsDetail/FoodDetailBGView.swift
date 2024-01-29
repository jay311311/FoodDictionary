//
//  FoodDetailBGView.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/29.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher


class FoodDetailBGView: UIView {
    let disposeBag = DisposeBag()
    var dataRelay = BehaviorRelay<Food?>(value: nil)
    
    lazy var backgroundView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy var darkGradationView = UIView()
    lazy var darkGradationLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let width = UIScreen.main.bounds.size.width
        let colors: [CGColor] = [
            .init(red: 0, green: 0, blue: 0, alpha: 0),
            .init(red: 0, green: 0, blue: 0, alpha: 0.5),
            .init(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        layer.colors = colors
        layer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        return layer
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
        let width = UIScreen.main.bounds.size.width
        addSubview(backgroundView)
        addSubview(darkGradationView)
        darkGradationView.layer.addSublayer(darkGradationLayer)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.size.equalTo(width)
        }
        darkGradationView.snp.makeConstraints {
            $0.size.equalTo(backgroundView.snp.size)
            $0.bottom.equalTo(backgroundView.snp.bottom)
        }
    }
    
    func setupDI(relay: BehaviorRelay<Food?>) {
        relay.bind(to: self.dataRelay).disposed(by: disposeBag)
    }
    
    func configure() {
        self.dataRelay.bind { [weak self] data in
            if let imageURL = URL(string: self?.dataRelay.value?.ATT_FILE_NO_MK ?? "") {
                self?.backgroundView.kf.setImage(with: imageURL)
            }
        }
    }
    
}
