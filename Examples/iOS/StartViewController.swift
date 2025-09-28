//
//  StartViewController.swift
//  iOS
//
//  Copyright (c) 2017 Michael Choe
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    struct StartItem {
        let title: String
        let description: String
        let segueIdentifier: String
        let prepareForSegue: ((UIViewController) -> Void)?

        init(title: String, description: String, segueIdentifier: String, prepareForSegue: ((UIViewController) -> Void)? = nil) {
            self.title = title
            self.description = description
            self.segueIdentifier = segueIdentifier
            self.prepareForSegue = prepareForSegue
        }
    }

    lazy var tableData: [StartItem] = {
        let returnData = [
            StartItem(title: "Examples from GitHub", description: "All the examples on the SwiftSVG GitHub page showing the different interface options", segueIdentifier: "startToGithubSegue"),
            StartItem(title: "Rendering Verifications", description: "Lots of different examples, showing the support for various elements, attributes, and performance. This is the main set used to for visual QA. Tap through to see the selected item full size and zoom in to see the SVG up close.", segueIdentifier: "startToVariousSegue"),
            StartItem(title: "SVGView Example", description: "SVGViewExampleViewController - An example of using the SVGView in Interface Builder ", segueIdentifier: "startToSVGViewSegue"),
            StartItem(title: "Complex Example", description: "Example with complex paths and coloring to stretch the library's performance. It's a 7MB file that's downloaded from the web, so it will take a while to parse, so be patient. Try zooming in.", segueIdentifier: "startToSingleSegue") { destinationVC in
                (destinationVC as! SingleSVGViewController).svgURL = URL(string: "https://openclipart.org/download/280178/CigCardSilverGreyDorkingHen.svg")!
            }
        ]

        return returnData

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let selectedItem = tableData[selectedIndexPath.row]
        segue.destination.title = selectedItem.title
        selectedItem.prepareForSegue?(segue.destination)
    }
    }

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "StartCell") as? StartCell
        let thisItem = tableData[indexPath.row]
        returnCell?.titleLabel.text = thisItem.title
        returnCell?.subtitleLabel.text = thisItem.description
        return returnCell!
    }
    }

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisItem = tableData[indexPath.row]
        performSegue(withIdentifier: thisItem.segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    }
