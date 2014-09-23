//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerFilterDelegate {
    var client: YelpClient!
    @IBOutlet weak var searchField: UITextField!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    @IBOutlet weak var tableView: UITableView!
    var restaurants: [NSDictionary]! = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        search(nil, radius: nil, deals: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(105.0) // Does not work?...
        
        search(nil, radius: nil, deals: nil)
    }
    
    func search(sort: YelpClient.Sort?, radius: Int?, deals: Bool?) {
        let term = searchField.text!
        client.searchWithTerm(term, sort: sort, radius: radius, deals: deals, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            var errorValue: NSError? = nil
            
            if (response != nil) {
                self.restaurants = (response as NSDictionary)["businesses"] as [NSDictionary]
            }
            //            self.networkErrorLabel.hidden = data != nil
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell") as RestaurantTableViewCell
        let restaurant = restaurants[indexPath.row]
        let name = restaurant["name"] as String
        cell.restaurantName.text = String(indexPath.row + 1) + ". " + name
        if (restaurant["distance"] != nil) {
            cell.distance.text = restaurant["distance"] as String
        } else {
            cell.distance.text = "? mi"
        }
        if (restaurant["rating"] != nil) {
            let rating = restaurant["rating"] as Int
            cell.ratings.text = String(rating) + "star(s)"
        } else {
            cell.ratings.text = "? stars"
        }
        let reviewCount = restaurant["review_count"] as Int
        cell.reviewCount.text =  String(reviewCount) + " review(s)"
        let location = restaurant["location"] as NSDictionary
        let address = location["address"] as [String]
        var strAddress = ""
        for word in address {
            strAddress += word
        }
        cell.address.text = strAddress
        var imageUrl = restaurant["image_url"] as String
        cell.restaurantImage.setImageWithURL(NSURL.URLWithString(imageUrl))
        
        return cell as UITableViewCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as FiltersViewController
        destinationViewController.delegate = self
    }
    
    func setConfigViewController(controller: FiltersViewController, didFinishEnteringConfig: [String: Int?], searchString: String?) -> Void {
        println("set config", didFinishEnteringConfig)
        
        if let str = searchString {
            searchField.text = str
        }
        
        let c = didFinishEnteringConfig
        var deals = false
        if let d = c["deals"] {
            deals = d == 1
        }
        var sort: YelpClient.Sort! = nil
        if let s = c["sort"] {
            sort = YelpClient.Sort.fromRaw(s!)
        }
        search(sort, radius: c["radius"]!, deals: deals)
    }
}

