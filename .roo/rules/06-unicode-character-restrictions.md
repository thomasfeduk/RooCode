# Unicode Character Restrictions Rule

## Rule Overview

**Rule**: All project files MUST use only standard ASCII printable characters (ASCII codes 32-126) and MUST NOT contain emoticons, emoji, or special Unicode characters, with the sole exception of README files where such characters are permitted for enhanced user communication and project presentation.

**Scope**: All files in the project repository

**Rationale**: 
- Ensures cross-platform compatibility across all operating systems and terminal environments
- Prevents encoding issues that can cause runtime failures (as experienced with Windows cp1252 encoding)
- Maintains professional code standards and readability
- Eliminates potential display issues in different development environments
- Ensures consistent behavior across different locale settings

## Character Set Restrictions

### Prohibited Characters

**Emoticons and Emoji**: All Unicode emoji characters including but not limited to:
- 🔧 (U+1F527) - Wrench
- ☁️ (U+2601) - Cloud  
- ❌ (U+274C) - Cross Mark
- 💡 (U+1F4A1) - Light Bulb
- 📋 (U+1F4CB) - Clipboard
- 🪲 (U+1FAB2) - Beetle
- 🏗️ (U+1F3D7) - Building Construction
- 💻 (U+1F4BB) - Laptop Computer
- ❓ (U+2753) - Question Mark
- 🪃 (U+1FA83) - Boomerang

**Special Unicode Characters**: Any character outside ASCII printable range (32-126) including:
- Extended Latin characters (À, É, ñ, etc.)
- Mathematical symbols (≠, ≤, ≥, ∞, etc.)
- Currency symbols (€, £, ¥, etc.)
- Typographic symbols (—, –, ", ", ', ', etc.)
- Box drawing characters (│, ─, ┌, etc.)
- Bullet points (•, ◦, ▪, etc.)

### Permitted Characters

**ASCII Printable Characters (32-126)**:
- Space (32)
- Punctuation: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
- Digits: 0-9
- Uppercase letters: A-Z
- Lowercase letters: a-z

**Control Characters** (when necessary):
- Line Feed (LF, 10) - Unix line endings
- Carriage Return + Line Feed (CRLF, 13+10) - Windows line endings
- Tab (9) - For indentation

## File Type Coverage

### Source Code Files
- **Python files** (*.py): ASCII only
- **Shell scripts** (*.sh, *.bat): ASCII only
- **JavaScript files** (*.js): ASCII only
- **Configuration files** (*.json, *.yaml, *.yml, *.toml, *.ini): ASCII only

### Documentation Files
- **Markdown files** (*.md): ASCII only, **EXCEPT README.md files**
- **Text files** (*.txt): ASCII only
- **Code comments**: ASCII only in all programming languages

### Project Management Files
- **Commit messages**: ASCII only
- **Branch names**: ASCII only
- **Tag names**: ASCII only
- **Issue titles and descriptions**: ASCII only
- **Pull request titles and descriptions**: ASCII only

### Configuration and Build Files
- **Environment files** (.env, .env.example): ASCII only
- **Build scripts**: ASCII only
- **CI/CD configuration**: ASCII only
- **Docker files**: ASCII only

## Exception: README Files

**README.md files** are **EXEMPT** from this rule and **MAY** contain:
- Emoji and emoticons for enhanced user experience
- Unicode characters for better visual presentation
- Special symbols for badges, icons, and formatting
- Non-ASCII characters for internationalization when appropriate

**Rationale for Exception**:
- README files are primarily for user communication and project presentation
- Enhanced visual appeal improves user engagement and project accessibility
- README files are typically viewed in web browsers or markdown renderers that handle Unicode well
- User-facing documentation benefits from visual elements that improve readability

## Implementation Guidelines

### Replacement Strategies

**For Error Messages and Logging**:
```
❌ Error: → [ERROR] Error:
✅ Success: → [SUCCESS] Success:
🔧 Using: → [LOCAL] Using:
☁️ AWS: → [AWS] AWS:
💡 Tip: → TIP:
📋 Instructions: → Instructions:
```

**For Comments and Documentation**:
```
// ✅ Good practice → // Good practice
// ❌ Bad practice → // Bad practice  
/* 🚨 Warning */ → /* WARNING */
# 📝 Note: → # Note:
```

**For Variable and Function Names**:
```
// Prohibited
const 🔧wrench_tool = "tool";
function 📊generateReport() {}

// Correct
const wrench_tool = "tool";
function generateReport() {}
```

### Code Review Checklist

**Before Committing**:
1. ✓ Scan all modified files for non-ASCII characters
2. ✓ Check commit messages for Unicode characters
3. ✓ Verify branch names use only ASCII characters
4. ✓ Confirm error messages use ASCII text prefixes
5. ✓ Validate configuration files contain only ASCII

**Automated Checks** (Recommended):
- Pre-commit hooks to detect non-ASCII characters
- CI/CD pipeline validation for character encoding
- Linting rules to flag Unicode usage in source code

## Error Handling

### When Unicode Characters Are Found

**Development Phase**:
1. Replace Unicode characters with ASCII equivalents
2. Update any affected functionality
3. Test cross-platform compatibility
4. Document the changes in commit messages

**Production Issues**:
1. Identify the source of Unicode characters
2. Implement immediate ASCII replacement
3. Test on affected platforms (especially Windows)
4. Deploy fix with priority

### Common Encoding Issues

**Windows Compatibility**:
- cp1252 encoding cannot handle Unicode characters
- Results in `UnicodeEncodeError` exceptions
- Affects console output and file operations

**Terminal Compatibility**:
- Some terminals cannot display Unicode characters
- May show as question marks or boxes
- Affects debugging and logging output

## Enforcement

### Mandatory Compliance

**All team members** must follow this rule for:
- New code development
- Code modifications and refactoring
- Documentation updates (except README files)
- Commit messages and branch names
- Configuration file changes

### Review Process

**Code Reviews** must verify:
- No Unicode characters in source code
- ASCII-only error messages and logging
- Proper character encoding in configuration files
- Commit message compliance

### Violation Handling

**Minor Violations**:
- Request changes in pull request review
- Provide ASCII replacement suggestions
- Merge after corrections are made

**Major Violations**:
- Block merge until all Unicode characters are removed
- Require comprehensive testing on Windows systems
- Document lessons learned for team reference

## Benefits

### Cross-Platform Compatibility
- Eliminates encoding-related runtime errors
- Ensures consistent behavior across operating systems
- Prevents display issues in different terminal environments

### Professional Standards
- Maintains clean, readable code
- Follows industry best practices for source code
- Ensures compatibility with legacy systems and tools

### Maintenance Efficiency
- Reduces debugging time for encoding issues
- Simplifies internationalization when needed
- Improves code portability across environments

## Implementation Status

- ✅ **runlocal.py**: Updated to use ASCII-only error messages and logging
- ✅ **Cross-platform testing**: Verified Windows compatibility
- 📋 **Future enforcement**: Apply to all new code and modifications
- 📋 **Automated checking**: Consider pre-commit hooks for validation

This rule ensures robust, cross-platform compatible code while maintaining professional standards and preventing encoding-related issues that can cause runtime failures.