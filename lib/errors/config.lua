return {
    ["generic"] = {
        required = "Required field is missing",
        type = "Expected %s, received %s",
    },
    ["number"] = {
        int = "Must be an integer",
        float = "Must be a float",
        positive = "Must be positive",
        negative = "Must be negative",
        min = "Must be at least %s",
        max = "Must be at most %s",
        multipleOf = "Must be multiple of %s",
    },
    ["string"] = {
        length = "Must be exactly %s characters",
        min = "Must be at least %s characters",
        max = "Must be at most %s characters",
        startsWith = "Must start with '%s'",
        endsWith = "Must end with '%s'",
        includes = "Must includes '%s'",
        regex = "Does not match pattern",
        email = "Invalid email address",
        url = "Invalid URL format",
        uuid = "Invalid UUID format",
        nanoid = "Invalid NANOID format",
        cuid = "Invalid CUID format",
        cuid2 = "Invalid CUID2 format",
        ulid = "Invalid ULID format",
        ip = "Invalid IP address",
        cidr = "Invalid CIDR address",
    },
    ["array"] = {
        length = "Must be exactly %s items",
        min = "Must be at least %s items",
        max = "Must be at most %s items",
    },
    ["literal"] = {
        literal = "Expected '%s', got '%s'",
    },
    ["enum"] = {
        enum = "Expected one of '%s', got '%s'",
    },
}