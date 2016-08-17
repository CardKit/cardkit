# CardKit

Welcome to CardKit. This is the fundamental framework for building IoT applications using a card-based methodology. CardKit defines a number of classes, structs, and protocols to encapsulate the creation and execution of card-based IoT programs.

CardKit is written in Swift and supports macOS, iOS, and tvOS.

CardKit depends on [Freddy](https://github.com/bignerdranch/Freddy) for JSON object serialization & deserialization.

## Card Descriptors & Cards

A `CardDescriptor` represents the information that would appear on a printed card. For example, the image below shows a sample annotated card containing various kinds of information.

![Annotated card](images/card-layout-labeled-v1_1.png)

A `CardDescriptor` contains a host of information used to describe the card:

* **Card Type**: There are five types of cards in CardKit: Action, Deck, Hand, Input, Token. These are described in the Card Types section below.
* **Name**. The name of the card.
* **Path**. Paths are used to group cards with similar functionality, making it easier to find cards when the number of cards is large. Card paths are implemented by the `CardPath` struct.
* **Version**. Version numbers are used to keep track of cards in case a card's metadata ever changes, or we need to support execution of multiple versions of the same card.
* **Asset Catalog**. An Asset Catalog contains information about all assets needed to render the card on screen (e.g. a PNG rendering of the card, textual descriptions, etc.)

A `CardDescriptor` does not contain any information about the *implementation* of the card; rather, it only contains the metadata associated with a card. The mapping between a `CardDescriptor` and it's implementation is managed by the `CardKit Runtime`.

The `Card` protocol, plus a set of associated base classes (`ActionCard`, `DeckCard`, `HandCard`, `InputCard`, and `TokenCard`) are the basis for card instances. A card's *instance* tracks information about how the card is bound to other cards and in which hand a card appears. For example, an `InputCardDescriptor` may specify that an Input card should contain a `Double` value. The corresponding `InputCard` instance would track *which* `Double` was assigned to the Input card (e.g. "5.0").

Card instances use reference semantics (they are classes, not structs). Usually, equality testing using reference semantics resorts to pointer comparison (e.g. do reference A and reference B point to the same memory address). For our purposes, because we want to serialize card programs as JSON, we need an alternative mechanism to specify *which* card instances are being referenced by *other* card instances. For example, an `ActionCard` that is bound to an `InputCard` needs to know which `InputCard` instance to which it is bound. To enable this, all `*Card` instances contain a UUID-based `CardIdentifier`, and instance equality is defined as having matching `CardIdentifier`s.

With the separation of card descriptors and card instances, all *logical* cards require two things to be defined: (1) a `CardDescriptor` (in `CardKit.swift`) and (2) a `Card` instance class that inherits from one of `ActionCard`, `DeckCard`, `HandCard`, `InputCard`, or `TokenCard`.

## Card Types

There are five different types of cards in `CardKit`.

### Action

Action cards are used to perform an action with a physical device. For example, the following card would cause a drone to fly to a specified location.

![FlyTo card image](images/fly-to.png)

`ActionCardDescriptor` defines the base card descriptor for an `ActionCard`. Action cards may accept inputs from other cards (`AcceptsInputs`), they may be bound to `TokenCards` to drive physical activities (`AcceptsTokens`), they may produce data that can be used by other downstream cards (`ProducesYields`), and they may trigger execution state changes (`Satisfiable`).

### Deck

Deck cards are used to modify the execution logic of the Deck, such as ending execution (the default) or repeating the deck.

![Repeat Deck card image](images/repeat-deck.png)

### Hand

Hand cards are used to modify the execution logic of a Hand. Arbitrary Boolean logics are supported with Hand cards, such that a Hand card's own satisfaction is be triggered using a Boolean operation across a subset of `Satisfiable` cards in the hand (note: currently, `CardKit` does not enforce that the logic is applied only to `Satisfiable` cards). Branching and Repetition logic are also handled by Hand cards.

![Repeat Hand card image](images/repeat-hand.png)

### Input

Input cards are used to provide concrete, user-specified inputs to an Action card. An example Input card is shown below.

![Input card image](images/location.png)

Input cards are similar to Action cards in that both produce some piece of data that is used by a card (called a Yield). In the case of Input cards, that data will always be user-specified. In the case of Action cards, that data will be computed based on the side-effects of executing the Action card.

### Token

Token cards represent the physical IoT hardware. Token card implementations (deriving from `TokenCard`) are designed to communicate with IoT hardware to perform the requisite actions as specified by the CardKit program. For example, a `DroneTokenCard` might be created to control a drone. It is the responsibility for the Token card's implementation to perform any actual communication with the drone (or other IoT hardware).

Tokens adhere to the `Consumable` protocol to specify whether their use is consumed by an `ActionCard`. If a token is consumed, it's use by one `ActionCard` prevents its use by another `ActionCard` (e.g. a camera that can only respond to one command at a time). Tokens that are not consumed may be bound to multiple `ActionCard`s in the same hand. Token consumability applies only within the current Hand; a Token that was consumed in a previous hand may be used by a new `ActionCard` in the current hand.

![Camera card image](images/camera.png)

## Execution

Card execution works as shown below.

![Card execution diagram](images/deck-hand-execution.png)

Cards are placed in Hands, and execution flows from the first hand to the last hand.  Cards in a hand are executed in parallel. Hands are executed sequentially. Cards may produce outputs (called Yields) which may be used by cards in subsequent hands. A Deck encapsulates a sequence of Hands, and is considered a single, standalone CardKit program.

Note that `CardKit` only provides facilities for defining the structure of a CardKit program. The [CardKit Runtime](https://github.ibm.com/CMER-card-kit-runtime) provides support for validation and execution of CardKit programs.

## Card Concepts

### Yields

An `ActionCard` may produce some amount of data upon its execution. For example, a card that performs a computation to detect the location of an object in an image may *yield* the location of the object. These yields can then be used as Inputs to downstream cards (defined in later hands).

### End Flag

Cards may execute indefinitely or their execution may halt upon some condition. For example, a card that reads data from a humidity sensor may continuously perform these readings; a card that controls a drone to fly to a particular location may cease execution once the drone has reached that location. These two execution styles are captured by the End Flag.

The End Flag is captured by the `Satisfiable` protocol. A card is considered "satisfied" once its end condition has been met.

Satisfaction of a hand occurs when both of the following conditions are met:

* All `HandCard`s specifying satisfaction logic (i.e. `LogicHandCard` instances) are satisfied
* All `ActionCard`s not bound to a `HandCard` are satisfied

### Slots

Action cards contain a set of `InputSlots` and `TokenSlots` representing "slots" or "sockets" to which Inputs and Tokens may be bound. These slots are statically defined along with the static definition of the card's descriptor. For example, here is how the `Timer` card is defined:

```
/// Descriptor for Timer card
public static let Timer = ActionCardDescriptor(
…
	inputs: [
		InputSlot(identifier: "Duration", type: InputType.SwiftInt, isOptional: false)
	],
…
}
```

Token slots are defined in a similar fashion.

### Binding

Cards are bound to each other when the yields from one card are used as inputs to another. The following bindings are valid:

* `ActionCard` to `ActionCard` – this is a Yield relationship
* `InputCard` to `ActionCard` – this is an Input relationship
* `TokenCard` to `ActionCard` – this is a Token relationship
* Value to `InputCard` – this binds a specific data value (wrapped in an `InputBinding`) to an Input card

The `bind()` methods are implemented generically, enabling any kind of data to be bound to a card. However, there are a few caveats:

* Input slots are specified with the type of data they are expecting. Thus, a type-checking step is performed during binding to ensure that the type of the given data matches the expected type.
* Everything needs to serialize to and from JSON, including input bindings. Because Swift does not currently allow instantiating an instance of a struct from its String type name (e.g. cannot instantiate a struct `Foo` from the string "Foo"), we box the values of bound input using the `InputBinding` enum. This enum contains cases for commonly-used Swift types (Int, Double, Date, Data), as well as some custom structs that may be useful in CardKit (Coordinate2D, Coordinate3D, etc.).

## Hands, Decks & Deck Building

A Hand consists of a set of Cards. Hands may only contain `ActionCard`s and `HandCards`; thus, a Hand may not contain a `DeckCard`. A Hand implicitly contains `InputCards`s , as they are bound to an `ActionCard`. A Hand may not include unbound `InputCard`s.

A Deck is an ordered sequence of Hands. Execution of a Deck will always begin with the first Hand. However, `HandCard`s may alter the execution logic of a Deck (e.g. a `Branch` card may jump to a different hand than the next one in sequence).

As with `Card` instances, `Hand`s contain a UUID-based identifier, enabling references to be made from a branching `HandCard` to another `Hand` in the Deck.

To enable a rapid construction of CardKit programs, we introduce some syntactic sugar using operator overloading. Here is an example of the smallest, complete CardKit program using this syntax.

```
let deck = (
	CardKit.Action.NoAction ==> 
	CardKit.Action.NoAction
)%        
```

The `%` operator is used to "seal" a deck from a sequence of hands.

The `==>` operator is used to specify a sequence of Hands. Note that we are able to produce a `Hand` containing an `ActionCard`, even though we specified `CardKit.Action.NoAction: ActionCardDescriptor`. This behavior is possible because the internal specification of `==>` will create an `ActionCard` instance when given an `ActionCardDescriptor`.

Note that because the `==>` operator takes two operands, we can only use this syntax to specify Decks that contain two or more hands. For a Deck consisting of a single Hand, we recommend using the imperative syntax instead.

```
let deck = Deck()
let hand = Hand()
hand.add(CardKit.Action.NoAction.instance())
deck.add(hand)
```

Input bindings can also be specified using the Deck Builder syntax.


```
let timerCard: ActionCard = CardKit.Action.Trigger.Time.Timer <- CardKit.Input.Time.Duration <- 5
```

Note that `timerCard` is built using `ActionCardDescriptors` and `InputCardDescriptors`. Internally, the `<-` operator is creating an `ActionCard` instance and an`InputCard` instance, it is binding the value "5" to the `InputCard`, and it is binding the `InputCard` to the `ActionCard`.

A Hand containing `HandCard` logic is specified below.

```
let A = CardKit.Action.NoAction.instance()
let B = CardKit.Action.NoAction.instance()
let C = CardKit.Action.NoAction.instance()
let D = CardKit.Action.NoAction.instance()
let E = CardKit.Action.NoAction.instance()
let F = CardKit.Action.NoAction.instance()
let hand = ((A && B) || (C && D)) + E + !F
```

The operators `&&`, `||`, and `!` produce `HandCard`s with the respective Boolean operator, applied to the specified cards. The operator `+` is used to combine cards in a hand (e.g. without adding additional logic cards). Thus, the resulting Hand contains the following cards:

```
A, B, C, D, E, F, AND(A, B), AND(C, D), NOT(F), OR(AND(A, B), AND(C, D))
```

Note that this hand will be considered satisfied when the following conditions are met. Because `E` is not bound to any `HandCard` logic, it is considered in the Hand's satisfaction. Because `A, B, C, D, F` are bound to `HandCard` logic, their individual satisfaction states are ignored.

```
AND(A, B) = Satisfied
AND(C, D) = Satisfied
NOT(F) = Satisfied
OR(AND(A, B), AND(C, D)) = Satisfied
E = Satisfied
```

## Coding Principles

### Serialization

Our intention is for CardKit programs to be specified entirely in JSON to allow for portability across devices. For example, an iOS app may be created to allow a programmer to create a CardKit program. That program ought to be serializable and transferred to a tvOS app which is responsible for it's execution. Thus, many (if not all?) of the structs and classes defined in CardKit are `JSONEncodable` and `JSONDecodable` using the Freddy framework.

### Static Card Descriptors

Card Descriptors encapsulate all of the metadata associated with a card. We statically define the struct `CardKit` to contain descriptors for the entire hierarchy of CardKit cards. For example, the descriptor of the `Angle` card is defined under `CardKit.Input.Location.Angle`. Each descriptor is defined statically because its metadata will not change at run time.

### Separation Between Specification and Runtime

We have an explicit separation between the specification of a CardKit program and its runtime execution. It is the responsibility of the `CardKit Runtime` library to map the Card Descriptors defined in `CardKit.swift` to class implementations that execute the logic for the card.

### Naming

We follow a few naming guidelines in CardKit.

* Protocols are named with verbs according to the abilities they provide. For example, `ProducesYields` makes it clear that the card will produce Yields, and `Executable` makes it clear that the card can be executed.
* We prefer simple noun-based names for concrete concepts. For example, Cards, Hands, and Decks are core concepts in CardKit; thus, their class names are `Card`, `Hand`, and `Deck`.
* We try to use value semantics (structs) wherever possible, although we really want to use inheritance in some places (e.g. `LogicHandCard : HandCard`), so we use classes in those cases. But, because of the Serialization requirement, we use value-like semantics when performing equality testing for these classes (e.g. using `CardIdentifier` and `HandIdentifier`).
* Extensions to Swift types are specified in `Extensions/(Type)Extension.swift`

### Input & Yield Boxing

Due to limitations in Swift reflection, we use an `enum` to box `Input` and `Yield` types. This is because we are not able to instantiate a reference to a type from it's String name, as would be given in the JSON representation of a CardKit program (`NSClassFromName()` does not work for `struct` types).

The box types are defined in `Input.swift` (`Yield.swift` creates a `typealias YieldType = InputType` so the boxing also works with Yields). Common Swift types are supported (`Int`, `Double`, `String`, `NSData`, `NSDate`), plus some additional types that are useful for IoT applications (`CKCoordinate2D`, `CKCoordinate2DPath`, `CKCardinalDirection`, etc.).

## Building

We use Carthage to manage our dependencies. Run `carthage bootstrap` to build all of the dependencies before building the CardKit Xcode project.

## Contributing

If you would like to contribute to CardKit, we recommend forking the repository, making your changes, and submitting a pull request.

## Contact

The authors of CardKit are members of the Center for Mobile Enterprise Research in IBM Research.

* Justin Weisz, jweisz@us.ibm.com
* Justin Manweiler, jmanweiler@us.ibm.com
* Saad Ismail, saad@us.ibm.com

