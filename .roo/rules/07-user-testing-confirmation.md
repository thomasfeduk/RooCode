# User Testing Confirmation Rule

## Rule Overview

**Rule**: After making code changes or implementing features, always ask the user to test and confirm functionality before claiming success or completion. Do not assume changes work correctly without user verification.

**Scope**: All modes and all types of code changes, feature implementations, or system modifications

**Rationale**: 
- Code changes may have unintended side effects or edge cases not immediately apparent
- User testing provides real-world validation that changes work as expected
- Prevents premature completion claims that may be incorrect
- Maintains user confidence by demonstrating thorough validation process
- Allows for immediate feedback and iteration if issues are discovered

## Required Implementation

### After Making Changes:
1. **Complete the changes** using appropriate tools (apply_diff, write_to_file, etc.)
2. **Ask user to test** using ask_followup_question tool with specific testing instructions
3. **Wait for user feedback** before proceeding or claiming completion
4. **Address any issues** reported by user testing
5. **Only claim completion** after user confirms functionality works correctly

### Prohibited Actions:
- ❌ Using attempt_completion immediately after making changes
- ❌ Claiming success without user verification
- ❌ Assuming changes work based on code review alone
- ❌ Providing completion summaries before user testing

### Required Pattern:
```
1. Make code changes
2. Use ask_followup_question: "Please test [specific functionality] and let me know if it works properly"
3. Wait for user response
4. If issues found: fix and repeat from step 2
5. If user confirms working: then use attempt_completion
```

## Example Implementation

**Correct Approach:**
```xml
<apply_diff>
<!-- make changes -->
</apply_diff>

<!-- Wait for tool result, then: -->

<ask_followup_question>
<question>I've updated the build script to fix the Python detection issue. Please test it with `./build_cloudformation.sh` and let me know if it works properly.</question>
<follow_up>
<suggest>The script now works and continues through all steps</suggest>
<suggest>The script still has issues at a specific point</suggest>
<suggest>The script shows different behavior than expected</suggest>
</follow_up>
</ask_followup_question>
```

**Incorrect Approach:**
```xml
<apply_diff>
<!-- make changes -->
</apply_diff>

<!-- Immediately after tool result: -->

<attempt_completion>
<result>I have successfully fixed the build script...</result>
</attempt_completion>
```

## Benefits

- **Accurate Completion**: Only complete tasks that actually work
- **User Confidence**: Demonstrates thorough validation process
- **Immediate Feedback**: Allows quick iteration on issues
- **Real-World Testing**: Validates changes in actual user environment
- **Quality Assurance**: Prevents shipping broken functionality

## Enforcement

This rule applies to:
- All code modifications and implementations
- System configuration changes
- Feature additions or enhancements
- Bug fixes and improvements
- Any change that affects user-facing functionality

**Exception**: Simple documentation updates or non-functional changes may not require testing, but when in doubt, ask for user confirmation.

## Implementation Status

- ✅ Rule established for mandatory user testing confirmation
- 📋 Apply to all future code changes and implementations
- 📋 Use ask_followup_question before attempt_completion for functional changes

This rule ensures all delivered functionality has been validated by the user and works correctly in their environment.