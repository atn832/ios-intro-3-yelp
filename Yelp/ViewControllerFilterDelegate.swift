//
//  ViewControllerFilterDelegate.swift
//  Yelp
//
//  Created by Anh Tuan on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import Foundation

protocol ViewControllerFilterDelegate {
    func setConfigViewController(controller: FiltersViewController, didFinishEnteringConfig: [String: Int?]) -> Void
}
