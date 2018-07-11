/*:
 To use this playground you should open it in EasyFuture.xcodeproj and build EasyFuture framework.
 */
//: [Previous page](@previous)
import EasyFuture
//: # Quick Start
//: This is a quick example of EasyFuture. If you don't know what is Futures & Promises go to the [Futures page](Futures) and start from beginnig.

//: Traditional way to write asynchronous code:

typealias Chat = (id: String, ownerId: String)
typealias User = (id: String, data: Any)

func loadChatRoom(_ completion: (_ chat: Chat?, _ error: Error?) -> Void) {}
func loadUser(id: String, _ completion: (_ user: User?, _ error: Error?) -> Void) {}

loadChatRoom { chat, error in
    if let chat = chat {
        loadUser(id: chat.ownerId) { user, error in
            if let user = user {
                print(user)
                // owner loaded
            } else {
                // handle error
            }
        }
    } else {
        // handle error
    }
}

//: Same logic but with EasyFuture:

loadChatRoom().flatMap({ chat in
    // chat loaded
    // loading user
    loadUser(id: chat.ownerId)
}).onSuccess { user in
    // user loaded
}.onError { error in
    // handle error
}

func loadChatRoom() -> Future<Chat> {
    
    // create promise
    let promise = Promise<Chat>()
    
    // loading data from api
    let task = URLSession.shared.dataTask(with: URL(string: "http://your.api.com/loadChat")!) { (data, response, error) in
        
        if let data = data, let string = String(data: data, encoding: .utf8) {
            // return result
            promise.success((id: string, ownerId: "ownerId"))
        } else {
            // return error
            promise.error(error!)
        }
    }
    task.resume()
    
    // return future
    return promise.future
}

func loadUser(id: String) -> Future<User> {
    
    // create promise
    let promise = Promise<User>()
    
    // loading user from api
    let task = URLSession.shared.dataTask(with: URL(string: "http://your.api.com/user/\(id)")!) { (data, response, error) in
        
        if let data = data, let string = String(data: data, encoding: .utf8) {
            // return result
            promise.success((id: "id", data: string))
        } else {
            // return error
            promise.error(error!)
        }
    }
    task.resume()
    
    // return future
    return promise.future
}
//: EasyFuture also support functional composition so you can use map(_ :), flatMap(_ :), filter(_ :), recover(_ :), zip(_ :), andThen(_ :) functions. To see more go to [Composition page](Composition).

//: [Next page](@next)
