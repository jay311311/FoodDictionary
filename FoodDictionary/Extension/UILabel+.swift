//
//  UILabel+.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/04.
//

import Foundation
import UIKit


extension UILabel {
    func countLines(of label: UILabel, maxHeight: CGFloat) -> Int {
            guard let labelText = label.text else {
                return 0
            }
            
            let rect = CGSize(width: label.bounds.width, height: maxHeight)
            let labelSize = labelText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
            
            let lines = Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
            return labelText.contains("\n") && lines == 1 ? lines + 1 : lines
       }
    
    func calculateLabelHeight(maxWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let attributedString = NSAttributedString(string: self.text ?? "", attributes: [.font: UIFont.systemFont(ofSize: self.font.pointSize)])
   
        let sizeOfContentLabel = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
        return ceil(sizeOfContentLabel.height)
    }
    

    
}
