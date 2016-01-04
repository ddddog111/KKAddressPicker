//
//  KKPickerView.swift
//  AddressPickerDemo
//
//  Created by keke on 16/1/4.
//  Copyright © 2016年 lkk. All rights reserved.
//

import UIKit

private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

private let KKPickerHeight = CGFloat(172)


typealias KKPickerAction = (value:String)->Void

class KKPickerView: UIView,KKPickerViewDelegate{

    let windowFrame = UIScreen.mainScreen().bounds
    var mainView:UIView!
    var picker:KKPicker!
    var tempWindow:KKPickerTempWindow!
    var resultAction:KKPickerAction!

    init(result:KKPickerAction){
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
        
        picker = KKPicker(frame: CGRectMake(0, 0, ScreenWidth, KKPickerHeight))
        picker.delegate = self
        mainView.addSubview(picker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func valueChangeTo(value: String) {
        self.resultAction(value:value)
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
