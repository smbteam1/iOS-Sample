//
//  ToolBar.swift
//  MyCircle
//
//  Created by Newagesmb/ArunM on 9/6/18.
//  Copyright © 2018 Newagesmb/ArunM. All rights reserved.
//

import UIKit

protocol ToolDoneAction {
    func didPressDoneBtn()
}

class ToolBar: UIToolbar {

    var doneDelegate: ToolDoneAction!
    
    class func instanceFromNib() -> ToolBar {
        return UINib(nibName: "ToolBar", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ToolBar
    }
    @IBAction func doneAction(_ sender: Any) {
        if doneDelegate != nil {
            doneDelegate.didPressDoneBtn()
        }
    }
    
}
