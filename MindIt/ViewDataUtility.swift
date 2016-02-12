//
//  ViewDataUtility.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation
class ViewDataUtility {
    
    //MARK : Properties
   let meteorTracker : MeteorTracker = MeteorTracker.getInstance();
    //MARK :Methods
    
    func loadSubscriptionDataToView(mindmapId : String){ //calls when subscrion is ready , and fills root nodes and firstlevel child to view
        let collection : MindmapCollection = meteorTracker.getMindmap()
        let rootNode : Node = collection.findOne(mindmapId)!
        let leftChildsOfRoot : [String] = rootNode.getLeft();
        let rightChildsOfRoot : [String] = rootNode.getRight();
        
    }
    
    
    
    
    
    func addDocumentToViewData(id : String,mindmap : [Node]){
        if(!meteorTracker.subScriptionSuccessFlag){
            return;
        }
        let collection : MindmapCollection = meteorTracker.getMindmap()
        let node: Node = collection.findOne(id)!
        print("Node arrived.." , node.getName())
        
        if(self.isNodeValidToInsertInViewData(mindmap, newNodeId: id)) {
           meteorTracker.mindmap.append(node)
        }else{
            print("Node is deleted");
        }
    }
    
    func isNodeValidToInsertInViewData(mindmap : [Node] , newNodeId : String) -> Bool{
       
        if(meteorTracker.mindmap.count == 0 /*|| isFirstLevelChild(mindmap,newNodeId: newNodeId)*/ ) { //Node is root node or first arrived or first level child
            print("is root or first level Child")
            return true;
        }
        var flag = false
        outerLoop : for i in 0...mindmap.count-1 {
            let childSubTree : [String] = meteorTracker.mindmap[i].getChildSubtree()
            if(childSubTree.contains(newNodeId)){
                flag = true
                break outerLoop;
            }
        }
        if(flag){
            return true;
        }
        else{
            return false
        }
    }
    func isFirstLevelChild(mindmap : [Node],newNodeId : String) -> Bool{
        let collection : MindmapCollection = meteorTracker.getMindmap()
        let node : Node = collection.findOne(newNodeId)!
        let rootNode : Node = collection.findOne(node.getRootId())!
        let leftChildsOfRoot : [String] = rootNode.getLeft()
        if(leftChildsOfRoot.count != 0 && leftChildsOfRoot.contains(newNodeId)){//check existence in left childs of root.
        return true
        }
        
        let rightChildsOfRoot : [String] = rootNode.getRight()
        if(rightChildsOfRoot.count != 0 && rightChildsOfRoot.contains(newNodeId)){ //check existence in right childs of root.
            return true;
        }
    
        return false;
    }
    
    
    func UpdateDocumentToViewData(id : String, fields : NSDictionary!){
        
         let collection : MindmapCollection = meteorTracker.getMindmap()
        let node : Node = collection.findOne(id)!
        let rootNode : Node = collection.findOne(node.getRootId())!
        let key: String = fields.allKeys.first as! String
        let value : AnyObject = fields.allValues.first!
        
        let allKeys : [String] = (fields.allKeys as NSArray) as! Array
        
        print("All Keys.." , allKeys)
        
            switch (key) {   //change it to if--> as single update can contains multiplshie.. maintain wel sequence as it can matter
        case  "name" :
            updateName(node, value: value as! String);
            break
            
        case "childSubTree":
            updateChildSubTree(node, value: value as! [String])
            break
            
        case  "left" :
            updateLeft(node , value : value as! [String])
            break
        case  "right" :
             updateRight(node , value : value as! [String])
            break
        case  "parentId" :
            updateParentId(node, value : value as! String);
            break
            
            
        default :
            
            break
        }

}
    
    
    func updateName(node : Node, value : String){
        let id : String = node.getId();
        for i in 0...meteorTracker.mindmap.count {
            if(id == meteorTracker.mindmap[i].getId()){
                meteorTracker.mindmap[i].name = node.name;
                return
            }
        }
    }
    
    
    func updateChildSubTree(node : Node, value: [String]){ //works when considers when get deleted, not when repositioned
        let id : String = node.getId();
        let mindmapCount: Int = meteorTracker.mindmap.count
        for i in 0...mindmapCount{
            if(id == meteorTracker.mindmap[i].getId()){
                meteorTracker.mindmap[i].childSubTree = node.childSubTree;
                //Update all childs of node in view
                let childSubtree: [String] = meteorTracker.mindmap[i].childSubTree!
                for j in 0...mindmapCount {
                    if(meteorTracker.mindmap[j].parentId! == id && !childSubtree.contains(meteorTracker.mindmap[j]._id!)){
                        meteorTracker.mindmap.removeAtIndex(j);
                        //Removed node from mindmap, if get orphaned (doesent have link from any node)
                    }
                    
                }
            }
        }

    }
    
    
    func updateLeft(node : Node, value : [String]) {
        
        let id : String = node.getId();
        let mindmapCount: Int = meteorTracker.mindmap.count
        for i in 0...mindmapCount{
            if(id == meteorTracker.mindmap[i].getId()){
                meteorTracker.mindmap[i].left = node.getLeft();
                //Update all childs of node in view
                let leftSubtree: [String] = meteorTracker.mindmap[i].getLeft()
                for j in 0...mindmapCount {
                    if(meteorTracker.mindmap[j].parentId! == id && !leftSubtree.contains(meteorTracker.mindmap[j]._id!)){
                        meteorTracker.mindmap.removeAtIndex(j);
                        //Removed node from mindmap, if get orphaned (doesent have link from any node)
                    }
                    
                }
            }
        }
        

        
    }
    
    func updateRight(node : Node, value : [String]) {
        let id : String = node.getId();
        let mindmapCount: Int = meteorTracker.mindmap.count
        for i in 0...mindmapCount{
            if(id == meteorTracker.mindmap[i].getId()){
                meteorTracker.mindmap[i].right = node.getRight();
                //Update all childs of node in view
                let rightSubtree: [String] = meteorTracker.mindmap[i].getRight()
                for j in 0...mindmapCount {
                    if(meteorTracker.mindmap[j].parentId! == id && !rightSubtree.contains(meteorTracker.mindmap[j]._id!)){
                        meteorTracker.mindmap.removeAtIndex(j);
                        //Removed node from mindmap, if get orphaned (doesent have link from any node)
                    }
                    
                }
            }
        }
        
    }
    
    func updateParentId(node : Node , value : String) {
    // Needs to consider reposition Logic
      
    }
    
}
