import SwiftUI

//public struct Essentials {
//    public private(set) var text = "Hello, World!"
//
//    public init() {
//    }
//}


// MARK: - Equatable Array
public extension Array where Element: Equatable {
    
    
    /// Appends element if it already does not exist in the list.
    ///
    /// *Last edited on 12 July 2022 at 19:33.*
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> [Element] {
        if self.contains(element) {
            return self
        } else {
            self.append(element)
            return self
        }
    }
    
    /// A Boolean value indicating whether the **collection has values stored** .
    ///
    /// Returns **false** if the list ==`[]`
    ///
    /// *Last edited on 12 July 2022 at 19:34.*
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    /// *Last modified on 12 July 2022 at 20:12.**
    @discardableResult
    mutating func removeIfNotContains(_ e: Element) -> Array<Element> {
        if self.contains(e) {
            if let index = self.firstIndex(of: e) {
                self.remove(at: index)
            }
        } else {
            self.append(e)
        }
        return self
    }
}

// MARK: - Array of Strings
public extension Array where Element == String {
    /// **Important**
    ///
    /// Does **not** remove empty strings in the list.
    ///
    /// *Last edited on 12 July 2022 at 20:17*
    @discardableResult mutating func trimAll(in: CharacterSet) -> [String] {
        self = self.map { each_string in
            each_string.trimmingCharacters(in: `in`)
        }
        return self
    }
}


// MARK: - String
public extension String {
    /// A Boolean value indicating whether a string has **one or more characters**.
    ///
    /// Returns **false** if a string is `""`.
    ///
    /// *Last edited on 12 July 2022 at 19:34.*
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    // TODO: Test
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

// MARK: - Optional String
public extension Optional where Wrapped == String {
    /// A Boolean value indicating if an **Optional String** is **not** set to `nil` **and** is **not** empty.
    ///
    /// **Acknowledgement**
    ///
    /// This property was inspired from `.isNotNullOrEmpty` property inside Kotlin Nullable String.
    ///
    /// *Last edited on 12 July 2022 at 19:56.*
    var isNotNilOrEmpty: Bool {
        guard let s = self else {
            return false
        }
        
        return !s.isEmpty
    }
}


// MARK: - HTTPMethod
/**
 * A list of common https methods.
 *
 * *Last updated on 22 July 2022 at 22:56.*
 */

public enum HTTPMethod: String {
    @available(*, unavailable, message: "Use URLNetworkSession(urlString: String).get() instead.")
    case get        = "GET"
    case put        = "PUT"
    case delete     = "DELETE"
    case update     = "UPDATE"
    case push       = "PUSH"
    case patch      = "PATCH"
    case copy       = "COPY"
    case link       = "LINK"
    case unlink     = "UNLINK"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case purge      = "PURGE"
    case lock       = "LOCK"
    case unlock     = "UNLOCK"
    case view       = "VIEW"
    case propfind   = "PROPFIND"
}

/**
 Greatly simplifies sending and receiving JSON data to a backend network.
 
 Let's assume we have a `LoginData` class that conforms to `Codable`...
 ```
 struct LoginData: Codable {
    var email: String
    var hash: String
 }
 ```
 ...and you expect to get `LoginResponse` JSON as a response.
 ```
 struct LoginResponse: Codable {
    var token: String
 }
 ```
 
 Using `URLNetworkSession`:
 ```
 let loginData =
    LoginData(email: "example@mail.com", hash: "some_hash")
 
 let (status, loginResponse) =
    URLNetworkSession(urlString: "https://api.backend.net/login/", .GET)
        .send(loginData)
        .expect(LoginResponse.Type)
 ```
 
 Currently this only supports sending and receiving data from the backend. Future releases will add support for web sockets.
 
*Last updated in  13 July 2022 at 17:01.*
 */
@available(iOS 13.0, *)
struct URLNetworkSession {
    // MARK: - NetworkRequestService
    var httpMethod = HTTPMethod.put
    var url: URL
    private var request: URLRequest
    
    /// *Last updated on 22 July at 23:07.*
    init(url: URL, _ httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod
        self.url = url
        self.request = URLRequest(url: url)
    }
    
    /// *Last updated on 22 July at 23:07.*
    init(urlString: String, _ httpMethod: HTTPMethod) throws {
        self.httpMethod = httpMethod
        self.url = URL(string: urlString)!
        self.request = URLRequest(url: url)
    }
    
    /// *Last updated on 23 July at 00:42.*
    init(urlString: String) {
        self.httpMethod = .put
        self.url = URL(string: urlString)!
        self.request = URLRequest(url: url)
    }
    
    /// *Last updated on 22 July at 23:10.*
    mutating func send<T: Encodable>(_ data: T) async throws -> URLNetworkSession {
        self.request = URLRequest(url: self.url)
        self.request.httpMethod = self.httpMethod.rawValue
        self.request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        self.request.httpBody = try JSONEncoder().encode(data)
        return self
    }
    
    
    /// Swift concurrency is only available from iOS 13 which is why this function is only available iOS 13+.
    ///
    /// Set `type` to `nil` of you aren't expecting a response.
    /// ```
    ///         .expect(nil)
    /// ```
    ///
    /// - Returns: Tuple of the status code and the result, if available.
    ///
    /// *Last updated on 22 July at 23:13.*
    func expect<T: Decodable>(_ type: T.Type?) async throws -> (status: Int, result: T?) {
        guard let type = type else {
            let (_, response) = try await URLSession.shared.data(from: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return (status: 500, result: nil)
            }
            return (httpResponse.statusCode, nil)
        }
        let (data, response) = try await URLSession.shared.data(from: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return (status: 500, result: nil)
        }
        return (status: httpResponse.statusCode, result: try JSONDecoder().decode(type, from: data))
    }
    
    /// Sends a GET request to the URL.
    ///
    /// iOS no longer supports sending JSON with GET requests.
    ///
    /// *Last updated on 22 July 2022 at 23:32.*
    func get<T: Decodable>(_ type: T.Type) async throws -> (status: Int, result: T?) {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            return (status: 500, result: nil)
        }
        return (status: httpResponse.statusCode, result: try JSONDecoder().decode(type, from: data))
    }
}


// MARK: - URLSession
@available(iOS 13.0, *)
public extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
    
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}


// MARK: URLNetworkSocket




// MARK: - UIBlurEffect
/// SwiftUI implementation of `UIVisualEffectView`.
///
/// According to Apple's documentations, a `UIVisualEffectView` is "an object that implements some complex visual effects".
@available(iOS 13.0, *)
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect
    
    init(style blurStyle: UIBlurEffect.Style) {
        self.effect = UIBlurEffect(style: blurStyle)
    }
    
    init(effect: UIVisualEffect) {
        self.effect = effect
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

// MARK: HStack
@available(iOS 13.0, *)
public extension HStack {
    /// Distributes each element with equal spaces.
    // TODO: Do
    @available(*, unavailable)
    func equify() {
        
    }
    
}


// MARK: VStack
@available(iOS 13.0, *)
public extension VStack {
    
}

// MARK: ZStack
@available(iOS 13.0, *)
public extension ZStack {
    
}


// MARK: - View
@available(iOS 13.0, *)
public extension View {
    /// Displays views only in certain device types.
    ///
    ///
    /// This modifier comes in handy when trying to make a view appear only on iPhones but not on iPads.
    /// Using `#available` would not work since iPhones and iPads share the same framework.
    ///
    /// **Usage**
    ///
    /// The following code sample makes the text view only available on iPads.
    /// ```
    /// Text("Available only on iPads")
    ///     .available(in: .pad)
    /// ```
    ///
    /// Using the following makes the text view available on iPhones and Macs.
    /// ```
    /// Text("Available on iPhones and Macs")
    ///     .available(in: [.phone, .mac])
    /// ```
    ///
    /// If you'd like to make a view only appear on a certain device (e.g. iPhone 8 and iPhone SE),
    /// a new function `availableIn(devices: [UIDeviceType]` will be added in a future release.
    ///
    /// *Last updated on 12 July 2022 at 23:00.*
    func available(in: UIUserInterfaceIdiom) -> some View {
        self.modifier(AvailabilityViewModifier(in: `in`))
    }
    // MARK: func available(in: idiom)
    
    /// Displays views only in certain device types.
    ///
    /// **Usage**
    ///
    /// The following code sample makes the text view only available on iPads.
    /// ```
    ///  Text("Available only on iPads")
    ///         .available(in: .pad)
    /// ```
    ///
    /// Using the following makes the text view available on iPhones and Macs.
    /// ```
    /// Text("Available on iPhones and Macs")
    ///     .available(in: [.phone, .mac])
    /// ```
    ///
    /// *Last updated on 12 July 2022 at 22:55.*
    func available(in: [UIUserInterfaceIdiom]) -> some View {
        self.modifier(AvailabilityViewModifier(in: `in`))
    }
    // MARK: func available(in: [idiom])
    
    @available(*, unavailable)
    func availableIn(device: [String]) {
        
    }
}

// MARK: - AvailabilityViewModifier
@available(iOS 13.0, *)
struct AvailabilityViewModifier: ViewModifier {
    var `in`: [UIUserInterfaceIdiom] = []
    
    init(in: UIUserInterfaceIdiom) {
        self.in.append(`in`)
    }
    
    init(in: [UIUserInterfaceIdiom]) {
        self.in = `in`
    }
    
    func body(content: Content) -> some View {
        ForEach(`in`, id: \.self) { each_i in
            if UIDevice.current.userInterfaceIdiom == each_i {
                content
            }
        }
    }
}

enum AvailabilityDevice {
    case iPhone(_ model: Availability_iPhoneModel)
    case iPad(_ model: Availability_iPadModel)
}

enum Availability_iPhoneModel: String {
    case iPhone8 = "iPhone 8"
    case iPhoneX = "iPhone X"
}

enum Availability_iPadModel: String {
    case iPadPro_11_2020 = "iPad Pro 11 inch 2020"
    case iPadPro_12_9_2020 = "iPad Pro 12.9 inch 2020"
}