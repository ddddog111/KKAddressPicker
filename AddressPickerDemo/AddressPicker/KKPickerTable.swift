//
//  KKPickerTable.swift
//  AddressPickerDemo
//
//  Created by lkk on 15/12/30.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

protocol KKPickerTableDelegate {
    func valueChange(toValue value:Int, inView view: KKPickerTable)
    func runOfScroll(inView view: KKPickerTable)
    func endOfScroll(inView view: KKPickerTable)
}

class KKPickerTable: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    var dataToDisplay: NSArray!
    var firstLoad = true
    var initRow: Int = 0
    var lineHight: CGFloat = 48
    var topValue: Int = 0
    var pickerChangeDelegate: KKPickerTableDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.registerClass(KKPickerCell.self, forCellWithReuseIdentifier: "PickerCell")
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.clearColor()
        dataToDisplay = []
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KKPickerTable {
    
    func setUpDataSource(data: NSArray) {
        dataToDisplay = data
        topValue = data.count - 1
        self.reloadData()
    }
    
    func setTop(value: Int) {
        topValue = value
    }
    
    func checkValueDisplay() {
        let currentIndex = self.getCurrentIndex()
        
        if  currentIndex?.row > self.topValue {
            let indexPath = NSIndexPath(forRow: self.topValue, inSection: 0)
            self.scrollToTargetCell(indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PickerCell", forIndexPath: indexPath) as! KKPickerCell
        
        cell.contentLabel.text = dataToDisplay[indexPath.row] as? String
        
        if (firstLoad == true && indexPath.row == initRow) {
            cell.changeOpacityTo(1.0)
            firstLoad = false
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //justify the collection cell size
        return CGSizeMake(self.frame.width, lineHight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        //fix the size of collection view display
        return UIEdgeInsetsMake(lineHight, 0, lineHight, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        //no line space
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        //no cell space
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //scroll to center of cell when select one of the cell
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollToTargetCell(getCurrentIndex())
        self.checkValueDisplay()
        self.pickerChangeDelegate?.endOfScroll(inView: self)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToTargetCell(getCurrentIndex())
            self.checkValueDisplay()
            self.pickerChangeDelegate?.endOfScroll(inView: self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateContentHeighLight()
        self.pickerChangeDelegate?.runOfScroll(inView: self)
    }
    
    func scrollToTargetCell(index: NSIndexPath?) {
        //get current index
        let indexPath = index
        //scroll to that cell if it exist
        if  indexPath != nil {
            self.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
        }
    }
    
    func scrollToInitCell(row: Int) {
        //scroll to init cell with value
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        self.firstLoad = true
        self.initRow = row
        self.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
        self.updateContentHeighLight()
    }
    
    func getCurrentIndex() -> NSIndexPath? {
        //when scroll end get the current display off set
        let visibleStartPoint = self.contentOffset
        //calculate the center point in view
        let selectionPoint = CGPointMake(self.frame.width/2, visibleStartPoint.y + self.frame.height/2)
        //get the index path in center position
        let indexPath = self.indexPathForItemAtPoint(CGPointMake(selectionPoint.x, selectionPoint.y))
        return indexPath
    }
    
    func updateContentHeighLight() {
        //get current index
        let indexPath = getCurrentIndex()
        //change the value if get the index
        if indexPath != nil {
            let row = indexPath?.row
            if  row <= self.topValue {
                self.pickerChangeDelegate?.valueChange(toValue: row!, inView: self)
            }
            
            for cell in self.visibleCells() as! [KKPickerCell]{
                let cellIndex: NSIndexPath = self.indexPathForCell(cell)!
                if  indexPath?.row == cellIndex.row {
                    cell.changeOpacityTo(1.0)
                } else if cellIndex.row > self.topValue {
                    cell.changeOpacityTo(0.2)
                } else if cellIndex.row <= self.topValue {
                    cell.changeOpacityTo(0.4)
                }
            }
        } else {
            
        }
    }
    
    func viewDisappearScroll() {
        let indexPath = self.getCurrentIndex()
        if indexPath != nil {
            self.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
            let row = indexPath?.row
            self.pickerChangeDelegate?.valueChange(toValue: row!, inView: self)
            
            for cell in self.visibleCells() as! [KKPickerCell]{
                let cellIndex: NSIndexPath = self.indexPathForCell(cell)!
                if  indexPath?.row == cellIndex.row {
                    cell.changeOpacityTo(1.0)
                } else if cellIndex.row > self.topValue {
                    cell.changeOpacityTo(0.2)
                } else if cellIndex.row <= self.topValue {
                    cell.changeOpacityTo(0.4)
                }
            }
        } else {
            
        }
    }
}