# 🔥 Calid - Lua Schema Validation Resource

Calid is a **Lua library** designed for **schema validation**. It provides a set of tools to validate data structures, ensuring they meet specific requirements. This library is particularly useful for validating configurations, user inputs, or any structured data in Lua.

---

## 🚀 Features

- ✅ Validate primitive types like **strings**, **numbers**, and **booleans**.
- 🛠️ Support for **complex types** like arrays and objects.
- ✨ Customizable **error messages**.
- 📦 Built-in support for common patterns like **email**, **URL**, and **UUID** validation.
- 🔄 Flexible options for **optional**, **nullable**, and **default values**.

---

## 📦 Installation

To enable the library inside your resource, add `@calid/init.lua` as a `shared_script` in your `fxmanifest.lua` file:

```lua
shared_scripts {
  '@calid/init.lua',
}
```

---

## 🛠️ Usage

### Basic Example

```lua
-- Validate a string
local stringValidator = calid:string("Invalid string")
local result, err = stringValidator:parse("Hello World")
if not result then
    print(err)
end

-- Validate a number
local numberValidator = calid:number():min(10):max(100)
local result, err = numberValidator:parse(50)
if not result then
    print(err)
end

-- Validate an object
local objectValidator = calid:object({
    name = calid:string():min(3),
    age = calid:number():positive()
})
local result, err = objectValidator:parse({ name = "John", age = 25 })
if not result then
    print(err)
end
```

### Advanced Example

```lua
local calid = require("calid")

-- Custom error messages
local emailValidator = calid:string():email("Invalid email address")
local result, err = emailValidator:parse("example@domain.com")
if not result then
    print(err)
end

-- Enum validation
local enumValidator = calid:enum({ "red", "green", "blue" })
local result, err = enumValidator:parse("yellow")
if not result then
    print(err)
end

-- Array validation
local arrayValidator = calid:array(calid:number():positive()):min(1):max(5)
local result, err = arrayValidator:parse({ 1, 2, 3 })
if not result then
    print(err)
end
```

---

## 📖 Additional Examples for Each Method

### `calid:literal(value, message?)`
```lua
local literalValidator = calid:literal("fixedValue", "Value must be 'fixedValue'")
local result, error = literalValidator:parse("fixedValue")
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:boolean(message?)`
```lua
local booleanValidator = calid:boolean("Value must be a boolean")
local result, error = booleanValidator:parse(true)
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:number(message?)`
```lua
local numberValidator = calid:number("Value must be a number"):positive():int()
local result, error = numberValidator:parse(42)
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:string(message?)`
```lua
local stringValidator = calid:string("Value must be a string"):min(5):max(10)
local result, error = stringValidator:parse("Hello")
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:enum(values, message?)`
```lua
local enumValidator = calid:enum({ "apple", "banana", "cherry" }, "Value must be one of the specified options")
local result, error = enumValidator:parse("banana")
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:object(fields, messageType?, messageObject?)`
```lua
local objectValidator = calid:object({
    username = calid:string():min(3),
    password = calid:string():min(8),
    age = calid:number():positive()
}, "Invalid object structure")
local result, error = objectValidator:parse({ username = "user1", password = "password123", age = 30 })
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

### `calid:array(itemValidator, messageType?, messageArray?)`
```lua
local arrayValidator = calid:array(calid:number():positive(), "Invalid array structure")
local result, error = arrayValidator:parse({ 1, 2, 3, 4 })
-- result: true, error: nil
if not result then
    print(error) -- This will not print anything since the validation passes.
end
```

---

## ❌ Error Examples for Each Method

### `calid:literal(value, message?)`
```lua
local literalValidator = calid:literal("fixedValue", "Value must be 'fixedValue'")
local result, error = literalValidator:parse("wrongValue")
-- result: false, error: "Value must be 'fixedValue'"
if not result then
    print(error) -- Output: Value must be 'fixedValue'
end
```

### `calid:boolean(message?)`
```lua
local booleanValidator = calid:boolean("Value must be a boolean")
local result, error = booleanValidator:parse(123)
-- result: false, error: "Value must be a boolean"
if not result then
    print(error) -- Output: Value must be a boolean
end
```

### `calid:number(message?)`
```lua
local numberValidator = calid:number("Value must be a number"):positive()
local result, error = numberValidator:parse(-10)
-- result: false, error: "Must be positive"
if not result then
    print(error) -- Output: Must be positive
end
```

### `calid:string(message?)`
```lua
local stringValidator = calid:string("Value must be a string"):min(5)
local result, error = stringValidator:parse("Hi")
-- result: false, error: "String must be at least 5 characters"
if not result then
    print(error) -- Output: String must be at least 5 characters
end
```

### `calid:enum(values, message?)`
```lua
local enumValidator = calid:enum({ "apple", "banana", "cherry" }, "Value must be one of the specified options")
local result, error = enumValidator:parse("orange")
-- result: false, error: "Value must be one of 'apple, banana, cherry'"
if not result then
    print(error) -- Output: Value must be one of 'apple, banana, cherry'
end
```

### `calid:object(fields, messageType?, messageObject?)`
```lua
local objectValidator = calid:object({
    username = calid:string():min(3),
    age = calid:number():positive()
}, "Invalid object structure")
local result, error = objectValidator:parse({ username = "Jo", age = -5 })
-- result: false, error: "Field 'username': String must be at least 3 characters"
if not result then
    print(error) -- Output: Field 'username': String must be at least 3 characters
end
```

### `calid:array(itemValidator, messageType?, messageArray?)`
```lua
local arrayValidator = calid:array(calid:number():positive(), "Invalid array structure")
local result, error = arrayValidator:parse({ 1, -2, 3 })
-- result: false, error: "Index 2: Must be positive"
if not result then
    print(error) -- Output: Index 2: Must be positive
end
```

---

## 📚 API Reference (Updated with Options)

### Validators

- `calid:literal(value, message?)` - Validates a literal value.
  - **Options:**
    - `value` (required): The exact value to match.
    - `message`: Custom error message.

- `calid:boolean(message?)` - Validates a boolean value.
  - **Options:**
    - `optional`: Allows the value to be nil.
    - `nullable`: Explicitly allows nil values.
    - `default`: Default value if input is nil.
    - `message`: Custom error message.

- `calid:number(message?)` - Validates a number with options for min, max, positive, negative, and integer-only.
  - **Options:**
    - `min`: Minimum value.
    - `max`: Maximum value.
    - `int`: Requires an integer.
    - `positive`: Requires a positive number.
    - `negative`: Requires a negative number.
    - `optional`: Allows the value to be nil.
    - `nullable`: Explicitly allows nil values.
    - `default`: Default value if input is nil.
    - `message`: Custom error message.

- `calid:string(message?)` - Validates a string with options for length, regex, email, URL, UUID, and more.
  - **Options:**
    - `length`: Exact string length.
    - `min`: Minimum string length.
    - `max`: Maximum string length.
    - `regex`: Lua pattern for validation.
    - `email`: Requires a valid email format.
    - `url`: Requires a valid URL format.
    - `uuid`: Requires a valid UUID format.
    - `cuid`: Requires a valid CUID format.
    - `startsWith`: Required prefix.
    - `endsWith`: Required suffix.
    - `optional`: Allows the value to be nil.
    - `nullable`: Explicitly allows nil values.
    - `default`: Default value if input is nil.
    - `message`: Custom error message.

- `calid:enum(values, message?)` - Validates that a value is in a specified set.
  - **Options:**
    - `enum` (required): Array of allowed values.
    - `message`: Custom error message.

- `calid:object(fields, messageType?, messageObject?)` - Validates an object with nested fields.
  - **Options:**
    - `object` (required): Table of field validators.
    - `optional`: Allows the value to be nil.
    - `nullable`: Explicitly allows nil values.
    - `default`: Default value if input is nil.
    - `messageType`: Custom error message for type validation.
    - `messageObject`: Custom error message for field validation.

- `calid:array(itemValidator, messageType?, messageArray?)` - Validates an array of items.
  - **Options:**
    - `array` (required): Validator for array items.
    - `min`: Minimum number of items.
    - `max`: Maximum number of items.
    - `optional`: Allows the value to be nil.
    - `nullable`: Explicitly allows nil values.
    - `default`: Default value if input is nil.
    - `messageType`: Custom error message for type validation.
    - `messageArray`: Custom error message for item validation.

---

## 📜 License

This project is licensed under the **MIT License**.