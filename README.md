# KKAddressPicker
Custom Picker for Chinese Address

包括省、市、区、街道（镇）

## demo Screenshot

<p><img src="https://raw.githubusercontent.com/keke1201/KKAddressPicker/master/ScreenShot/1.png" alt="ActionSheet_normal" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAddressPicker/master/ScreenShot/2.png" alt="ActionSheet_oneBtn" width="150" />


## Installation

Drag `AddressPicker` group to your project.

## How to use

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
        

    //街道
            let pickerView = KKPickerView(result: { (value) -> Void in
                self.address.street = value
                self.mainTable.reloadData()
                
            })
            pickerView.picker.setUpDataSource(streetArray)//街道数组
            pickerView.show()
        
        
        