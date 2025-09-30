//
//  SingleSVGViewController.swift
//  iOS
//
//  Copyright (c) 2017 Michael Choe
//

import SwiftSVG
import UIKit

class SingleSVGViewController: UIViewController {
	@IBOutlet var canvasView: UIView!

	var svgURL = URL(string: "https://openclipart.org/download/181651/manhammock.svg")

	override func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false

		guard let url = svgURL else {
			return
		}

		let svgView = UIView(svgURL: url) { svgLayer in
			svgLayer.resizeToFit(self.canvasView.bounds)
		}
		svgView.backgroundColor = UIColor.blue
		canvasView.addSubview(svgView)
	}
}

extension SingleSVGViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		canvasView
	}
}
