# Git Operations Rule

## Git Operations Restriction

**Rule**: Do not perform any git operations or commands during file migration or project management tasks.

**Scope**: All modes (Architect, Code, Debug, etc.)

**Rationale**: 
- User will manage all git checkpointing, commits, branches, and version control operations personally
- Assistant should focus solely on file system operations and content management
- Prevents conflicts with user's git workflow and branching strategies

**Prohibited Operations**:
- `git add`
- `git commit` 
- `git mv`
- `git rm`
- `git checkout`
- `git branch`
- `git merge`
- `git tag`
- Any other git commands

**Allowed Operations**:
- File system operations (copy, move, rename, delete)
- Content modification and creation
- Directory structure management
- File validation and integrity checks
- Backup creation using file system tools
- Other normal command executions excluding git commands

**Implementation**:
- When migration plans include git operations, exclude them from execution
- Focus on file system backup strategies instead of git checkpoints
- Document that git operations are user's responsibility
- Provide file-based rollback procedures rather than git-based ones

**Exception Handling**:
- If a task inherently requires git operations, inform the user and request they handle the git aspects
- Provide clear documentation of what git operations would be beneficial for the user to perform
- Continue with file system operations while noting git considerations

## Migration Planning Impact

When creating migration plans:
- Replace git checkpoint steps with file system backup procedures
- Use file copying for backups instead of git commits
- Document rollback procedures using file restoration rather than git revert
- Note where user should consider git operations but don't execute them

This rule ensures clean separation between file management (assistant) and version control (user).