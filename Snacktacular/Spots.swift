//
//  Spots.swift
//  Snacktacular
//
//  Created by Tom Kotopoulos on 3/31/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Spots {
    var spotArray = [Spot]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping ()-> ()){
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("ERROR: Adding the snapshot listner \(String(describing: error))")
                return completed()
            }
            self.spotArray = []
            for document in (querySnapshot!.documents){
                let spot = Spot(dictionary: document.data())
                spot.documentId = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
}
