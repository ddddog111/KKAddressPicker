//
//  KKAddressPickerView.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/30.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

private let KKPickerHeight = CGFloat(172)

class KKPickerTempWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias KKAddressPickerAction = (province:String,city:String,district:String,streets:[String])->Void

class KKAddressPickerView: UIView,AddressPickerDelegate{
    let windowFrame = UIScreen.mainScreen().bounds
    var mainView:UIView!
    var addressPicker:KKAddressPicker!
    var tempWindow:KKPickerTempWindow!
    var resultAction:KKAddressPickerAction!
    
    var currentProvince:String?
    var currentCity:String?
    var currentDistrict:String?
    var currentStreets:[String] = []
    
    
    init(result:KKAddressPickerAction){
        super.init(frame: windowFrame)
        self.resultAction = result
        
        let bgBtn = UIButton(frame: self.bounds)
        bgBtn.backgroundColor = UIColor.clearColor()
        bgBtn.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bgBtn)
        
        mainView = UIView()
        self.mainView.frame = CGRectMake(0.0, ScreenHeight, ScreenWidth,KKPickerHeight)
        self.mainView.backgroundColor = UIColor.whiteColor()
        self.addSubview(mainView)
        
        addressPicker = KKAddressPicker(frame: CGRectMake(0, 0, ScreenWidth, KKPickerHeight))
        addressPicker.delegate = self
        mainView.addSubview(addressPicker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addressChangeTo(province: String?, city: String?, district: String?, streets: [String]) {
        resultAction(province:province!,city:city!,district:district!,streets:streets)
    }
    
    func show() {
        if tempWindow == nil {
            tempWindow = KKPickerTempWindow(frame: windowFrame)
        }
        
        if tempWindow.hidden {
            tempWindow.hidden = false
        }
        
        tempWindow.addSubview(self)
        tempWindow.makeKeyAndVisible()
        
        tempWindow.alpha = 0
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.mainView.frame = CGRectMake(0.0, ScreenHeight-KKPickerHeight, ScreenWidth,KKPickerHeight)
            self.tempWindow.alpha = 1
            }, completion: nil)
    }
    
    func dismiss() {
        tempWindow.alpha = 1
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.mainView.frame = CGRectMake(0.0, ScreenHeight, ScreenWidth,KKPickerHeight)
            
            self.tempWindow.alpha = 0
            }) { (completion) -> Void in
                self.removeFromSuperview()
                self.tempWindow.hidden = true
                self.tempWindow.alpha = 1
        }
    }
}
