//
//  MeteorTracker.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP
import SystemConfiguration

class MeteorTracker {
    //MARK : Properties
    private let mindmap:MindmapCollection = MindmapCollection(name: "Mindmaps")
    private static var meteorTracker: MeteorTracker? = nil;
    let trackerDelagate : TrackerDelagate
    
    //MARK : Intialiser
    private init(trackerDelagate : TrackerDelagate) {
        self.trackerDelagate = trackerDelagate;
    }
    
    //MARK: Methods
    static func getInstance(trackerDelagate : TrackerDelagate) -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker(trackerDelagate : trackerDelagate);
        }
        return meteorTracker!;
    }
    
    func getMindmap() -> MindmapCollection {
        return mindmap;
    }
    
    
    func connectToServer(mindmapId: String) -> Bool {
        Meteor.connect(Config.URL) {
            Meteor.subscribe("mindmap" , params: [mindmapId]) {
                self.mindmapSubscriptionIsReady()
            }
        }
        return true;
    }
    
    func mindmapSubscriptionIsReady() {
        print("Subscribed to mindmap " , mindmap.count);
        trackerDelagate.connected("Connected")
    }
    
    func getNodes() -> [Node] {
        return mindmap.sorted;
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
