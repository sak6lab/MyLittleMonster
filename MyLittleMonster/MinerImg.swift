//
//  MinerImg.swift
//  MyLittleMonster
//
//  Created by Saketh D on 7/3/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import Foundation
import UIKit

class MinerImg: UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func playAppearAnimation(){
        self.image = UIImage(named: "appear6.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for x in 1...6{
            if let img = UIImage(named:  "appear\(x).png"){
                imgArray.append(img)
            }
        }
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    func playHideAnimation(){
        self.image = UIImage(named: "hide6.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for x in 1...6{
            if let img = UIImage(named: "hide\(x).png"){
                imgArray.append(img)
            }
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
}
