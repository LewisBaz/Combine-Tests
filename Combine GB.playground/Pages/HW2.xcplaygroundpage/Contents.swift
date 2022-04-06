
import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

let numbers = (0...100).publisher
numbers
    .dropFirst(50)
    .prefix(20)
    .filter({ $0 % 2 == 0 })
    //.sink(receiveValue: { print($0) })
    //.store(in: &subscriptions)

var tenRandomNumbers: Set<Int> = []
while tenRandomNumbers.count < 10 {
    let value = Int.random(in: 0 ..< 100)
    tenRandomNumbers.insert(value)
}
let formatter = NumberFormatter()
formatter.numberStyle = .spellOut
tenRandomNumbers.publisher
    .map { formatter.string(for: NSNumber(integerLiteral: $0)) ?? "" }
    .map({ formatter.number(from: $0) })
    .map({ $0! })
    .reduce(0, { $0 + Int($1) / tenRandomNumbers.count })
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
