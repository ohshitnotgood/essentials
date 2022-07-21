# Array

## isNotEmpty: Bool
A Boolean value indicating whether the **collection contains any values** stored within.
```
let array = []
print(array.isNotEmpty)
// false

let array = ["hello world"]
print(array.isNotEmpty)
// true
```

## removeIfNotContains() -> Array<Element>


## removeFirstInstanceOf() -> Array<Element>
Removes the first apperance of the element. All subsequent occurances of the element are not removed.
```
var list = ["Penny", "Leonard", "Rajesh", "Howard", "Sheldon", "Penny"]
list.removeFirstInstanceOf("Penny")
print(list)
// ["Leonard", "Rajesh", "Howard", "Sheldon", "Penny"]
```

### Returns:
- list with the first occurance of the element removed. 

The list is mutated and the return value is discardable.


# Array containing Strings

## trimAll(in: CharacterSet) -> [String]

```
var array = [" ", " hello world "]
array.trimAll(in: .whitespaces)
print(array)
// ["", "hello world"]
```

### Parameters:
- `in: CharacterSet`: A `CharacterSet` is a built-in Swift enum that denotes... Learn more at [Insert Apple doc link]


## caseInsensitiveRemoveDuplicates() -> [String]
Removes repeating elements, regardless of their text case.

To remove repeating elements with respect to text case, use `.removeDuplicates`.

```
var list = ["First", "Repeated", "repeated"]
list.caseInsensitiveRemoveDuplicates()
print(list)

// ["First", "Repeated"]
```
