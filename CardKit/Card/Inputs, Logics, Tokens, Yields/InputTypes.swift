//
//  InputTypes.swift
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

extension CKCoordinate2D: Equatable {}

public func == (lhs: CKCoordinate2D, rhs: CKCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
}

extension CKCoordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
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

extension CKCoordinate3D: Equatable {}

public func == (lhs: CKCoordinate3D, rhs: CKCoordinate3D) -> Bool {
    return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
        && lhs.altitudeMeters == rhs.altitudeMeters
}

extension CKCoordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
        self.altitudeMeters = try json.double("altitudeMeters")
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

//MARK: CardinalDirection

public enum CKCardinalDirection: String {
    case North
    case South
    case East
    case West
}

extension CKCardinalDirection: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .North:
                return "North"
            case .South:
                return "South"
            case .East:
                return "East"
            case .West:
                return "West"
            }
        }
    }
}

extension CKCardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.string()
        if let directionEnum = CKCardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.ValueNotConvertible(value: json, to: CKCardinalDirection.self)
        }
    }
}

extension CKCardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .String(self.description)
    }
}
