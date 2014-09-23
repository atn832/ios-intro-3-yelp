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
//        case Dropdown([String])
        case Dropdown([String: Int?])
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
                ConfigType.Dropdown(["Auto": nil, "0.3 miles": 482, "1 mile": 1609, "5 miles": 8047, "20 miles": 32187])
            ]
        ),
        ConfigSection(
            header: "Sort by",
            content: [
                //Yelp API values: 0=Best matched (default), 1=Distance, 2=Highest Rated.
                ConfigType.Dropdown(["Best Match": 0, "Distance": 1, "Rating": 2])//, "Most Reviewed"]) <== not implemented by Yelp API yet
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
