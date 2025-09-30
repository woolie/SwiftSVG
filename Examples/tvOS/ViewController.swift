//
//  ViewController.swift
//  tvOS
//
//  Copyright (c) 2017 Michael Choe
//

import SwiftSVG
import UIKit

class ViewController: UIViewController {
	@IBOutlet var svgView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		let thisSVGView = UIView(svgNamed: "hawaiiFlowers") { svgLayer in
			svgLayer.resizeToFit(self.svgView.bounds)
		}
		svgView.addSubview(thisSVGView)
	}
}
