# AL ID Range Manager (Business Central extension)

This Business Central extension provides quick and centralized object id assignment for the VS Code extension that can be downloaded directly from VS Code Marketplace. The source of of the VS Code extension is available publicly on GitHub: <https://github.com/TKapitan/ALRM-VSCode>.

## Features

The extension manage object and field IDs accross multiple extension and is especially useful when more developers work within the same object range.

### Assignable Ranges

The core of the extension are "Assignable Ranges" that manage all available ranges and are used during initializing of new extension. The assignable range can define available field and object IDs.

The assignable range has two primary parts - header and lines. In the header, you can also define

- "Fill Object ID Gaps": If set to true, the system tries to find gaps in assigned objects. If there is a gap in corresponsing ID range, system use the ID for newly created object. It is possible to set it on the header and lines, the header is for default ranges and the setting in lines is only for the range specified in the line. The process may have impact on performance of assigning new objects (however, should still be ok).
- "Default Object Range From" / "To": This range is used to assign IDs to all types of objects except those defined specifically in lines (with their own range).
- "Default Field Range From" / "To": This range is used to assign IDs to all fields created in EnumExtensions and TableExtensions.
- "Ranges per BC Instance": This value specifies, whether the object ID is used only once (when this field is set to false) even if two extensions are used for different BC instances. If this field is set to true, IDs are assigning uniquelly only by checking extensions installed to the same BC instance. This value is especially useful for standard Customer range (50000 - 99999) when you can set it only once and then reuse objects for each customer extension (and for each customer start assigning always from the initial ID).
- "Object Name Template": Using this field, you can force structure of object names (for example set your prefix/suffix). The value must be set as a standard Business Central Filter (with an asterisk). For example, if you want to force that all object names starts with prefix "TKA ", set this field to "TKA *".

In the lines section, you can define different ranges for specific object types. If you specify special range for one object type, the default object range from header is not used for the object type anymore.

For example, if you want to create all objects within range 50000 - 59999 but tables in range 60000 - 64999, the first range should be set as Default Object range in the header and for tables, you must create one line defining range 60000 - 64999.

### Extensions

The "Extension List" is the core of the extension. It shows all existing extensions. Primarily, the extensions should be created using API from the VS Code Extension, but it is still possible to create them manully.

To create a new extension, just select one of the existing Assignable Ranges, all other details are created automatically. However, if you create the extension manually, it is not currently possible to link it to AL project and so to use the extension from the VS Code extension.

In the lines part, all existing objects are shown (eventually, they can be defined manually from the extension card). The IDs are assigned automatically from the corresponding Assignable Range (if there is no available object ID for selected object type, error is returned). If the assignable range has object name templated defined, the name of the object is checked once is filled in.

For TableExtension and EnumExtension object types, the IDs could be managed similary to the IDs of objects. From the line of existing TableExtension/EnumExtension, select action "Object Lines" that open new page with list of existing fields. Fields can be managed from the VS Code extension, or manually from this page.

From the extension card, the list of usage can be shown. On the "Extension Usage List" you can define which extension is used in which BC Instance. This is neccessary setting for assignable ranges that are set as "Per BC Instance" and is also neccessary for generating template for the license file.

### Suggest Objects for Business Central License

Once you have your own extension developed and properly set (with defined BC Instance in Extension Usage List), you can run "Create License File" from "Go To". This report create a downloadable file that can be imported to the Microsoft Partner Portal to assigne extension objects to the customer license.

## Requirements

If you do not know how to install Business Central extension, see <https://docs.microsoft.com/en-us/dynamics365/business-central/ui-extensions>.

This Microsoft Dynamics 365 Business Central extension has no special requirements. The only requirements are running Business Central instance (at least Microsoft Dynamics 360 Business Central 2020 Wave 2 / v17) and for installing tests the neccessity is the Business Central Test Toolkit (for guide how to properly set test toolkit, see <https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extension-advanced-example-test>).

## Extension Settings

To use the extension in the combination with ALRM VS Code extension (<https://github.com/TKapitan/ALRM-VSCode>) a few things have to be set up.

1. At least one "Assignable Range" must be properly set.
    - Assignable Ranges manage available object and field ranges for all extensions.
    - To create and set a new Assignable Range
        1. Open "Assignable Ranges" page
        2. Fill (only required fields are mentioned, for description of other fields, see [Features](##Features))
            - Code (Identification of the range, is visible from VS Code extension when developer initialize new extension).
            - Default Object Range From & To (Specifies available ranges for all object types that are not defined separately in lines. Once the range is defined for specific object type in lines, the default range is not used anymore.)
            - No. Series for Extensions (Specifies the No. Series that are used for assigning identification to newly initialized extension. The No. Series must have line defined and must be set as a Default Numbers.).

## Known Issues

- Setting "Range per BC Instance" is not properly tested
- Field Ranges in Assignable Ranges are not tested on change whether the old IDs are not already in use

For list of minor issues and upcoming changes see <https://github.com/TKapitan/ALRM-BusinessCentral/blob/master/CHANGELOG.md#unreleased>

## Release Notes

See [changelog](https://github.com/TKapitan/ALRM-BusinessCentral/blob/master/CHANGELOG.md)
