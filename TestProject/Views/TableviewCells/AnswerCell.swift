//
//  AnswerCell.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 5/3/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var answerTitleLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var answerLblHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
