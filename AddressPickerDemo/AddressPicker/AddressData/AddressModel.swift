//
//  AddressModel.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/29.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

class AddressData: NSObject {
    class func getAddressArray()->[ProvinceModel]{
        var tempArray:[ProvinceModel]=[]
        let plistpath = NSBundle.mainBundle().pathForResource("address", ofType: "plist")!
        let listLocation = NSMutableArray(contentsOfFile: plistpath)!
        listLocation.enumerateObjectsUsingBlock { (dict, idx, stop) -> Void in
            let model = ProvinceModel(fromDic: dict as! NSDictionary)
            tempArray.append(model)
        }
        return tempArray
    }
}

class ProvinceModel:NSObject{
    var province:String!
    var cities: [CityModel] = []
    init(fromDic:NSDictionary){
        super.init()
        (fromDic["cities"]as! NSArray).enumerateObjectsUsingBlock { (dict, idx, stop) -> Void in
            let model = CityModel(fromDic: dict as! NSDictionary)
            self.cities.append(model)
        }
        self.province = fromDic["province"] as! String
    }
}

class CityModel:NSObject{
    var city:String!
    var districts: [DistrictModel] = []
    init(fromDic:NSDictionary){
        super.init()
        (fromDic["districts"]as! NSArray).enumerateObjectsUsingBlock { (dict, idx, stop) -> Void in
            let model = DistrictModel(fromDic: dict as! NSDictionary)
            self.districts.append(model)
        }
        self.city = fromDic["city"] as! String
    }
}

class DistrictModel:NSObject{
    var district:String!
    var streets: [String] = []
    init(fromDic:NSDictionary){
        super.init()
        (fromDic["streets"]as! NSArray).enumerateObjectsUsingBlock { (dict, idx, stop) -> Void in
            self.streets.append(dict as! String)
        }
        self.district = fromDic["district"] as! String
    }
}


class AddressModel: NSObject {
    var consigneeName: String!
    var consigneeTelephone: String!
    var province: String!
    var city: String!
    var district: String!
    var street: String!
    var postCode: String!
    var address: String!
}