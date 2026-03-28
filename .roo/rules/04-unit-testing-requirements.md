# Unit Testing Requirements

## Mock Logger Implementation

**Rule**: Unit test files MUST implement mock logger instances to suppress console output during test execution **ONLY when testing code that uses logging functionality**.

**Scope**: Test files in the `tests/` directory that import and test modules with logging

**Exception**: Mock loggers should **NOT** be implemented for tests of code that does not use any logging functionality, as this would be superfluous and add unnecessary complexity.

**Rationale**: 
- Maintains clean console output during test execution for logging-enabled code
- Prevents log messages from cluttering test results display
- Allows tests to verify logging behavior through mock assertions
- Ensures consistent test environment across different logging configurations
- Avoids unnecessary mocking overhead for non-logging code

**When to Apply This Rule**:

✅ **REQUIRED** - When testing code that:
- Uses `logging.getLogger()`
- Uses `StructuredLogger` class
- Calls logger methods (`.info()`, `.error()`, `.warning()`, etc.)
- Imports modules that contain logging functionality

❌ **NOT REQUIRED** - When testing code that:
- Contains no logging statements
- Does not import modules with logging
- Is purely computational without I/O logging
- Uses only print statements (though print statements should be avoided in production code)

**Required Implementation Pattern** (for logging-enabled code):

```python
import unittest
import logging
from unittest.mock import Mock, patch

# Mock the logger at module level BEFORE importing lambda_function
# This prevents any logging output during test execution
mock_logger = Mock()
mock_structured_logger = Mock()

# Patch the logging system before lambda_function imports
with patch('lambda_function.logging.getLogger') as mock_get_logger, \
     patch('lambda_function.StructuredLogger') as mock_struct_logger_class:
    
    # Configure the mock logger to do nothing
    mock_get_logger.return_value = mock_logger
    mock_struct_logger_class.return_value = mock_structured_logger
    
    # Import lambda_function after mocking logging
    from lambda_function import (
        # Your imports here
    )


# Global test setup to ensure no logging output
class BaseTestCase(unittest.TestCase):
    """Base test case with logging suppression."""
    
    @classmethod
    def setUpClass(cls):
        """Suppress all logging during tests."""
        # Disable all logging at the root level
        logging.disable(logging.CRITICAL)
        
        # Mock the module-level logger in lambda_function
        cls.logger_patcher = patch('lambda_function.logger', mock_structured_logger)
        cls.logger_patcher.start()
    
    @classmethod
    def tearDownClass(cls):
        """Re-enable logging after tests."""
        logging.disable(logging.NOTSET)
        cls.logger_patcher.stop()
    
    def setUp(self):
        """Set up each test with fresh mocks."""
        # Reset the mock logger for each test
        mock_structured_logger.reset_mock()
        mock_logger.reset_mock()


# All test classes MUST inherit from BaseTestCase (for logging-enabled code)
class YourTestClass(BaseTestCase):
    """Your test class description."""
    
    def setUp(self):
        """Set up test fixtures."""
        super().setUp()  # Call parent setUp to reset mocks
        # Your setup code here
```

**Simple Pattern** (for non-logging code):

```python
import unittest

# Direct import - no logging mocks needed
from your_module import YourClass

class YourTestClass(unittest.TestCase):
    """Test class for non-logging code."""
    
    def setUp(self):
        """Set up test fixtures."""
        # Your setup code here
        pass
```

**Mandatory Requirements** (for logging-enabled code only):

1. **Mock Logger Setup**: Test files must mock both `logging.getLogger` and `StructuredLogger` before importing modules that use logging
2. **BaseTestCase Inheritance**: Test classes must inherit from `BaseTestCase` instead of `unittest.TestCase`
3. **Logging Suppression**: Tests must disable logging at the root level during execution
4. **Mock Reset**: Each test must reset mock loggers to ensure clean state
5. **Super() Calls**: Test setUp methods must call `super().setUp()` when overriding

**Verification Methods** (for logging-enabled code):

Tests can still verify logging behavior using mock assertions:

```python
def test_logging_behavior(self):
    """Test that logging occurs as expected."""
    # Your test code that should trigger logging
    some_function_that_logs()
    
    # Verify logging was called without seeing console output
    mock_structured_logger.info.assert_called_once()
    mock_structured_logger.error.assert_not_called()
```

**Prohibited Practices**:

- ❌ Using actual logging instances in tests of logging-enabled code
- ❌ Allowing console output during test execution from logging
- ❌ Adding mock loggers to tests of non-logging code (superfluous)
- ❌ Importing logging-enabled modules before setting up logging mocks
- ❌ Skipping mock logger reset between tests (for logging-enabled code)

**Benefits**:

- Clean test output without log message clutter
- Consistent test environment regardless of logging configuration
- Ability to verify logging behavior through mock assertions
- Faster test execution without I/O overhead from logging
- Better test isolation and reliability
- No unnecessary complexity for non-logging code

**Implementation Status**:

- ✅ `tests/test_lambda_function.py` - Implemented (tests logging-enabled code)
- ✅ `tests/test_ssml_validation.py` - Implemented (tests logging-enabled code)
- 🔄 Future test files should evaluate if they test logging-enabled code

**Decision Guidelines**:

**Ask yourself**: "Does the code I'm testing use any logging functionality?"
- **Yes** → Implement mock logger pattern
- **No** → Use simple unittest.TestCase pattern

**Enforcement**:

This requirement applies only to test files that test logging-enabled code. Code reviews should verify:
1. Logging-enabled code tests use mock logger pattern
2. Non-logging code tests do NOT use unnecessary mock loggers
3. Proper pattern selection based on code being tested