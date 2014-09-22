//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var client: YelpClient!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
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
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.restaurantName.text = "the title section \(indexPath)"
        let restaurant = restaurants[indexPath.row]
        cell.restaurantName.text = String(indexPath.row + 1) + ". " + (restaurant["name"] as String)
        if (restaurant["distance"] != nil) {
            cell.distance.text = restaurant["distance"] as String
        } else {
            cell.distance.text = "? mi"
        }
        if (restaurant["rating"] != nil) {
            let rating = restaurant["rating"] as Int
//            cell.ratings.text = "some stars"
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
        println(strAddress)
        cell.address.text = strAddress
        var imageUrl = restaurant["image_url"] as String
        cell.restaurantImage.setImageWithURL(NSURL.URLWithString(imageUrl))
        return cell as UITableViewCell
    }

}

