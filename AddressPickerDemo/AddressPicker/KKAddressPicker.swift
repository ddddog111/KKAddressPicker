//
//  KKAddressPicker.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/30.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

private let AddressPickerBackgroundColor = UIColor.whiteColor()
private let LineColor = UIColor.grayColor()

protocol AddressPickerDelegate {
    func addressChangeTo(province: String?, city: String?, district: String?,streets:[String])
}

class KKAddressPicker: UIView,KKPickerTableDelegate{
    let addressArray = AddressData.getAddressArray()
    
    var lineHight: CGFloat! = 48
    
    var proviceTable: KKPickerTable!
    var cityTable: KKPickerTable!
    var districtTable: KKPickerTable!
    
    var provinceArray:[String] = []
    var cityArray:[String] = []
    var districtArray:[String] = []
    
    var currentProvince:String?
    var currentCity:String?
    var currentDistrict:String?
    var currentStrees:[String] = []
    
    var delegate:AddressPickerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AddressPickerBackgroundColor
        let leftSpace: CGFloat = frame.width/2-150
        
        for p in addressArray{
            provinceArray.append(p.province)
        }
        if provinceArray.count>0{
            currentProvince = provinceArray[0]
        }
        
        for c in addressArray[0].cities{
            cityArray.append(c.city)
        }
        if cityArray.count>0{
            currentCity = cityArray[0]
        }
        
        for d in addressArray[0].cities[0].districts{
            districtArray.append(d.district)
        }
        if districtArray.count>0{
            currentDistrict = districtArray[0]
        }
        
        let s = addressArray[0].cities[0].districts[0].streets
        if s.count>0{
            currentStrees = s
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        proviceTable = KKPickerTable(frame: CGRectMake(leftSpace, 14, 100, 144), collectionViewLayout: layout)
        proviceTable.setUpDataSource(provinceArray)
        proviceTable.pickerChangeDelegate = self
        self.addSubview(proviceTable)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionViewScrollDirection.Vertical
        cityTable = KKPickerTable(frame: CGRectMake(leftSpace+100, 14, 100, 144), collectionViewLayout: layout2)
        cityTable.setUpDataSource(cityArray)
        cityTable.pickerChangeDelegate = self
        self.addSubview(cityTable)
        
        let layout3 = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        districtTable = KKPickerTable(frame: CGRectMake(leftSpace+200, 14, 100, 144), collectionViewLayout: layout3)
        districtTable.setUpDataSource(districtArray)
        districtTable.pickerChangeDelegate = self
        self.addSubview(districtTable)
        
        let lineOne: UIView = UIView(frame: CGRectMake(leftSpace+32.5, self.frame.height-72-1, 35, 2))
        lineOne.backgroundColor = LineColor
        self.addSubview(lineOne)
        let lineTwo: UIView = UIView(frame: CGRectMake(leftSpace+100+32.5, self.frame.height-72-1, 35, 2))
        lineTwo.backgroundColor = LineColor
        self.addSubview(lineTwo)
        let lineThree: UIView = UIView(frame: CGRectMake(leftSpace+200+32.5, self.frame.height-72-1, 35, 2))
        lineThree.backgroundColor = LineColor
        self.addSubview(lineThree)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultValue(){
        self.delegate?.addressChangeTo(currentProvince, city: currentCity, district: currentDistrict, streets: currentStrees)
    }
    
    func setInit(province:String,city:String,district:String){
        currentProvince = province
        let pIndex = provinceArray.indexOf(province)
        proviceTable.scrollToInitCell(pIndex!)
        
        cityArray.removeAll()
        for c in addressArray[pIndex!].cities{
            cityArray.append(c.city)
        }
        if cityArray.count>0{
            currentCity = cityArray[0]
        }
        cityTable.setUpDataSource(cityArray)
        
        currentCity = city
        let cIndex = cityArray.indexOf(city)
        cityTable.scrollToInitCell(cIndex!)
        
        districtArray.removeAll()
        for d in addressArray[pIndex!].cities[cIndex!].districts{
            districtArray.append(d.district)
        }
        if districtArray.count>0{
            currentDistrict = districtArray[0]
        }
        districtTable.setUpDataSource(districtArray)
        
        currentDistrict = district
        let dIndex = districtArray.indexOf(district)
        districtTable.scrollToInitCell(dIndex!)
        
        currentStrees = addressArray[pIndex!].cities[cIndex!].districts[dIndex!].streets
        
        self.delegate?.addressChangeTo(currentProvince, city: currentCity, district: currentDistrict, streets: currentStrees)
    }
}

extension KKAddressPicker {
    
    func valueChange(toValue value:Int, inView view: KKPickerTable) {
        if  view == proviceTable {
            currentProvince = provinceArray[value]
            
        } else if view == cityTable {
            currentCity = cityArray[value]
        } else {
            if districtArray.count>0 {
                currentDistrict = districtArray[value]
            }
        }
    }
    
    func endOfScroll(inView view: KKPickerTable) {
        if  view == proviceTable {
            let pIndex = provinceArray.indexOf(currentProvince!)
            
            cityArray.removeAll()
            for c in addressArray[pIndex!].cities{
                cityArray.append(c.city)
            }
            cityTable.setUpDataSource(cityArray)
            if cityArray.count>0{
                currentCity = cityArray[0]
                cityTable.scrollToInitCell(0)
            }
            
            districtArray.removeAll()
            for d in addressArray[pIndex!].cities[0].districts{
                districtArray.append(d.district)
            }
            districtTable.setUpDataSource(districtArray)
            if districtArray.count>0{
                currentDistrict = districtArray[0]
                districtTable.scrollToInitCell(0)
            }
            currentStrees = addressArray[pIndex!].cities[0].districts[0].streets
            
        } else if view == cityTable {
            
            let pIndex = provinceArray.indexOf(currentProvince!)
            let cIndex = cityArray.indexOf(currentCity!)
            
            districtArray.removeAll()
            for d in addressArray[pIndex!].cities[cIndex!].districts{
                districtArray.append(d.district)
            }
            if districtArray.count>0{
                currentDistrict = districtArray[0]
                districtTable.scrollToInitCell(0)
            }
            districtTable.setUpDataSource(districtArray)
            
            currentStrees = addressArray[pIndex!].cities[cIndex!].districts[0].streets
        }else{
            let pIndex = provinceArray.indexOf(currentProvince!)
            let cIndex = cityArray.indexOf(currentCity!)
            let dIndex = districtArray.indexOf(currentDistrict!)
            
            currentStrees = addressArray[pIndex!].cities[cIndex!].districts[dIndex!].streets
        }
        self.delegate?.addressChangeTo(currentProvince, city: currentCity, district: currentDistrict, streets: currentStrees)
        self.performSelector("enableTable", withObject: nil, afterDelay: 0.3)
    }
    
    
    func runOfScroll(inView view: KKPickerTable){
        if  view == proviceTable {
            cityTable.userInteractionEnabled = false
            districtTable.userInteractionEnabled = false
        }else if view == cityTable {
            proviceTable.userInteractionEnabled = false
            districtTable.userInteractionEnabled = false
        }else{
            proviceTable.userInteractionEnabled = false
            cityTable.userInteractionEnabled = false
        }
    }
    
    func enableTable(){
        proviceTable.userInteractionEnabled = true
        cityTable.userInteractionEnabled = true
        districtTable.userInteractionEnabled = true
    }
    
    func scrollToNearest() {
        self.proviceTable.viewDisappearScroll()
        self.cityTable.viewDisappearScroll()
        self.districtTable.viewDisappearScroll()
    }
}

