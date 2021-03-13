# Change Log

## [Unreleased]

- Enhance UI (Navigation, Structure of cards)
- Test "Range per BC Instance"
- Option "Default" in Assignable Range Header has no functionality
- Add validation for changing existing extensions
- Add validation for changing existing assignable ranges field ranges
- Add support for extension synchronization using API
  - Remove existing object line
  - Remove object line (table/enum extension field) with specific ID

## [Released Versions]

### v0.1.1.0

- Date of release 12/03/2021

Major changes

- New setting on assignalbe range: "Fill Object ID Gaps"
  - If set to true, the system tries to find gaps in assigned objects. If there is a gap in corresponsing ID range, system use the ID for newly created object.
  - It is possible to set it on the header and lines, the header is for default ranges and the setting in lines is only for the range specified in the line.
  - The process may have impact on performance of assigning new objects (however, should still be ok).
- New supported object types: PageCustomization, Profile
- New supported runtime: Business Central 2021 W1
  - New supported object types: ReportExtension, PermissionSet, PermissionSetExtension, Entitlement
- New API method for consuming by VS Code Extension
  - Microsoft.NAV.createObjectFieldOrValue for obtaining field IDs in "ALRM: New object extension field or value" command. Replace old command Microsoft.NAV.createObjectLine that is not called anymore).
  - Microsoft.NAV.createObjectFieldOrValueWithOwnID for registering existing fields (with already assigned field/value ID) using "ALRM: Synchronize (beta)" command.
  - Microsoft.NAV.createObjectWithOwnID for registering existing objects (with already assigned object ID) using "ALRM: Synchronize (beta)" command.

Other changes

- CreateObjectLine API replaced by CreateObjectFieldOrValue, Obsolete('Replaced by CreateObjectFieldOrValue(), will be removed 2021/04.')
- Created By field in Extension Object Line table (filled by user who create the record directly in BC or username provided using APIs method).
- ID to Extension Object Line record is assigned OnInsert (previously OnValidate of Extension Object ID).
- Some error messages were improved to be more readable/usable.
- It is possible to register also field/value names through UI or API (no additional functionality or validation)
- Code maintenance

### v0.1.0.0

- Date of release 15/01/2021
- New API function in Extensions to register already existing object (with specific object name and also ID).
- Improving of validation error messages when new extension object is created (object name/ID duplicity, object name structure, ...) to help with identification of problem when created using API.
- Code maintenance

### v0.0.2.3

- Date of release 03/01/2021
- Minor Changes, Refactoring of app and tests
- Add Support for Interface objects (or in general for any objects without IDs)

### v0.0.2.2

- Date of release 15/12/2020
- Minor Changes, Refactoring of app and tests
- Set object type, ID and Name mandatory in extension
- Validate newly created assignable range line whether the newly defined object type ranges have not already use default object range from the header

### v0.0.2.1

- Date of release: 27/11/2020
- Enhance Documentation
- Minor changes, refactoring
- Extension Identification & rules

### v0.0.2.0

- Date of release: 21/11/2020
- Initial release from Coding4BC hackathon
