//
//  FoodDetailRecipeCell.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/29.
//

import UIKit
import SnapKit
import Kingfisher

class FoodDetailRecipeCell: UITableViewCell {
    static let id = "FoodDetailRecipeCell"
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.baselineAdjustment = .none
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(80)
        }
        contentView.addSubview(indexLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imgView)
        
        indexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(10)
        }
        imgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(80)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(indexLabel.snp.trailing).inset(-5)
            $0.trailing.equalTo(imgView.snp.leading).inset(-5)
            $0.width.equalTo(270)
        }
        
        
    }
    
    func configure(index: Int, data: Recipe) {
        contentLabel.text = data.MANUAL
        indexLabel.text = "\(index + 1)"
        if let imageURL = URL(string: data.MANUAL_IMG ?? "") {
            self.imgView.kf.setImage(with: imageURL)
        }
    }
    
}
