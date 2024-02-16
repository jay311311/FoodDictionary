//
//  UILabel+.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/02/04.
//

import Foundation
import UIKit


extension UILabel {
    func countLines(maxWidth: CGFloat) -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        let labelTextSize = text.boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
 
    
    func calculateLabelHeight(maxWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let attributedString = NSAttributedString(string: self.text ?? "", attributes: [.font: UIFont.systemFont(ofSize: self.font.pointSize)])
   
        let sizeOfContentLabel = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
        return ceil(sizeOfContentLabel.height)
    }
    
    
}
