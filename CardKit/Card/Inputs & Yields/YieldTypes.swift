//
//  YieldTypes.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


//MARK: YieldCoordinate2D

public struct YieldCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension YieldCoordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
    }
}

extension YieldCoordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

//MARK: YieldCoordinate2DPath

public struct YieldCoordinate2DPath {
    public let path: [YieldCoordinate2D]
    
    public init(path: [YieldCoordinate2D]) {
        self.path = path
    }
}

extension YieldCoordinate2DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.arrayOf("path", type: YieldCoordinate2D.self)
    }
}

extension YieldCoordinate2DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
}

//MARK: YieldCoordinate3D

public struct YieldCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitudeMeters: Double
    
    public init(latitude: Double, longitude: Double, altitudeMeters: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

extension YieldCoordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.double("latitude")
        self.longitude = try json.double("longitude")
        self.altitudeMeters = try json.double("altitudeMeters")
    }
}

extension YieldCoordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

//MARK: YieldCoordinate3DPath

public struct YieldCoordinate3DPath {
    public let path: [YieldCoordinate3D]
    
    public init(path: [YieldCoordinate3D]) {
        self.path = path
    }
}

extension YieldCoordinate3DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.arrayOf("path", type: YieldCoordinate3D.self)
    }
}

extension YieldCoordinate3DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
}

//MARK: YieldCardinalDirection

public enum YieldCardinalDirection: String {
    case North
    case South
    case East
    case West
}

extension YieldCardinalDirection: CustomStringConvertible {
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

extension YieldCardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.string()
        if let directionEnum = YieldCardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.ValueNotConvertible(value: json, to: YieldCardinalDirection.self)
        }
    }
}

extension YieldCardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .String(self.description)
    }
}
