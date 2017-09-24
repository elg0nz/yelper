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

class FiltersViewController: UIViewController, UITableViewDataSource, SwitchCellDelegate, FiltersViewControllerDelegate {
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSearchButton(_ sender: Any) {
        var filters = [String: Any]()
        var selectedCategories = [String]()

        for (indexPath, isSelected) in switchStates {
            if isSelected {
                let category = categories[indexPath.row]
                selectedCategories.append(category["code"]!)
            }
        }

        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }

        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!

    var categories: [[String:String]]!
    var switchStates: [IndexPath: Bool] = [IndexPath: Bool]()
    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = YelpCategories().list()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath] ?? false
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
