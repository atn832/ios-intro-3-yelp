//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    enum Sort: Int {
        case Best = 0
        case Distance = 1
        case Rating = 2
    }
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, sort: Sort?, radius: Int?, deals: Bool?, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = [
            "term": term,
            "location": "San Francisco",
            "cll": "37.77493,-122.419415" // hardcoding the location does not seem to work
        ]
        if (sort != nil) {
            parameters["sort"] = String(sort!.toRaw())
        }
        if (radius != nil) {
            parameters["radius"] = String(radius!)
        }
        // does not seem to be working
        if (deals != nil) {
            if (deals!) {
                parameters["deals"] = "1"
            }
            else {
                parameters["deals"] = "0"
            }
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}


