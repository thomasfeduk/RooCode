# Automatic Report Persistence Rule

## Report Generation and Persistence Requirement

**Rule**: All comprehensive reports generated and displayed in the UI must be automatically persisted to the roo_plans directory as markdown files with timestamp metadata.

**Scope**: All modes (Architect, Code, Debug, etc.) when generating analysis reports, technical documentation, or comprehensive findings

**Rationale**: 
- Reports displayed only in UI are temporarily visible and cannot be retrieved later
- Historical reports provide valuable reference for future development and decision-making
- Persistent storage enables tracking of project evolution and analysis over time
- Markdown format ensures reports remain accessible and searchable

**Required Implementation**:

### File Naming Convention
- Format: `YYYY-MM-DD_HH_MM_SS_[report-type]_[brief-description].md`
- Examples:
  - `2025-09-26_21_47_00_dead_code_analysis_lambda_function.md`
  - `2025-09-26_15_30_00_architecture_review_voice_2fa_system.md`
  - `2025-09-26_09_15_00_performance_analysis_cold_start_optimization.md`

### Required Metadata
Each report file must include:
```markdown
# [Report Title]

**Generated**: [ISO 8601 timestamp]
**Report Type**: [Analysis type - e.g., Dead Code Analysis, Architecture Review, Performance Analysis]
**Scope**: [What was analyzed - e.g., lambda_function.py and test suite]
**Mode**: [Generation mode - e.g., Code, Architect, Debug]

---

[Full report content]
```

### Mandatory Actions
1. **Generate Report**: Create comprehensive analysis/report content
2. **Display in UI**: Present report to user in current interaction
3. **Persist to Disk**: Automatically save complete report to roo_plans directory
4. **Include Metadata**: Add generation timestamp, report type, scope, and mode
5. **Confirm Persistence**: Log successful file creation

### Report Types Requiring Persistence
- Dead code analysis reports
- Architecture review reports
- Performance analysis reports
- Security audit reports
- Code quality assessments
- Technical debt analysis
- Refactoring recommendations
- System design documents
- Implementation planning reports
- Any comprehensive analysis exceeding 500 words

### Benefits
- **Historical Reference**: Access to all previous analyses and reports
- **Decision Tracking**: Clear record of technical decisions and their rationale
- **Knowledge Preservation**: Prevents loss of analysis work and insights
- **Team Collaboration**: Shared access to technical documentation
- **Project Evolution**: Track changes and improvements over time

### Implementation Status
- ✅ Rule established for automatic report persistence
- 🔄 Apply to current dead code analysis report
- 📋 Future reports will automatically follow this pattern

This rule ensures all valuable analysis work is preserved for future reference and maintains a comprehensive technical documentation history for the project.