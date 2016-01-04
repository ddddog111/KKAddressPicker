//
//  KKPickerCell.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/30.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

class KKPickerCell: UICollectionViewCell {

    var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        contentLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        contentLabel.font = UIFont.systemFontOfSize(17)
        contentLabel.textColor = UIColor.blackColor()
        contentLabel.textAlignment = NSTextAlignment.Center
        contentLabel.alpha = 0.4
        self.addSubview(contentLabel)
    }
    
    func changeOpacityTo(opacity: CGFloat) {
        contentLabel.alpha = opacity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
