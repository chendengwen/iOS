//
//  CellView.swift
//  Swipe
//
//  Created by Yasuhiro Saigo on 2016/10/23.
//  Copyright © 2016年 YASUHIRO SAIGO. All rights reserved.
//

import JTAppleCalendar

private let preDateSelectable: Bool = true
private let todayColor: UIColor = UIColor.black
private let selectableDateColor: UIColor = .white
private let selectedRoundColor: UIColor = UIColor(hex: 0x2D68A2)

class CellView: JTAppleDayCellView {
    
    @IBOutlet weak var stableBackView: AnimationView!
    @IBOutlet var selectedView: AnimationView!
    @IBOutlet var dayLabel: UILabel!
    
    override func awakeFromNib() {
        //self.stableBackView.layer.cornerRadius = self.frame.height * 0.13
        //self.stableBackView.layer.borderColor = UIColor.white.cgColor
        //self.stableBackView.layer.borderWidth = 0.3
    }
    
    func handleCellSelection(cellState: CellState, date: Date, selectedDate: Date) {
        
        //InDate, OutDate
        if cellState.dateBelongsTo != .thisMonth {
            self.dayLabel.text = ""
            self.isUserInteractionEnabled = false
            self.stableBackView.isHidden = true
        } else if date.isSmaller(to: Date()) && !preDateSelectable {
            self.dayLabel.text = "-"
            self.dayLabel.textColor = UIColor.white
            self.isUserInteractionEnabled = false
            self.stableBackView.isHidden = true
        }else{
            self.stableBackView.isHidden = false
            self.isUserInteractionEnabled = true
            dayLabel.text = cellState.text
            dayLabel.textColor = selectableDateColor
        }
        
        configueViewIntoBubbleView(cellState, date: date)
        
        if date.isEqual(to: Date()) {
            if !cellState.isSelected {
                self.dayLabel.textColor = todayColor
            }
        }
    }
    
    func cellSelectionChanged(_ cellState: CellState, date: Date) {
        if cellState.isSelected == true {
            if self.selectedView.isHidden == true {
                configueViewIntoBubbleView(cellState, date: date)
                self.selectedView.animateWithBounceEffect(withCompletionHandler: {
                })
            }
        } else {
            configueViewIntoBubbleView(cellState, date: date, animateDeselection: true)
        }
    }
    
    fileprivate func configueViewIntoBubbleView(_ cellState: CellState, date: Date, animateDeselection: Bool = false) {
        if cellState.isSelected && self.isUserInteractionEnabled {
            self.selectedView.isHidden = false
            self.selectedView.layer.cornerRadius = self.frame.height * 0.37
            self.selectedView.layer.backgroundColor = selectedRoundColor.cgColor
            self.dayLabel.textColor = .white
        } else {
            if animateDeselection {
                if date.isEqual(to: Date())
                {
                    self.dayLabel.textColor = todayColor
                }else{
                    self.dayLabel.textColor = selectableDateColor
                }
                if self.selectedView.isHidden == false {
                    self.selectedView.animateWithFadeEffect(withCompletionHandler: { () -> Void in
                        self.selectedView.isHidden = true
                        self.selectedView.alpha = 1
                    })
                }
            } else {
                self.selectedView.isHidden = true
            }
        }
    }
}
