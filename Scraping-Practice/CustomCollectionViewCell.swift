//
//  CustomCollectionViewCell.swift
//  Scraping-Practice
//
//  Created by 大西玲音 on 2021/11/01.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var grassView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    func configure(value: Int) {
        let color: UIColor = {
            switch value {
                case 0...5: return .red.withAlphaComponent(0.2)
                case 6...10: return .red.withAlphaComponent(0.4)
                case 11...15: return .red.withAlphaComponent(0.6)
                case 16...20: return .red.withAlphaComponent(0.8)
                default: return .red.withAlphaComponent(1)
            }
        }()
        grassView.backgroundColor = color
        valueLabel.text = String(value)
    }
    
}
