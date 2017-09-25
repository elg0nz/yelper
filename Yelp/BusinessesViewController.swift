//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var businesses: [Business]!
    let searchBar = UISearchBar()
    var term: String = "Restaurant"

    func addSearchBar() {
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        searchBar.backgroundColor = self.navigationBar.backgroundColor
        searchBar.delegate = self
        searchBar.text = self.term
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 125
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSearchBar()
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
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

    // MARK: - Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty || searchText.count < 3) {
            self.term = "Restaurant"
            self.searchBar.text = self.term
        }
        searchBusinesses(categories: nil, deals: false)
    }

    func searchBusinesses(categories: [String]?, deals: Bool) {
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

    // MARK: - Filters
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        print(filters)
        let categories = filters["categories"] as? [String]
        let deals = filters["deals_filter"] ?? false
        self.searchBusinesses(categories: categories, deals: deals as! Bool)
    }
}
