//
//  User-extension.swift
//  Crouded
//
//  Created by Richard Fickling on 12/20/14.
//  Copyright (c) 2014 App Builders Inc. All rights reserved.
//

import Foundation

extension User {
    class func enter(email: String, success: (User) -> (), failure: (NSError) -> ()) {
        APIManager.post("/user", params: ["email": email],
            success: { data in
                let points = data["points"]! as UInt
                let timeSaved = data["time_saved"]! as UInt
                let totalTimeSaved = data["total_time_saved"]! as UInt
                let registrationDate = NSDate(timeIntervalSince1970: data["registration_date"]! as Double)
                let stats = Stats(points: points, timeSaved: timeSaved, totalTimeSaved: totalTimeSaved, registrationDate: registrationDate)
                
                
                let homeLocation = data["home_location"] as? [String: Double]
                let workLocation = data["work_location"] as? [String: Double]
                
                let user = User(email: email, stats: stats, home: homeLocation, work: workLocation, locked: false)
                return success(user)
            },
            failure: failure
        )
    }
    
    func refreshIncentives() { // checks to refresh every five minutes
        let commute = self.myCommute
        if !locked {
            APIManager.get("/incentives/\(self.email)", params: ["from": commute.atHomeOrAtWork() ? "home" : "work"],
                success: { data in
                    self.myIncentives.times.removeAll(keepCapacity: false)
                    let incentives = []//data["incentives"]! as [[String: AnyObject]]
                    self.myIncentives.times = incentives
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: IncentivesChangedNotification, object: nil))
                    
                }, failure: { error in
                    println(error)
            })
        }
        
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.refreshIncentives()
        })*/
    }
    
    @objc func postLocations(success: () -> (), failure: (NSError) -> ()) {
        let params = [
            "home_location": [
                "latitude": self.homeLocation.y,
                "longitude": self.homeLocation.x
            ],
            "work_location": [
                "latitude": self.workLocation.y,
                "longitude": self.homeLocation.x
            ]
        ]
        APIManager.post("/user/\(self.email)/locations", params: params, success: { data in
            success()
        }, failure: failure)
    }
}