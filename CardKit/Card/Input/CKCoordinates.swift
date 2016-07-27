//
//  CKCoordinates.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


//MARK: CKCoordinate2D

public struct CKCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension CKCoordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

extension CKCoordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
    }
}

//MARK: CKCoordinate2DPath

public struct CKCoordinate2DPath {
    public let path: [CKCoordinate2D]
    
    public init(path: [CKCoordinate2D]) {
        self.path = path
    }
}

extension CKCoordinate2DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
}

extension CKCoordinate2DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.arrayOf("path", type: CKCoordinate2D.self)
    }
}

//MARK: CKCoordinate3D

public struct CKCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitudeMeters: Double
    
    public init(latitude: Double, longitude: Double, altitudeMeters: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

extension CKCoordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

extension CKCoordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
        self.altitudeMeters = try json.double("altitudeMeters")
    }
}

//MARK: CKCoordinate3DPath

public struct CKCoordinate3DPath {
    public let path: [CKCoordinate3D]
    
    public init(path: [CKCoordinate3D]) {
        self.path = path
    }
}

extension CKCoordinate3DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
}

extension CKCoordinate3DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.arrayOf("path", type: CKCoordinate3D.self)
    }
}
