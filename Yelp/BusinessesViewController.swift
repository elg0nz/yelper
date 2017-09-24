//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var businesses: [Business]!
    let searchBar = UISearchBar()

    func addSearchBar() {
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        searchBar.backgroundColor = self.navigationBar.backgroundColor
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 125
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSearchBar()
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
             self.tableView.reloadData()
            }
        })

        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
         self.businesses = businesses
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessTableViewCell") as! BusinessTableViewCell
        let business = businesses[indexPath.row]
        cell.setData(business: business)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses != nil {
            return self.businesses.count
        }
        return 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        var categories = filters["categories"] as? [String]
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }
}
