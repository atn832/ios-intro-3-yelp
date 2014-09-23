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
    
    // using enums triggers compilation error:
    // FiltersViewController.ConfigType is not bridged to Objective-C
    // will use strings instead
    enum ConfigType {
        case Segment([String])
        case Switch(String)
        case Dropdown([(String, Int?)])
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
        )
    ]
    
    var expanded = [2: true]
    var selected = [2: 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (delegate == nil) {
            return
        }
        delegate.setConfigViewController(self, didFinishEnteringConfig: [
                "sort": 1,
                "radius": 1000,
                "deals": 1
            ])
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
        default:
            println()
        }
    }
}
