# Pydantic Validation Preferences Rule

## Rule Overview

**Rule**: Use modern Python 3.10+ syntax and Pydantic's Annotated types with constraints instead of custom validator methods for data validation in all Pydantic models.

**Scope**: All Pydantic models, DTOs, and data validation classes

**Rationale**: 
- Cleaner, more readable code with less boilerplate
- Leverages Pydantic's built-in validation capabilities
- Uses modern Python syntax features
- Reduces custom validation method overhead
- Follows industry best practices for type hints and validation

## Required Implementation

### Union Types (Optional Fields)
**Use Python 3.10+ union syntax with `|` instead of `Optional[]`**

```python
# Preferred ✅
field_name: str | None = None
user_id: int | None = None

# Avoid ❌
from typing import Optional
field_name: Optional[str] = None
user_id: Optional[int] = None
```

### Validation Constraints
**Use `Annotated` types with `StringConstraints`, `Field`, and regex patterns instead of custom `@validator` methods**

```python
# Preferred ✅
from typing import Annotated
from pydantic import StringConstraints, Field

StrPopulated = Annotated[str, StringConstraints(min_length=1, strip_whitespace=True)]
UserAge = Annotated[int, Field(ge=0, le=150)]
EmailPattern = Annotated[str, StringConstraints(pattern=r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')]

class UserDto(BaseModel):
    name: StrPopulated
    age: UserAge
    email: EmailPattern

# Avoid ❌
class UserDto(BaseModel):
    name: str
    age: int
    email: str
    
    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v or not v.strip():
            raise ValueError('Name cannot be empty')
        return v.strip()
    
    @validator('age')
    def age_must_be_positive(cls, v):
        if v < 0 or v > 150:
            raise ValueError('Age must be between 0 and 150')
        return v
```

### Data Types Organization
**Create centralized data type definitions in a dedicated module**

```python
# app/dtos/data_types.py
from decimal import Decimal
from typing import Annotated
from pydantic import StringConstraints, Field

# Define reusable constrained types
StrPopulated = Annotated[str, StringConstraints(min_length=1, strip_whitespace=True)]
StrEmail = Annotated[str, StringConstraints(pattern=r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')]
UserAge = Annotated[int, Field(ge=0, le=150)]
ProductPrice = Annotated[Decimal, Field(ge=0, le=999999.99, decimal_places=2)]
```

## Benefits

### Code Quality
- **Reduced Boilerplate**: Eliminates verbose validator methods
- **Type Safety**: Better IDE support and static analysis
- **Reusability**: Centralized type definitions can be reused across models
- **Readability**: Clear, declarative validation rules

### Maintainability
- **Consistency**: Standardized validation approach across the codebase
- **Centralization**: All validation rules defined in type definitions
- **Modern Syntax**: Uses latest Python features for cleaner code

### Performance
- **Built-in Validation**: Leverages Pydantic's optimized validation engine
- **Reduced Overhead**: No custom method calls for simple validations

## Implementation Guidelines

### Required Patterns

**Union Types**:
```python
# All optional fields must use | syntax
field: str | None = None
user_id: int | None = None
items: list[str] | None = None
```

**Constrained Types**:
```python
# Define in data_types.py
StrNonEmpty = Annotated[str, StringConstraints(min_length=1)]
StrMaxLength = Annotated[str, StringConstraints(max_length=100)]
PositiveInt = Annotated[int, Field(gt=0)]
```

**Model Definitions**:
```python
# Use constrained types in models
class UserCreateDto(BaseModel):
    name: StrPopulated
    email: EmailStr  # Use pydantic's EmailStr for emails
    age: UserAge
```

### Prohibited Patterns

**Avoid Custom Validators for Simple Constraints**:
```python
# Don't do this ❌
@validator('field')
def validate_field(cls, v):
    if len(v) < 1:
        raise ValueError('Field cannot be empty')
    return v
```

**Avoid Optional[] Import**:
```python
# Don't do this ❌
from typing import Optional
field: Optional[str] = None
```

## Enforcement

### Code Review Checklist
- ✓ All optional fields use `|` union syntax
- ✓ No custom `@validator` methods for simple constraints
- ✓ Constrained types defined in `data_types.py`
- ✓ Reusable type definitions used across models
- ✓ No `Optional[]` imports

### Migration Strategy
- **New Code**: Must follow these patterns immediately
- **Existing Code**: Refactor during maintenance or feature updates
- **Legacy Support**: Gradual migration acceptable for large codebases

## Implementation Status

- ✅ **Rule established**: Modern Pydantic validation preferences
- 📋 **Apply to current project**: User Management System DTOs
- 📋 **Future enforcement**: All new Pydantic models

This rule ensures clean, modern, and maintainable validation code using Pydantic's latest capabilities and Python 3.10+ syntax features.