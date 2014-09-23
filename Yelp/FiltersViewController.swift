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
        case Dropdown([(String, Int?)], Int, Bool)
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
//                ConfigType.Dropdown(["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]),
                ConfigType.Dropdown([("Auto", nil), ("0.3 miles", 482), ("1 mile", 1609), ("5 miles", 8047), ("20 miles", 32187)], 1, true)
            ]
        ),
        ConfigSection(
            header: "Sort by",
            content: [
                //Yelp API values: 0=Best matched (default), 1=Distance, 2=Highest Rated.
                ConfigType.Dropdown([("Best Match", 0), ("Distance", 1), ("Rating", 2)], 0, false)//, "Most Reviewed"]) <== not implemented by Yelp API yet
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
    
    override func viewWillDisappear(animated: Bool) {
        if (delegate == nil) {
            return
        }
        delegate.setConfigViewController(self, didFinishEnteringConfig: "hello")
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
            case let .Dropdown(options, selIndex, expanded):
                    if (expanded) {
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
        println("\(indexPath.section),\(indexPath.row)")
        
        let section = sections[indexPath.section]
        var item: ConfigType!
        switch section.content[0] {
        case .Dropdown(let options, let selIndex, let expanded):
            item = section.content[0]
        default:
            item = section.content[indexPath.row]
        }
        var cell: UITableViewCell
        switch (item!) {
        case .Dropdown(let options, let selIndex, let expanded):
            if (expanded) {
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

}
