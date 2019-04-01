//
//  Spot.swift
//  Snacktacular
//
//  Created by Tom Kotopoulos on 3/31/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class Spot: NSObject, MKAnnotation{
    var name:String
    var address : String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserId: String
    var documentId: String
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var title: String?{
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    var dictionary: [String: Any]{
        return ["name": name, "address": address, "longiude": longitude, "laitude": latitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserId": postingUserId]
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserId: String, documentId: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserId = postingUserId
        self.documentId = documentId
    }
    
    convenience override init(){
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserId: "", documentId: "")
    }
    
    convenience init(dictionary: [String: Any]){
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserId: postingUserID, documentId: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        
        //Grab the User ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("***ERROR: Couldn't save data w/o posting user ID")
            return completed(false)
        }
        self.postingUserId = postingUserID
        
        //Create dictionary
        let dataToSave = self.dictionary
        if self.documentId != ""{
            let ref = db.collection("spots").document(self.documentId)
            ref.setData(dataToSave) { (error) in
                if let error = error{
                    print("ERROR updaing document id \(error.localizedDescription)")
                    completed(false)
                }else{
                    print("Data saved with ref id \(ref.documentID)")
                    completed(true)
                }
            }
        }else{
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave){error in
                if let error = error{
                    print("ERROR creating document id \(error.localizedDescription)")
                    completed(false)
                }else{
                    print("New document created with ref id \(ref?.documentID ?? "unknown")")
                    completed(true)
                }
            }
        }
    }
}
