//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Anh Tuan on 9/21/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    // using enums triggers compilation error:
    // FiltersViewController.ConfigType is not bridged to Objective-C
    // will use strings instead
    enum ConfigType {
        case Segment([String])
        case Switch(String)
        case Dropdown([String])
    }
    
    struct ConfigSection {
        var header = "Title"
        var content = [
            ConfigType.Switch("Open Now"),
            ConfigType.Switch("Hot & New")
        ]
    }

    let sections = [
        ConfigSection(
            header: "Price",
            content: [
                ConfigType.Segment(["a", "b"])
            ]
        ),
        ConfigSection(
            header: "Most Popular",
            content: [
                ConfigType.Switch("Open Now"),
                ConfigType.Switch("Hot & New"),
                ConfigType.Switch("Offering a Deal"),
                ConfigType.Switch("Delivery")
            ]
        ),
        ConfigSection(
            header: "Distance",
            content: [
                ConfigType.Dropdown(["Auto", "1 mi", "2 mi", "5 mi"]),
            ]
        ),
        ConfigSection(
            header: "Sort by",
            content: [
                ConfigType.Dropdown(["Best Match", "Distance", "Highest rated"])
            ]
        ),
        ConfigSection(
            header: "General Features",
            content: [
                ConfigType.Switch("Take-out"),
                ConfigType.Switch("Good for Groups"),
                ConfigType.Switch("Take Reservations")
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].content.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].content[indexPath.row]
        var cell: UITableViewCell
        switch (item) {
        case .Dropdown(let values):
            cell = tableView.dequeueReusableCellWithIdentifier("Dropdown") as UITableViewCell
        case .Segment(let values):
            cell = tableView.dequeueReusableCellWithIdentifier("Segment") as UITableViewCell
        case .Switch(let title):
            cell = tableView.dequeueReusableCellWithIdentifier("Switch") as UITableViewCell
        }
        return cell as UITableViewCell
    }

}
