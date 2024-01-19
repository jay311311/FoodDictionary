//
//  FoodListTableCell.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/11.
//

import UIKit
import Kingfisher

class FoodListCell: UICollectionViewCell {
    static let id = "FoodListCell"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        backgroundColor = .yellow
        contentView.addSubview(backgroundImage)
        backgroundImage.layer.addSublayer(darkGradationView)
        contentView.addSubview(titleLabel)

        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func configure(data: Food) {
        self.titleLabel.text = data.RCP_NM
        if let imageURL = URL(string: data.ATT_FILE_NO_MAIN ?? "") {
            self.backgroundImage.kf.setImage(with: imageURL)
        }
        
    }
}
