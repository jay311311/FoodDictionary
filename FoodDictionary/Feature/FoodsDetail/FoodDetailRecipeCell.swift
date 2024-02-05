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
    let labelWidth: CGFloat = 270
    let imageSize: CGFloat = 80
    let margin: CGFloat = 8
    
    lazy var containerView = UIView()
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
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
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.height.equalTo(imageSize + margin + margin)
        }
        
        containerView.addSubview(indexLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(imgView)
        
        indexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin)
            $0.leading.equalToSuperview().inset(10)
        }
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(imageSize)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin)
            $0.leading.equalTo(indexLabel.snp.trailing).inset(-5)
            $0.width.equalTo(labelWidth)
        }
        
        
    }
    
    func configure(index: Int, data: Recipe) {
        contentLabel.text = data.MANUAL
        indexLabel.text = "\(index + 1)"
        if let imageURL = URL(string: data.MANUAL_IMG ) {
            self.imgView.kf.setImage(with: imageURL)
        }
        changeDynamicLabelHeight(text: data.MANUAL)
    }
    
   
    func changeDynamicLabelHeight(text: String) {
        let heightOfContentLabel = self.contentLabel.calculateLabelHeight(maxWidth: labelWidth, fontSize: 17)
        if heightOfContentLabel > imageSize {
            containerView.snp.updateConstraints {
                $0.height.equalTo(heightOfContentLabel + margin + margin)
            }
            contentLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(margin)
                $0.leading.equalTo(indexLabel.snp.trailing).inset(-5)
                $0.trailing.equalTo(imgView.snp.leading).inset(-5)
                $0.width.equalTo(labelWidth)
            }
        }
    }
}
