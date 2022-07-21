#  String

#### `isNotEmpty: Bool`
A Boolean value indicating whether a string has one or more characters.
```
let emptyString = ""
print(emptyString.isNotEmpty)
// false

let nonEmptyString = "spread the word"
print(nonEmptyString.isNotEmpty)
// true
```

#### `isNotNilOrEmpty: Bool`
##### ⚠️ Only available with optional (a.k.a. nullable) strings

```
let optionalString: String? = nil
print(optionalString.isNotNilOrEmpty)
// false

let emptyString: String? = ""
print(emptyString.isNotNilOrEmpty)
```

#### `-String: String`
Reverses the string and returns it.

```
let someString = "fork"
print(-someString)
// krof

var initialString = "star"
initalString = -initialString
print(initialString)
// rats 
```
