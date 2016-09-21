//
//  InputTypes.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


// MARK: CKCoordinate2D

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
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
    }
}

extension CKCoordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

// MARK: CKCoordinate3D

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
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitudeMeters = try json.getDouble(at: "altitudeMeters")
    }
}

extension CKCoordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

// MARK: CardinalDirection

public enum CKCardinalDirection: String {
    case north
    case south
    case east
    case west
}

extension CKCardinalDirection: CustomStringConvertible {
    public var description: String {
        switch self {
        case .north:
            return "north"
        case .south:
            return "south"
        case .east:
            return "east"
        case .west:
            return "west"
        }
    }
}

extension CKCardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.getString()
        if let directionEnum = CKCardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.valueNotConvertible(value: json, to: CKCardinalDirection.self)
        }
    }
}

extension CKCardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .string(self.description)
    }
}
