//
//  WheelCollectionViewLayout.swift
//  WheelMenu
//
//  Created by Roger Serentill Gené on 1/12/17.
//  Copyright © 2017 Roger Serentill. All rights reserved.
//

import UIKit

class WheelCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        
        let copiedAttributes: WheelCollectionViewLayoutAttributes = super.copy(with: zone) as! WheelCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class WheelCollectionViewLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: 70, height: 70)
    
    var increasingScale: CGFloat = 1.25
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    var radius: CGFloat = UIScreen.main.bounds.height > 667 ? 450 : 410 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return CGFloat(15.toRadians)
    }
    
    var attributesList = [WheelCollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        
        let numberOfItems = CGFloat(collectionView!.numberOfItems(inSection: 0))
        
        let arcLengthPerAngle = self.radius * self.anglePerItem * 2 // Radians -> arc length = r*angle (we double it so we can scroll even when all items are shown)
        let arcLength = arcLengthPerAngle * numberOfItems
        let contentWidth = arcLength + itemSize.width/2 + itemSize.width * increasingScale/2
        
        return CGSize(width: contentWidth, height:(collectionView?.bounds.height)!)
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionView!.contentSize.width - collectionView!.bounds.width)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return WheelCollectionViewLayoutAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.collectionView?.numberOfItems(inSection: 0) == 0 ? [] : self.attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return self.attributesList[indexPath.item]
    }
    
    override func prepare() {
        
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2.0
        
        let theta = atan2(collectionView!.bounds.width / 2, radius + (itemSize.height / 2) - (collectionView!.bounds.height / 2))
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        
        if angle < -theta {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        
        if endIndex < startIndex {
            endIndex = 0
            startIndex = 0
        }
        
        self.attributesList = (startIndex...endIndex).map { (i) in
            
            let attributes = WheelCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.center = CGPoint(x: centerX, y: itemSize.height * increasingScale / 2)
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            
            // y = mx + n -> y is the factor we want, m is the slope and x is the alpha
            let alpha: CGFloat = abs(attributes.angle.toDegrees).clamped(to: (1 ... self.anglePerItem.toDegrees))
            let slope = CGFloat(1 - self.increasingScale) / self.anglePerItem.toDegrees
            let factor = slope * alpha + self.increasingScale
            
            let calculatedItemSize = CGSize(width: self.itemSize.width * factor, height: self.itemSize.height * factor)
            
            attributes.size = calculatedItemSize
            
            let anchorPointY = (calculatedItemSize.height / 2 + radius) / calculatedItemSize.height
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            return attributes
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var finalContentOffset = proposedContentOffset
        
        let factor = -angleAtExtreme / (collectionView!.contentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x * factor
        let ratio = proposedAngle / anglePerItem
        
        var multiplier: CGFloat
        
        if velocity.x > 0 {
            multiplier = ceil(ratio)
        }
        else if velocity.x < 0 {
            multiplier = floor(ratio)
        }
        else {
            multiplier = round(ratio)
        }
        
        finalContentOffset.x = multiplier * anglePerItem / factor
        
        return finalContentOffset
    }
}
