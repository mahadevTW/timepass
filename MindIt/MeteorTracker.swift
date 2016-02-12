//
//  MeteorTracker.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP
import SystemConfiguration

class MeteorTracker: MindMapCollectionDelegate {
    //MARK : Properties
    private let mindmapcollection:MindmapCollection = MindmapCollection(name: "Mindmaps")
    private static var meteorTracker: MeteorTracker? = nil;
    let trackerDelagate : TrackerDelegate
    var mindmap:[Node] = [Node]();
    //MARK : Intialiser
    private init(trackerDelagate : TrackerDelegate) {
        self.trackerDelagate = trackerDelagate;
        var subScriptionSuccessFlag = false
        mindmapcollection.delegate = self
    }
    
    //MARK: Methods
    static func getInstance(trackerDelagate : TrackerDelegate) -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker(trackerDelagate : trackerDelagate);
        }
        return meteorTracker!;
    }
    
    func documentWasAdded() {
        
    }
    
    func getMindmap() -> MindmapCollection {
        return mindmapcollection;
    }
    
    
    func connectToServer(mindmapId: String) -> Bool {
        Meteor.connect(Config.URL) {
        Meteor.subscribe("mindmap" , params: [mindmapId]) {
        self.mindmapSubscriptionIsReady("Connected")
        /*
            Meteor.call("findTree", params: [mindmapId],callback: {(result , error) -> () in
                let count : Int  = (result?.count)!
                //print(" result Id : ", result![0]["_id"] as! String);
                for i in 0...count {
                    
                    //print(" Result " , result![i]["_id"] as! String)
                self.mindmapcollection.addIntialDocument("Mindmaps", id: result![i]["_id"] as! String, fields: result![i] as! NSDictionary);
                    
                    
                }
                print("printing whole Collection :", self.mindmapcollection)
            })
*/
            //print("Subscribing..")
        }
        
     }
        return true;
  }

    
    func mindmapSubscriptionIsReady(result : String) {
        print("Subscribed to mindmap " , mindmap.count);
        trackerDelagate.connected(result)
    }
    
    func getNodes() -> [Node] {
        //return mindmapcollection.sorted;
        return mindmap
    }
    
    func unsubscribe() {
        Meteor.unsubscribe("mindmap")
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
