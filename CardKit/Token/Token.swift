import Foundation

public protocol Token  {
    var id : String { get }
}

public class ExampleToken : Token {
    public let id : String = "ExampleToken"
}