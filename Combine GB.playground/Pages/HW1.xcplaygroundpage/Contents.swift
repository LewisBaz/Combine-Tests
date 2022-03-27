import Foundation
import Combine

var myName: String = ""

let notification = Notification.Name("MyNotification")
let publisher = NotificationCenter.default
    .publisher(for: notification, object: nil)
let center = NotificationCenter.default
let subscription = publisher
    .sink { value in
        //print("Notification received from publisher")
        myName += value.object as! String
        print(value.object as Any)
    }
center.post(name: notification, object: "L")
center.post(name: notification, object: "E")
center.post(name: notification, object: "V")
subscription.cancel()
print(myName)


enum MyError: Error {
    case test
}

final class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        subscription.request(.max(4))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received value", input)
        return input == "World" ? .max(1) : .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("Received completion", completion) }
}

let subscriber = StringSubscriber()
let subject = CurrentValueSubject<String, MyError>(myName)
subject.subscribe(subscriber)
let subscription1 = subject
    .sink(
        receiveCompletion: { completion in
            print("Received completion (sink)", completion) },
        receiveValue: { value in
            print(subject.value)
            //print("Received value (sink)", value)
        } )
subject.send("Hello")
subject.send("World")
subject.send("Wow")
