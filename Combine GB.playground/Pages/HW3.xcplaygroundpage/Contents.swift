import Foundation
import Combine

let publisher1 = PassthroughSubject<String, Never>()
let publisher2 = PassthroughSubject<String, Never>()
var publishers = [PassthroughSubject<String, Never>()]//PassthroughSubject<PassthroughSubject<String,Never>, Never>()

let queue = DispatchQueue(label: "Collect")

let subscription = publisher1
    .collect(.byTime(queue, 0.5))
    .map({ $0.map({ $0.unicodeScalars }) })
    .map({ $0.map({ $0[$0.startIndex].value }) })
    .map({ String($0.map({ Character(UnicodeScalar($0)!) })) })
    .sink(receiveValue: { value in
        print(value)
    })

let subscription2 = publisher2
    .debounce(for: .seconds(0.9), scheduler: DispatchQueue.main)
    .share()
    .sink(receiveValue: { value in
        print("😎")
    })

publishers = [publisher1, publisher2]

queue.asyncAfter(deadline: .now() + 0.0, execute: {
    //publishers.send("h")
    publishers.forEach({ $0.send("h") })
})
queue.asyncAfter(deadline: .now() + 0.1, execute: {
    publishers.forEach({ $0.send("e") })
})
queue.asyncAfter(deadline: .now() + 0.2, execute: {
    publishers.forEach({ $0.send("l") })
})
queue.asyncAfter(deadline: .now() + 0.3, execute: {
    publishers.forEach({ $0.send("l") })
})
queue.asyncAfter(deadline: .now() + 0.4, execute: {
    publishers.forEach({ $0.send("o") })
})
queue.asyncAfter(deadline: .now() + 0.5, execute: {
    publishers.forEach({ $0.send("w") })
})
queue.asyncAfter(deadline: .now() + 0.6, execute: {
    publishers.forEach({ $0.send("o") })
})
queue.asyncAfter(deadline: .now() + 0.7, execute: {
    publishers.forEach({ $0.send("r") })
})
queue.asyncAfter(deadline: .now() + 0.8, execute: {
    publishers.forEach({ $0.send("l") })
})
queue.asyncAfter(deadline: .now() + 0.9, execute: {
    publishers.forEach({ $0.send("d") })
})
