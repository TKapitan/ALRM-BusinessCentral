# Change Log

## [Unreleased]

- Enhance UI (Navigation, Structure of cards)
- Test "Range per BC Instance"
- Add validation for changing existing extensions
- Add validation for changing existing assignable ranges field ranges
- Add option to set assignable ranges to "re-use" gaps in object & field IDs
- Add support for extension synchronization using API
  - Remove existing object line
  - Register object line (table/enum extension field) with specific ID
  - Remove object line (table/enum extension field) with specific ID 

## [Released Versions]

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
