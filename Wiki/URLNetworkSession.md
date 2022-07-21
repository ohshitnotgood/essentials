#  URLNetworkSession

`URLNetworkSession` is a new class (not an extension of an existing Swift class)
that enables developers to connect to their backend API using the new concurrency
features available in Swift 5.5.

### GET requests
Since iOS 13, Swift does not allow sending JSON data with GET requests. 
Therefore, GET requests are sent differently, as shown below:
```
let session = URLNetworkSession(urlString: "https://google.com/")
                    .get(LoginResult.Type)
                    
print(session.status)
// 200

print(session.result)
// LoginResult(userId: "some-user-id")

```

### PUT, PUSH, DELETE, all the other available options requests
```
let json = LoginData(username: "username", password: "password")
let session = await URLNetworkSession(urlString: "https://google.com/", .put)
                    .body(json)
                    .expect(LoginResult.Type)
                    .send()
```


### Initializing with a URL object and HTTP Method
```
let url = URL(string: "https://www.google.com/")!
let session = URLNetworkSession(url)

```
