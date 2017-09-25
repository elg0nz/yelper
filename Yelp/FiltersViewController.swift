//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Gonzalo Maldonado Martinez on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: Any])
}

enum FilterSections: Int {
    case deals = 0, distance, categories
}

class FiltersViewController: UIViewController, UITableViewDataSource, SwitchCellDelegate, FiltersViewControllerDelegate {
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSearchButton(_ sender: Any) {
        var filters = [String: Any]()
        var selectedCategories = [String]()
        var showDeals = false
        var distanceInMiles:Double? = nil

        // TODO: Refactor
        for (indexPath, isSelected) in switchStates {
            if isSelected && indexPath.section == FilterSections.categories.rawValue {
                let category = categories[indexPath.row]
                selectedCategories.append(category["code"]!)
            }

            if isSelected && indexPath.section == FilterSections.distance.rawValue {
                let distance = distances[indexPath.row]
                if (distance["name"] == "auto") {
                    distanceInMiles = nil
                } else {
                    let distanceStr = distance["code"]! as String
                    distanceInMiles = Double(distanceStr)
                }
            }

            if isSelected && indexPath.section == FilterSections.deals.rawValue  {
                let deal = deals[indexPath.row]
                if (deal["code"] == "has_deals") {
                    showDeals = true
                }
            }
        }

        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        filters["deals_filter"] = showDeals
        if distanceInMiles != nil {
            filters["distance_in_miles"] = distanceInMiles
        }

        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!

    var categories: [[String: String]]!
    var deals: [[String: String]]!
    var distances: [[String: String]]!
    var switchStates: [IndexPath: Bool] = [IndexPath: Bool]()
    weak var delegate: FiltersViewControllerDelegate?
    let sections = ["", "Distance", "Categories"] // FIXME: Get these names from the enum.
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = YelpFilters.categories()
        deals = YelpFilters.deals()
        distances = YelpFilters.distances()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell

        switch indexPath.section {
        case FilterSections.deals.rawValue:
            cell.switchLabel.text = deals[indexPath.row]["name"]
            break;
        case FilterSections.categories.rawValue:
            cell.switchLabel.text = categories[indexPath.row]["name"]
            break;
        case FilterSections.distance.rawValue:
            cell.switchLabel.text = distances[indexPath.row]["name"]
            break;
        default:
            cell.switchLabel.text = ""
            break;
        }

        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath] ?? false
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case FilterSections.deals.rawValue:
            return deals.count
        case FilterSections.categories.rawValue:
            return categories.count
        case FilterSections.distance.rawValue:
            return distances.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        if indexPath != nil {
            switchStates[indexPath!] = value
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
