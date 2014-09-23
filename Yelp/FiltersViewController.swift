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
    var delegate: ViewControllerFilterDelegate!
    
    // TODO: make isExpanded work for any config type
    
    // show 3 categories before showing See All
    let CategoryCount = 3
    
    // using enums triggers compilation error:
    // FiltersViewController.ConfigType is not bridged to Objective-C
    // will use strings instead
    enum ConfigType {
        case Segment([String])
        case Switch(String)
        case Dropdown([(String, Int?)])
        case Category([(String, String)])
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
                ConfigType.Segment(["$", "$$", "$$$", "$$$$"])
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
                ConfigType.Dropdown([("Auto", nil), ("0.3 miles", 482), ("1 mile", 1609), ("5 miles", 8047), ("20 miles", 32187)])
            ]
        ),
        ConfigSection(
            header: "Sort by",
            content: [
                //Yelp API values: 0=Best matched (default), 1=Distance, 2=Highest Rated.
                ConfigType.Dropdown([("Best Match", 0), ("Distance", 1), ("Rating", 2)])//, "Most Reviewed"]) <== not implemented by Yelp API yet
            ]
        ),
        ConfigSection(
            header: "General Features",
            content: [
                ConfigType.Switch("Take-out"),
                ConfigType.Switch("Good for Groups"),
                ConfigType.Switch("Take Reservations")
            ]
        ),
        ConfigSection(
            header: "Categories",
            content: [
                ConfigType.Category([
                    ("Restaurants", "restaurants"),
                    ("Bars", "bars"),
                    ("Nightlife", "nightlife"),
                    ("Coffee & Tea", "coffee"),
                    ("Gas & Service Stations", "servicestations"),
                    ("Drugstores", "drugstores"),
                    ("Shopping", "shopping"),
                ])
            ]
        )
    ]
    
    var expanded: [Int: Bool] = [:]
    var selected = [2: 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        println("Search")
        if (delegate != nil) {
            // pass config back
            delegate.setConfigViewController(self, didFinishEnteringConfig: [
                "sort": sort,
                "radius": radius,
                "deals": deals
                ], searchString: nil)
        }
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let content = sections[section].content
        if (content.count == 1) {
            switch content[0] {
            case let .Dropdown(options):
                    if (isExpanded(section)) {
                        return options.count
                    }
                    else {
                        return 1
                    }
            case let .Category(options):
                if (isExpanded(section)) {
                    return options.count
                }
                else {
                    // TODO: use max(categorycount, options.count) and have it be expandable or not
                    return CategoryCount + 1 // one for See All
                }
            default:
                return 1
            }
        }
        return sections[section].content.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        var item: ConfigType!
        switch section.content[0] {
        case .Dropdown(let options):
            item = section.content[0]
        case .Category(let options):
            item = section.content[0]
        default:
            item = section.content[indexPath.row]
        }
        var cell: UITableViewCell
        switch (item!) {
        case .Dropdown(let options):
            let selIndex = getSelected(indexPath.section)
            if (isExpanded(indexPath.section)) {
                cell = tableView.dequeueReusableCellWithIdentifier("Switch") as UITableViewCell
                let (label, value) = options[indexPath.row]
                (cell as SwitchTableViewCell).optionName.text = label
                (cell as SwitchTableViewCell).optionSwitch.on = selIndex == indexPath.row
                (cell as SwitchTableViewCell).optionConfig.text = ""
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("Dropdown") as UITableViewCell
                // return selected item
                let (label, value) = options[selIndex]
                (cell as DropdownTableViewCell).optionDropdown.text = label
            }
        case .Category(let options):
            if (isExpanded(indexPath.section)) {
                // show all
                cell = tableView.dequeueReusableCellWithIdentifier("Category") as UITableViewCell
                let (label, value) = options[indexPath.row]
                (cell as CategoryTableViewCell).categoryName.text = label
            }
            else {
                if (indexPath.row == CategoryCount) {
                    // show See All
                    cell = tableView.dequeueReusableCellWithIdentifier("More") as UITableViewCell
                }
                else {
                    let (label, value) = options[indexPath.row]
                    cell = tableView.dequeueReusableCellWithIdentifier("Category") as UITableViewCell
                    (cell as CategoryTableViewCell).categoryName.text = label
                }
            }
        case .Segment(let values):
            cell = tableView.dequeueReusableCellWithIdentifier("Segment") as UITableViewCell
            var i = 0
            for value in values {
                (cell as SegmentTableViewCell).segment.setTitle(value, forSegmentAtIndex: i)
                i++
            }
        case .Switch(let title):
            cell = tableView.dequeueReusableCellWithIdentifier("Switch") as UITableViewCell
            (cell as SwitchTableViewCell).optionName.text = title
            (cell as SwitchTableViewCell).optionConfig.text = ""
            
        }
        return cell as UITableViewCell
    }
    // ideally, would save this in a struct... or use getter/setters
    func isExpanded(section: Int) -> Bool {
        var exp = false
        if (expanded[section] != nil) {
            exp = expanded[section]!.boolValue
        }
        return exp
    }
    
    func setExpanded(section: Int, isExpanded: Bool) {
        expanded[section] = isExpanded
    }
    
    func getSelected(section: Int) -> Int {
        var index = 0
        if (selected[section] != nil) {
            index = selected[section]!
        }
        return index
    }
    
    func setSelected(section: Int, index: Int) {
        selected[section] = index
    }
    
    var sort: Int! {
        get {
            return 1
        }
    }
    
    var radius: Int! {
        get {
            return 1000
        }
    }
    
    var deals: Int! {
        get {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // expand if dropdown
        let section = sections[indexPath.section]
        let item = section.content[0]
        switch (item) {
        case .Dropdown(let options):
            if (!isExpanded(indexPath.section)) {
                // expand
                // could not modify section, even when it was a var... so using getter setters and a dictionary instead
                setExpanded(indexPath.section, isExpanded: true)
            }
            else {
                // select and collapse
                setExpanded(indexPath.section, isExpanded: false)
                setSelected(indexPath.section, index: indexPath.row)
            }
            tableView.reloadData()
        case .Category(let options):
            if (!isExpanded(indexPath.section) && indexPath.row == CategoryCount) {
                // tapped See All
                setExpanded(indexPath.section, isExpanded: true)
                tableView.reloadData()
            }
            else {
                // tapped a Category => pop view and search that string
                if (delegate != nil) {
                    let (label, value) = options[indexPath.row]
                    
                    // pass config back
                    delegate.setConfigViewController(self, didFinishEnteringConfig: [
                        "sort": sort,
                        "radius": radius,
                        "deals": deals,
                        ], searchString: label)
                }
                navigationController?.popViewControllerAnimated(true)
            }
        default:
            return
        }
    }
}
