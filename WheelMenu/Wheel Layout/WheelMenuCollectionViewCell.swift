//
//  WheelMenuCollectionViewCell.swift
//  WheelMenu
//
//  Created by Roger Serentill Gené on 1/12/17.
//  Copyright © 2017 Roger Serentill. All rights reserved.
//

import UIKit

class WheelMenuCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgorundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Class attributes
    
    var item: WheelItem = WheelItem() {
        
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Object lifecycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        
        self.backgorundView.backgroundColor = .middleBlue
        
        self.backgorundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.backgorundView.layer.shadowRadius = 4.0
        self.backgorundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.backgorundView.layer.shadowOpacity = 0.1
    }
    
    override func didMoveToSuperview() {
        
        self.backgorundView.layer.cornerRadius = self.bounds.width / 2
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        self.backgorundView.layer.cornerRadius = self.backgorundView.bounds.width / 2
        
        let circularLayoutAttributes = layoutAttributes as! WheelCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
        self.backgorundView.transform = CGAffineTransform(rotationAngle: -circularLayoutAttributes.angle)
    }
    
    // MARK: - Helpers
    
    func updateUI() {
        
        self.iconImageView.image = self.item.icon
    }
}
