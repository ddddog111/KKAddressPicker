//
//  KKPicker.swift
//  AddressPickerDemo
//
//  Created by keke on 16/1/4.
//  Copyright © 2016年 lkk. All rights reserved.
//

import UIKit

private let PickerBackgroundColor = UIColor.whiteColor()
private let LineColor = UIColor.grayColor()

protocol KKPickerViewDelegate {
    func valueChangeTo(value: String)
}

class KKPicker: UIView,KKPickerTableDelegate{

    var lineHight: CGFloat! = 48
    
    var mainTable: KKPickerTable!
    
    var displayArray:[String] = []
    var currentValue:String!
    var delegate:KKPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let leftSpace: CGFloat = frame.width/2-150
        self.backgroundColor = PickerBackgroundColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        mainTable = KKPickerTable(frame: CGRectMake(leftSpace, 14, 300, 144), collectionViewLayout: layout)
        mainTable.pickerChangeDelegate = self
        self.addSubview(mainTable)
        
        
        let line: UIView = UIView(frame: CGRectMake(frame.width/2-60, self.frame.height-72-1, 120, 2))
        line.backgroundColor = LineColor
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpDataSource(value:[String]){
        self.displayArray = value
        mainTable.setUpDataSource(self.displayArray)
        currentValue = displayArray[0]
        self.delegate?.valueChangeTo(currentValue)
    }
}

extension KKPicker {
    
    func valueChange(toValue value:Int, inView view: KKPickerTable) {
        currentValue = displayArray[value]
    }
    
    func endOfScroll(inView view: KKPickerTable) {
        
        self.delegate?.valueChangeTo(currentValue)
    }
    
    func runOfScroll(inView view: KKPickerTable){
        
    }
    
    func scrollToNearest() {
        self.mainTable.viewDisappearScroll()
    }
}
