//
//  InputTypes.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


//MARK: InputCoordinate2D

public struct InputCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension InputCoordinate2D: Equatable {}

public func == (lhs: InputCoordinate2D, rhs: InputCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
}

extension InputCoordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
    }
}

extension InputCoordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

//MARK: InputCoordinate3D

public struct InputCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitudeMeters: Double
    
    public init(latitude: Double, longitude: Double, altitudeMeters: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

extension InputCoordinate3D: Equatable {}

public func == (lhs: InputCoordinate3D, rhs: InputCoordinate3D) -> Bool {
    return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
        && lhs.altitudeMeters == rhs.altitudeMeters
}

extension InputCoordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
        self.altitudeMeters = try json.double("altitudeMeters")
    }
}

extension InputCoordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

//MARK: InputCardinalDirection

public enum InputCardinalDirection: String {
    case North
    case South
    case East
    case West
}

extension InputCardinalDirection: CustomStringConvertible {
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

extension InputCardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.string()
        if let directionEnum = InputCardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.ValueNotConvertible(value: json, to: InputCardinalDirection.self)
        }
    }
}

extension InputCardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .String(self.description)
    }
}
