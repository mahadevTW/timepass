//
//  Mindmap.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 08/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP

class Node: MeteorDocument {
    
    //MARK : Properties
    var _id : String?
    var collection:String = "Mindmaps"
    var parentId:String?
    var position:String?
    var rootId:String?
    var left:[String]?
    var right:[String]?
    var name:String?
    var childSubTree:[String]?
    var index:Int?
    var depth : Int?
    var directionToggler : Bool?
    
    //MARK : Initialiser
    required init(id: String, fields: NSDictionary?) {
        super.init(id: id, fields: fields)
        _id = id
    }
    
    //mark : Added new Code
    override func setValue(value: AnyObject?, forKey key: String) {
        switch(key) {
        case "_id" :
           _id = value as? String
            break
            
        case "parentId":
            parentId = value as? String;
            break
            
        case "position":
            position = value as? String;
            break
            
        case "rootId":
            rootId = value as? String;
            break
            
        case "left":
            left = value as? [String];
            break
            
        case "right":
            right = value as? [String];
            break
            
        case "name":
            name = value as? String;
            break
            
        case "childSubTree":
            childSubTree = value as? [String];
            break
        case "index":
            index = value as? Int;
            break
        default:
            print("No Such element found : " , key);
        }
    }
    func getName() -> String {
        return self.name!
    }
    func getChildSubtree() -> [String] {
        return self.childSubTree!
    }
    func getRootId() -> String {
        return self.rootId!
    }
    func getLeft() -> [String] {
        return self.left!
    }
    func getRight() -> [String] {
        return self.right!
    }
    func getId() -> String {
        return self._id!
    }
    func getDepth() -> Int {
        return self.depth!
    }
    func getDirectionToggler() -> Bool{
        return directionToggler!
    }
}
