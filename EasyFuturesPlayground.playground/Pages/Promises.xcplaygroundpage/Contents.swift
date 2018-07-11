/*:
 To use this playground you should open it in EasyFutures.xcodeproj and build EasyFutures framework.
 */
//: [Previous page](@previous)
import UIKit
import EasyFutures
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Promises
//: Promises use to write functions that returns Futures.
//: Promise contains Future instance and can complete it.
let promise = Promise<String>()
promise.future // future

promise.complete(.value("value")) // can be completed with .value(value) or .error(error)
//: All ways to complete Future in Promise:
let value = "value"
let error = NSError(domain: "", code: -1, userInfo: nil)

promise.complete(.value(value))

promise.complete(.error(error))

promise.success(value)

promise.error(error)
//: # Examples
//: # #1
func loadData() -> Future<String> {
    
    // create promise with String type
    let promise = Promise<String>()

    // make some async operations
    DispatchQueue.global().async {

        if let data = data() {
            promise.success(data)
        } else {
            promise.error(NSError(domain: "", code: -1, userInfo: nil)) // some error
        }
    }
    // return future
    return promise.future
}

func data() -> String? {
    return "a lot of data"
}

loadData().onSuccess { data in
    print(data)
}.onError { error in
    print(error)
}
//: # #2
class ViewController: UIViewController {
    
    let dataManager = DataManager()
    let label = UILabel(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.loadData().onSuccess { data in
            DispatchQueue.main.async {
                self.label.text = data
            }
        }.onError { error in
            print(error)
            // handle error
        }
    }
}

class DataManager {
    
    func loadData() -> Future<String> {
        
        // create promise with String type
        let promise = Promise<String>()
        
        // check is url valid
        guard let url = URL(string: "https://api.github.com/emojis") else {
            // handle error
            promise.error(ExampleError.invalidUrl)
            return promise.future
        }
        
        // loading data from url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                // return result
                promise.success(string)
            } else {
                // handle error
                promise.error(ExampleError.cantLoadData)
            }
        }
        task.resume()
        
        // return future
        return promise.future
   }
}

enum ExampleError: Error {
    case invalidUrl
    case cantLoadData
}

//: [Next page](@next)
