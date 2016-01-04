//
//  ViewController.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/29.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var mainTable: UITableView!
    
    var address = AddressModel()
    var editField:UITextField!
    var isScroll = false
    
    var streetArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.mainTable.registerNib(UINib(nibName: "AddressCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AddressCell")
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveAction(sender: AnyObject) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
        cell.textField.delegate = self
        switch indexPath.row{
        case 0:
            cell.textField.placeholder = "收货人姓名"
            cell.textField.enabled = true
            cell.textField.text = address.consigneeName
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 1:
            cell.textField.placeholder = "联系电话"
            cell.textField.enabled = true
            cell.textField.keyboardType = UIKeyboardType.NumberPad
            cell.textField.text = address.consigneeTelephone
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 2:
            cell.textField.placeholder = "邮政编码"
            cell.textField.enabled = true
            cell.textField.keyboardType = UIKeyboardType.NumberPad
            cell.textField.text = address.postCode
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 3:
            var addressStr = ""
            if (self.address.province != nil){
                addressStr.appendContentsOf(self.address.province)
            }
            if (self.address.city != nil){
                addressStr.appendContentsOf(self.address.city)
            }
            if (self.address.district != nil){
                addressStr.appendContentsOf(self.address.district)
            }
            if addressStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)>0{
                cell.textField.text = addressStr
            }
            else{
                cell.textField.text = "省、市、区"
            }
            cell.textField.enabled = false
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        case 4:
            if (self.address.street != nil){
                cell.textField.text = self.address.street
            }else{
                cell.textField.text = "街道"
            }
            cell.textField.enabled = false
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        case 5:
            cell.textField.placeholder = "详细地址"
            cell.textField.enabled = true
            cell.textField.text = address.address
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        default:break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 3{
            
            if((self.editField) != nil){
                self.editField.resignFirstResponder()
            }
            
            //省市区
            let pickerView = KKAddressPickerView(result: { (province, city, district, streets) -> Void in
                self.address.province = province
                self.address.city = city
                self.address.district = district
                self.streetArray = streets
                self.mainTable.reloadData()
                
            })
            if (self.address.province != nil){
                pickerView.addressPicker.setInit(self.address.province, city: self.address.city, district: self.address.district)
            }else{
                pickerView.addressPicker.defaultValue()
            }
            pickerView.show()
        }
        if indexPath.row == 4{
            if self.streetArray.isEmpty{
                KKAlertView(title: "暂无街道地址",message:"请选择省市区后继续",buttonTitle:"确定",isNormal:true,action: { () -> Void in
                    print("确定")
                }).show()
                return
            }
            
            if((self.editField) != nil){
                self.editField.resignFirstResponder()
            }
            //街道
            let pickerView = KKPickerView(result: { (value) -> Void in
                self.address.street = value
                self.mainTable.reloadData()
                
            })
            pickerView.picker.setUpDataSource(streetArray)
            pickerView.show()
        }
    }
    
    // MARK: -UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.scrollToTextFiled(textField)
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.mainTable.setContentOffset(CGPointMake(0, 0), animated: true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.editField = textField
        self.scrollToTextFiled(textField)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        var cell = textField.superview
        if !(cell is UITableViewCell){
            cell = cell!.superview
        }
        if !(cell is UITableViewCell){
            cell = cell!.superview
        }
        let indexPath = mainTable.indexPathForCell(cell as! UITableViewCell)!
        if(indexPath.row == 0){
            self.address.consigneeName = textField.text
        }
        if(indexPath.row == 1){
            self.address.consigneeTelephone = textField.text
        }
        if(indexPath.row == 2){
            self.address.postCode = textField.text
        }
        if(indexPath.row == 5){
            self.address.address = textField.text
        }
    }
    // MARK: UITableView-scroll
    func scrollToTextFiled(textField:UITextField){
        isScroll = true
        
        var cell = textField.superview
        if !(cell is UITableViewCell){
            cell = cell!.superview
        }
        if !(cell is UITableViewCell){
            cell = cell!.superview
        }
        let indexPath = mainTable.indexPathForCell(cell as! UITableViewCell)!
        if indexPath.row == 5{
            mainTable.setContentOffset(CGPointMake(0, CGFloat(200)), animated: true)
        }
        
        let delayInSeconds = 0.5;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.isScroll = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isScroll && self.editField != nil){
            self.editField.resignFirstResponder()
        }
    }
}



