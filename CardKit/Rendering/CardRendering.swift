import Foundation

// platform independent stand-in for CGPoint
// CR stands for Card Render
public struct CRPoint {
    public var x: Float
    public var y: Float
    public init() {
        self.x = 0
        self.y = 0
    }
    public init(x: Float, y: Float) {
        // clamp to [0.0, 1.0]
        self.x = CRPoint.clamp(x)
        self.y = CRPoint.clamp(y)
    }
    public static func clamp(v : Float) -> Float {
        return v > 1.0 ? 1.0 : (v < 0.0 ? 0.0 : v)
    }
}

extension CRPoint {
    public static var zero: CRPoint { return CRPoint(x: 0, y: 0) }
    public init(x: Int, y: Int) {
        self.x = CRPoint.clamp(Float(x))
        self.y = CRPoint.clamp(Float(y))
    }
    public init(x: Double, y: Double) {
        self.x = CRPoint.clamp(Float(x))
        self.y = CRPoint.clamp(Float(y))
    }
}

public func ==(lhs: CRPoint, rhs: CRPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

// platform independent stand-in for CGSize
public struct CRSize {
    var width : Float
    var height : Float
    public init() {
        self.width = 0
        self.height = 0
    }
    public init(width: Float, height: Float) {
        self.width = CRSize.clamp(width)
        self.height = CRSize.clamp(height)
    }
    public static func clamp(v : Float) -> Float {
        return v > 1.0 ? 1.0 : (v < 0.0 ? 0.0 : v)
    }
}

extension CRSize {
    public static var zero: CRSize { return CRSize(width: 0, height: 0) }
    public init(width: Int, height: Int) {
        self.width = CRSize.clamp(Float(width))
        self.height = CRSize.clamp(Float(height))
    }
    public init(width: Double, height: Double) {
        self.width = CRSize.clamp(Float(width))
        self.height = CRSize.clamp(Float(height))
    }
}


public protocol CardRenderItem {
    var origin : CRPoint { get set }
    var size : CRSize? { get set }
}

public struct CardRenderImageItem : CardRenderItem {
    public var image : String
    public var origin : CRPoint
    public var size : CRSize?
}

public struct CardRenderTextItem : CardRenderItem {
    public var text : NSAttributedString
    public var origin : CRPoint
    public var size : CRSize?
}

public typealias CardRenderSpec = [CardRenderItem]

public protocol CardRenderer {
    func buildRender(card : CardDesc) -> CardRenderSpec
}

public class InputCardRenderer : CardRenderer {
    public static let defaultInstance = InputCardRenderer()
    
    private init() {
    }
    
    public func buildRender(card : CardDesc) -> CardRenderSpec {
        var render : CardRenderSpec = []
        
        guard let inputCard = card as? InputCardDesc else { return render }
        
        // card background art
        let face = CardRenderImageItem(image: "template-front-input", origin: CRPoint.zero, size: nil)
        render.append(face)
        
        // category text
        let categoryText = CardRenderTextItem(text: NSAttributedString(string: "Input"), origin: CRPoint.zero, size: nil)
        render.append(categoryText)
        
        // title
        let title = CardRenderTextItem(text: NSAttributedString(string: inputCard.id.name), origin: CRPoint.zero, size: nil)
        render.append(title)
        
        // artwork
        let artwork = CardRenderImageItem(image: inputCard.icon, origin: CRPoint.zero, size: CRSize(width: 0.5, height: 0.2))
        render.append(artwork)
        
        return render
    }
}

public class TokenCardRenderer : CardRenderer {
    public static let defaultInstance = TokenCardRenderer()
    
    private init() {
    }
    
    public func buildRender(card : CardDesc) -> CardRenderSpec {
        var render : CardRenderSpec = []
        
        guard let tokenCard = card as? TokenCardDesc else { return render }
        
        // card background art
        let face = CardRenderImageItem(image: "template-front-token", origin: CRPoint.zero, size: nil)
        render.append(face)
        
        // category text
        let categoryText = CardRenderTextItem(text: NSAttributedString(string: "Token"), origin: CRPoint.zero, size: nil)
        render.append(categoryText)
        
        // title
        let title = CardRenderTextItem(text: NSAttributedString(string: tokenCard.id.name), origin: CRPoint.zero, size: nil)
        render.append(title)
        
        // artwork
        let artwork = CardRenderTextItem(text: NSAttributedString(string: tokenCard.icon), origin: CRPoint.zero, size: CRSize(width: 0.5, height: 0.2))
        render.append(artwork)
        
        return render
    }
}

public class ActionCardRenderer : CardRenderer {
    public static let defaultInstance = ActionCardRenderer()
    
    private init() {
    }
    
    public func buildRender(card : CardDesc) -> CardRenderSpec {
        var render : CardRenderSpec = []
        
        guard let actionCard = card as? ActionCardDesc else { return render }
        
        // action cards can be: tech, think, trigger, movement
        
        var faceImage = ""
        var catText = ""
        
        switch actionCard.id.path.description {
        case "Tech":
            faceImage = "template-front-tech"
            catText = "Tech"
        
        case "Think":
            faceImage = "template-front-think"
            catText = "Think"
        
        case "Trigger":
            faceImage = "template-front-trigger"
            catText = "Trigger"
        
        case "Movement":
            faceImage = "template-front-movement"
            catText = "Movement"
            
        default:
            break
        }
        
        // card background art
        let face = CardRenderImageItem(image: faceImage, origin: CRPoint.zero, size: nil)
        render.append(face)
        
        // category text
        let categoryText = CardRenderTextItem(text: NSAttributedString(string: catText), origin: CRPoint.zero, size: nil)
        render.append(categoryText)
        
        // title
        let title = CardRenderTextItem(text: NSAttributedString(string: actionCard.id.name), origin: CRPoint.zero, size: nil)
        render.append(title)
        
        // artwork
        let artwork = CardRenderImageItem(image: actionCard.icon, origin: CRPoint.zero, size: CRSize(width: 0.5, height: 0.2))
        render.append(artwork)
        
        return render
    }
    
}

public class HandCardRenderer : CardRenderer {
    public static let defaultInstance = HandCardRenderer()
    
    private init() {
    }
    
    public func buildRender(card : CardDesc) -> CardRenderSpec {
        var render : CardRenderSpec = []
        
        guard let handCard = card as? HandCardDesc else { return render }
        
        // card background art
        let face = CardRenderImageItem(image: "template-front-hand", origin: CRPoint.zero, size: nil)
        render.append(face)
        
        // category text
        let categoryText = CardRenderTextItem(text: NSAttributedString(string: "Hand"), origin: CRPoint.zero, size: nil)
        render.append(categoryText)
        
        // title
        let title = CardRenderTextItem(text: NSAttributedString(string: handCard.id.name), origin: CRPoint.zero, size: nil)
        render.append(title)
        
        // artwork
        let artwork = CardRenderImageItem(image: handCard.icon, origin: CRPoint.zero, size: CRSize(width: 0.5, height: 0.2))
        render.append(artwork)
        
        return render
    }
}

public class DeckCardRenderer : CardRenderer {
    public static let defaultInstance = DeckCardRenderer()
    
    private init() {
    }
    
    public func buildRender(card : CardDesc) -> CardRenderSpec {
        var render : CardRenderSpec = []
        
        guard let deckCard = card as? DeckCardDesc else { return render }
        
        // card background art
        let face = CardRenderImageItem(image: "template-front-deck", origin: CRPoint.zero, size: nil)
        render.append(face)
        
        // category text
        let categoryText = CardRenderTextItem(text: NSAttributedString(string: "Deck"), origin: CRPoint.zero, size: nil)
        render.append(categoryText)
        
        // title
        let title = CardRenderTextItem(text: NSAttributedString(string: deckCard.id.name), origin: CRPoint.zero, size: nil)
        render.append(title)
        
        // artwork
        let artwork = CardRenderImageItem(image: deckCard.icon, origin: CRPoint.zero, size: CRSize(width: 0.5, height: 0.2))
        render.append(artwork)
        
        return render
    }
}

