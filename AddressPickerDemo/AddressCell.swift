//
//  AddressCell.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/29.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var line: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        line.image = UIImage.getImageWithColor(UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension UIImage {
    class func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}