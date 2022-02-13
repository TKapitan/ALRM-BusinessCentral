# Change Log

## [Unreleased]

- Enhance UI (Navigation, Structure of cards)
- Add validation for changing existing extensions
- Add validation for changing existing assignable ranges field ranges
- Add support for extension synchronization using API
  - Remove existing object line
  - Remove object line (table/enum extension field) with specific ID
- Default field range in Assignable Headers are not validated on change

## [Released Versions]

### v0.1.6.0

- Date of release 13/02/2022

Major changes

- All OBSOLETE objects that were marked to be removed in 2021 were finally removed.
- Support for alternate object IDs (to have two ranges for the same extension - one for the on-premises, the second one for cloud).
- Add setting to assignable range to skip default, non-licensed, object ids.

Other changes

- Generated ranges in license file generation have merged ranges if the range is the whole range.
- The extension usage is now renameable (only those extensions that aren't per bc instance).

### v0.1.5.3

- Date of release 23/07/2021

Major changes

- PermissionSets defined using XML definitions were replaced by AL permission sets. Three permission sets are available - "ALRM Admin", "ALRM User", and "ALRM API User".
- Heavy refactoring of AL Object Type definitions. Initially, the AL Object Types were defined using Enum, and all properties were defined using Interface implemented by specific codeunits. Now the AL Object Types are still defined using Enum, but the configuration of each type is defined in the new table "Object Type Configuration". The values in this table are created automatically during the extension installation and cannot be changed in UI. This change has been done because of a specific configuration for each object type. The Interface implementation is the default value but it is possible to switch to table definition in "ALRM Setup". The table definition will be made default implementation in upcoming version and Interface implementation will be removed in 2021/Q4.
- New validation for object name length has been added. The max name length for each object type is 30 characters except PermissionSet & PermissionSetExtesion, with a limit of 20 characters.

Other changes

- "Sell as Item No." and "Flat-rate Invoicing as Item No." fields were added to the extension card & list. The fields specify which items are used for invoicing and can be used for sales evaluation of each extension in your own reports.
- New page, "Assigned Range Object List", was added that list all objects from all extensions. The page is read-only.

Fixes

- Primary Keys in core tables (Assignable Range, Extension & Business Central Instance) have been made NonBlank.
- The field "Extension ID" in the "Extension Object" table was empty.

### v0.1.3.4

- Date of release 10/05/2021

Major changes

- When the object is created using API and it already exists, the non-key fields (right now only extended object name) are updated with new value.

### v0.1.3.3

- Date of release 09/05/2021

Major changes

- ALRM Setup table & page were created.
- New field in ALRM Setup - "Minimal API version". This fields allows administrator to specify minimal version of API that has to be used in any API call. If older (lower) version is used for communication, the error is raised. All API requests were updated so they check this option.

### v0.1.3.0

- Date of release 09/05/2021

API changes

- New version of API v1.1, old version (v1.0) will be available until 2021/Q3.
- v1.0 changes
  - New fields in assignableRanges API, see description in v1.1.
  - API method CreateObjectLine in Extension API is no longer available (obsolete since 2021/01, marked to be remove in 2021/04).
- v1.1 changes
  - New fields: description, defaultObjectRangeFrom, defaultObjectRangeTo, objectNameTemplate in assignableRanges API. As this is not breaking change, the fields are also available in older v1.0 version.
  - CreateObject and CreateObjectWithOwnID API methods in extensions API now have another parameter ExtendsObjectname that specifies name of extended object. The value can be specified only for object types that extend another objects.  
  - API method CreateObjectLine in Extension API is no longer available (obsolete since 2021/01, marked to be remove in 2021/04).

Major changes

- Extended values provided in API for Assignable Ranges API (See [Issue #5](https://github.com/TKapitan/ALRM-BusinessCentral/issues/5))
- New field "Extended Object Name" in Extension Objects that allows to define name of the extended object. Also possible to define the value using API CreateObject, CreateObjectWithOwnID (See [Issue #4](https://github.com/TKapitan/ALRM-BusinessCentral/issues/5))

Other changes

- Caption & transalation improvements
- Minor refactoring

### v0.1.2.0

- Date of release 02/05/2021

Changes

- New supported object type "Control Addin".
- Add validation for "Ranges per BC instance" in assignable ranges that the extensions based on this range are allowed to have one usage only.
- Improvements of validations for extensions based on ranges with "Ranges per BC instance".

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
