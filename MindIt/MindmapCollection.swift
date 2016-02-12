    //
//  MindmapCollection.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP

    protocol MindMapCollectionDelegate {
        func documentWasAdded()
    }
    
class MindmapCollection: MeteorCollection<Node> {
    
    //Mark : Properties
    //let presenter : DataObserverProtocol = Presenter.getInstance()
    //MARK: Initialisers
    var delegate: MindMapCollectionDelegate?
    override init(name: String) {
        super.init(name: name)
    }
    
    // Add Document to Mindmap initially
    /*
    func addIntialDocument(collection : String, id : String, fields :NSDictionary ){
        super.documentWasAdded(collection, id: id, fields: fields)
        
    }
    */
    //MARK : Methods
    override func documentWasAdded(collection: String, id: String, fields: NSDictionary?) {
        super.documentWasAdded(collection, id: id, fields: fields)
        //print("Collection : ", collection)
        let presenter = Presenter.getInstance()
        presenter.documentAdded(id)
        //delegate?.documentWasAdded()
    }
    
    //Delete Will nerver be called (Soft delete)
    override func documentWasRemoved(collection: String, id: String) {
        super.documentWasRemoved(collection, id: id)
        print("Newly Removed")
    }
    
    override func documentWasChanged(collection: String, id: String, fields: NSDictionary?, cleared: [String]?) {
        super.documentWasChanged(collection, id: id, fields: fields, cleared: cleared)
        print("Newly changed " , fields)
        let presenter = Presenter.getInstance()
        presenter.documentChanged(id , fields : fields!)
    }
}