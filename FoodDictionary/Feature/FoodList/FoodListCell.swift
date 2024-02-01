//
//  FoodListTableCell.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/11.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FoodListCell: UICollectionViewCell {
    static let id = "FoodListCell"
    var disposeBag = DisposeBag()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    lazy var backgroundImage = UIImageView()
    lazy var darkGradationView : CAGradientLayer = {
        let layer  = CAGradientLayer()
        let colors: [CGColor] = [
            .init(red: 0, green: 0, blue: 0, alpha: 0),
            .init(red: 0, green: 0, blue: 0, alpha: 0),
            .init(red: 0, green: 0, blue: 0, alpha: 0.5),
            .init(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        layer.colors = colors
        layer.frame = contentView.bounds
        
        return layer
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        saveBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
    func setupLayout() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(saveBtn)
        
        backgroundImage.layer.addSublayer(darkGradationView)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        
        saveBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
            $0.size.equalTo(25)
        }
    }
    
    func configure(data: Food) {
        self.titleLabel.text = data.RCP_NM
        self.saveBtn.isSelected = data.RCP_SAVE
        if let imageURL = URL(string: data.ATT_FILE_NO_MAIN ?? "") {
            self.backgroundImage.kf.setImage(with: imageURL)
        }
    }
}
