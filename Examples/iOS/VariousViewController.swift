//
//  VariousViewController.swift
//  iOS
//
//  Copyright (c) 2017 Michael Choe
//

import SwiftSVG
import UIKit

class VariousViewController: UIViewController {
	@IBOutlet var collectionView: UICollectionView!
	
	struct TableItem {
		let url: URL
		let isDirectory: Bool
		let title: String
		
		init(_ url: URL, title: String, isDirectory: Bool = false) {
			self.isDirectory = isDirectory
			self.url = url
			self.title = title
		}
	}
	
	lazy var collectionViewData: [TableItem] = {
		guard let resourceURL = Bundle.main.resourceURL else { return [TableItem]() }
		
		let allResources = try! FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
		
		return allResources
			.filter { thisURL -> Bool in
				if thisURL.pathExtension == "svg" {
					return true
				}
				return false
			}
			.sorted(by: {
				$0.lastPathComponent.lowercased() < $1.lastPathComponent.lowercased()
			})
			.map { thisURL -> TableItem in
				return TableItem(thisURL, title: thisURL.lastPathComponent)
			}
	}()
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else { return }
		
		let singleVC = segue.destination as? SingleSVGViewController
		let thisItem = collectionViewData[selectedIndexPath.item]
		singleVC?.svgURL = thisItem.url
	}
}

extension VariousViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		collectionViewData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let returnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariousCell", for: indexPath) as! VariousCell
		let thisItem = collectionViewData[indexPath.row]
		let thisView = UIView(svgURL: thisItem.url) { svgLayer in
			svgLayer.resizeToFit(returnCell.bounds)
		}
		returnCell.svgView.addSubview(thisView)
		return returnCell
	}
}

extension VariousViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(withIdentifier: "variousToDetailSegue", sender: self)
		collectionView.deselectItem(at: indexPath, animated: false)
	}
}

extension VariousViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let cellDimension = collectionView.bounds.size.width * 0.45
		return CGSize(width: cellDimension, height: cellDimension)
	}
}
