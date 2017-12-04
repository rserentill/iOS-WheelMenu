//
//  ViewController.swift
//  WheelMenu
//
//  Created by Roger Serentill Gené on 1/12/17.
//  Copyright © 2017 Roger Serentil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var semiCircleView: UIView!
    @IBOutlet weak var wheelMenuCollectionView: UICollectionView!
    @IBOutlet weak var selectedItemLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    // MARK: - Class attributes
    
    var items: [WheelItem]!
    var selectedItem: WheelItem! {
        didSet {
            self.selectedItemLabel.text = selectedItem.title
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .darkBlue
        
        self.drawSemiCircle()
        
        let userItem = WheelItem(id: 1, icon: #imageLiteral(resourceName: "User"), title: "User")
        let gearItem = WheelItem(id: 2, icon: #imageLiteral(resourceName: "Gear"), title: "Gear")
        let pinItem = WheelItem(id: 3, icon: #imageLiteral(resourceName: "Pin"), title: "Pin")
        let graphItem = WheelItem(id: 4, icon: #imageLiteral(resourceName: "Graph"), title: "Graph")
        let planeItem = WheelItem(id: 5, icon: #imageLiteral(resourceName: "Plane"), title: "Plane")
        
        self.items = [userItem, gearItem, pinItem, graphItem, planeItem]
        
        if self.selectedItem == nil {
            
            self.selectedItem = userItem
        }
        
        self.wheelMenuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    // MARK: Helpers
    
    private func drawSemiCircle() {
        
        let layout = self.wheelMenuCollectionView.collectionViewLayout as! WheelCollectionViewLayout
        let halfItemHeight = layout.itemSize.height * layout.increasingScale / 2
        let circleCenter = CGPoint(x: self.view.bounds.midX, y: self.wheelMenuCollectionView!.bounds.origin.y + layout.radius + halfItemHeight)
        let start = CGFloat.pi
        let end: CGFloat = 0.0
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: layout.radius, startAngle: start, endAngle: end, clockwise: true)
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        
        self.semiCircleView.backgroundColor = UIColor.lightBlue.withAlphaComponent(0.2)
        self.semiCircleView.layer.mask = circleShape
    }
}


// MARK: - CollectionView Delegate & DataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wheel Item Cell", for: indexPath) as! WheelMenuCollectionViewCell
        cell.item = self.items[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = collectionView.collectionViewLayout as! WheelCollectionViewLayout
        
        // Calculate item offset
        let maxContentOffset = collectionView.contentSize.width - collectionView.bounds.width
        let itemAngle = CGFloat(indexPath.item) * layout.anglePerItem
        let offsetX = (itemAngle / -layout.angleAtExtreme) * maxContentOffset
        
        let item = self.items[indexPath.item]
        
        if item.id == self.selectedItem.id {
            guard let itemTitle = item.title else { return }
            self.actionLabel.text = "\(itemTitle) tapped!"
            
            self.actionLabel.alpha = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                UIView.animate(withDuration: 1.0) {
                    self.actionLabel.alpha = 0.0
                }
            })
        }
        
        // Move item to the center
        if self.items.count > 1 {
            collectionView.setContentOffset(CGPoint(x: offsetX, y:0), animated: true)
        }
    }
}

// MARK: - UIScrollView Delegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let maxOffset = scrollView.bounds.width - scrollView.contentSize.width
        let maxIndex = CGFloat(self.items.count - 1)
        let offsetIndex = maxOffset / maxIndex
        
        let currentIndex = Int(round(-scrollView.contentOffset.x / offsetIndex)).clamped(to: (0 ... self.items.count-1))
        
        if self.items[currentIndex].id != self.selectedItem.id {
            self.selectedItem = self.items[currentIndex]
        }
        
    }
}

