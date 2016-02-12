//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation

class Presenter: Connectable , MindmapProtocol, DataObserverProtocol{
    
    //MARK : Properties
    static private var presenter : Presenter? = nil;
    //var mindmap:[Node];
    let meteorTracker:MeteorTracker
    let viewDataUtility : ViewDataUtility
    var mindmapId : String?
    
    //MARK : Initializers
    private init(){
        meteorTracker = MeteorTracker.getInstance();
        viewDataUtility = ViewDataUtility();
        //mindmap = [Node]()
    }
    //MARK : Methods
    
    static func getInstance() -> Presenter {
        if(presenter == nil) {
            presenter = Presenter()
        }
        return presenter!;
    }
    
    func connectToServer(mindmapId: String) -> Bool {
        self.mindmapId = mindmapId
        if(meteorTracker.isConnectedToNetwork()) {
            meteorTracker.connectToServer(mindmapId)
            return true
        }
        else {
            return false
        }
    }
    
    func getNodes() -> [Node] {
        //mindmap = meteorTracker.getNodes();
        return meteorTracker.mindmap;
    }
    
    func documentAdded(id: String) {
        viewDataUtility.addDocumentToViewData(id , mindmap: meteorTracker.mindmap);
    }
    func documentChanged(id : String , fields : NSDictionary){
        print("Changed : ", fields)
        
        viewDataUtility.UpdateDocumentToViewData(id, fields: fields)
        
    }
    
    func getNodeCount() -> Int{
       // mindmap = meteorTracker.getMindmap().sorted
        return meteorTracker.mindmap.count
    }
    
    func getNodeAt(index : Int) -> Node{
        return meteorTracker.mindmap[index];
    }
}
