//
//  VariousCell.swift
//  iOS
//
//  Copyright (c) 2017 Michael Choe
//

import UIKit

class VariousCell: UICollectionViewCell {
    @IBOutlet var svgView: UIView!

    override func prepareForReuse() {
        for thisSublayer in svgView.layer.sublayers! {
            thisSublayer.removeFromSuperlayer()
        }
    }
    }
