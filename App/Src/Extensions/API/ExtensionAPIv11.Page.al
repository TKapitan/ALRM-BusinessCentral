/// <summary>
/// Page C4BC Extension API v1.1 (ID 80013).
/// </summary>
page 79513 "C4BC Extension API v1.1"
{
    PageType = API;
    Caption = 'Extension API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.1';
    EntityName = 'extension';
    EntitySetName = 'extensions';
    SourceTable = "C4BC Extension Header";
    DelayedInsert = true;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId) { }
                field(rangeCode; Rec."Assignable Range Code") { }
                field(alternateRangeCode; Rec."Alternate Assign. Range Code") { }
                field("code"; Rec.Code) { }
                field(description; Rec.Description) { }
                field(id; Rec.ID) { }
                field(name; Rec.Name) { }
                field(systemCreatedAt; Rec.SystemCreatedAt) { }
                field(systemCreatedBy; Rec.SystemCreatedBy) { }
                field(systemModifiedAt; Rec.SystemModifiedAt) { }
                field(systemModifiedBy; Rec.SystemModifiedBy) { }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");
    end;

    [ServiceEnabled]
    /// <summary> 
    /// Create new object with specified name and type.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="ExtendsObjectName">Text[100], Specifies name of object that the newly created object extends. Can be filled in for extension objects only.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateObject(ObjectType: Enum "C4BC Object Type"; ObjectName: Text[100]; ExtendsObjectName: Text[100]; CreatedBy: Text[50]): Integer
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");

        C4BCExtensionObject.SetRange("Extension Code", Rec.Code);
        C4BCExtensionObject.SetRange("Object Type", ObjectType);
        C4BCExtensionObject.SetRange("Object Name", ObjectName);
        if C4BCExtensionObject.FindFirst() then begin
            C4BCExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
            C4BCExtensionObject.Modify(true);
            exit(C4BCExtensionObject."Object ID");
        end;

        C4BCExtensionObject.Init();
        C4BCExtensionObject."Extension Code" := Rec.Code;
        C4BCExtensionObject.Validate("Object Type", ObjectType);
        C4BCExtensionObject.Validate("Object Name", ObjectName);
        C4BCExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
        C4BCExtensionObject.Validate("Created By", CreatedBy);
        C4BCExtensionObject.Insert(true);
        exit(C4BCExtensionObject."Object ID");
    end;

    [ServiceEnabled]
    /// <summary> 
    /// Create new object with specified name and type.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specify object name.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="ExtendsObjectName">Text[100], Specifies name of object that the newly created object extends. Can be filled in for extension objects only.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateObjectWithOwnID(ObjectType: Enum "C4BC Object Type"; ObjectID: Integer; ObjectName: Text[100]; ExtendsObjectName: Text[100]; CreatedBy: Text[50])
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";

        AlternateObjectIDNotFoundErr: Label 'Alternate object ID %1 for object type %2 was not found.', Comment = '%1 - Received object ID, %2 - Received object type';
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");

        // Alternate & normal ID
        C4BCExtensionHeader.Get(Rec.Code);
        if (C4BCExtensionHeader."Alternate Assign. Range Code" <> '') and not C4BCExtensionObject.IsObjectIDWithinRange(C4BCExtensionHeader."Assignable Range Code", ObjectType, ObjectID) then begin
            C4BCExtensionObject.SetRange("Extension Code", Rec.Code);
            C4BCExtensionObject.SetRange("Object Type", ObjectType);
            C4BCExtensionObject.SetRange("Alternate Object ID", ObjectID);
            C4BCExtensionObject.SetRange("Object Name", ObjectName);
            if not C4BCExtensionObject.FindFirst() then
                Error(AlternateObjectIDNotFoundErr, ObjectID, ObjectType);
        end else begin
            C4BCExtensionObject.SetRange("Extension Code", Rec.Code);
            C4BCExtensionObject.SetRange("Object Type", ObjectType);
            C4BCExtensionObject.SetRange("Object ID", ObjectID);
            C4BCExtensionObject.SetRange("Object Name", ObjectName);
        end;

        // If exists, update extended object name
        if C4BCExtensionObject.FindFirst() then begin
            C4BCExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
            C4BCExtensionObject.Modify(true);
            exit;
        end;

        C4BCExtensionObject.Init();
        C4BCExtensionObject."Extension Code" := Rec.Code;
        C4BCExtensionObject.Validate("Object Type", ObjectType);
        C4BCExtensionObject.Validate("Object ID", ObjectID);
        C4BCExtensionObject.Validate("Object Name", ObjectName);
        C4BCExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
        C4BCExtensionObject.Validate("Created By", CreatedBy);
        C4BCExtensionObject.Insert(true);
    end;

    [ServiceEnabled]
    /// <summary>
    /// Create new object field for tableextensions or object value for enumextensions.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specifies Object ID</param>
    /// <param name="CreatedBy">Text[50], Specifies user who requested new ID.</param>
    /// <returns>Return variable "Integer", ID of the object line.</returns>
    procedure CreateObjectFieldOrValue(ObjectType: Enum "C4BC Object Type"; ObjectID: Integer; CreatedBy: Text[50]): Integer
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");

        C4BCExtensionObjectLine.Init();
        C4BCExtensionObjectLine.Validate("Extension Code", Rec."Code");
        C4BCExtensionObjectLine.Validate("Object Type", ObjectType);
        C4BCExtensionObjectLine.Validate("Object ID", ObjectID);
        C4BCExtensionObjectLine.Validate("Created By", CreatedBy);
        C4BCExtensionObjectLine.Insert(true);
        exit(C4BCExtensionObjectLine.ID);
    end;

    [ServiceEnabled]
    /// <summary>
    /// Create new object field for tableextensions or object value for enumextensions with existing ID.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specifies Object ID</param>
    /// <param name="FieldOrValueID">Integer, Specifies object field or value ID</param>
    /// <param name="CreatedBy">Text[50], Specifies user who requested new ID.</param>
    procedure CreateObjectFieldOrValueWithOwnID(ObjectType: Enum "C4BC Object Type"; ObjectID: Integer; FieldOrValueID: Integer; CreatedBy: Text[50])
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");

        C4BCExtensionObjectLine.SetRange("Extension Code", Rec.Code);
        C4BCExtensionObjectLine.SetRange("Object Type", ObjectType);
        C4BCExtensionObjectLine.SetRange("Object ID", ObjectID);
        C4BCExtensionObjectLine.SetRange(ID, FieldOrValueID);
        if not C4BCExtensionObjectLine.IsEmpty() then
            exit;

        C4BCExtensionObjectLine.Init();
        C4BCExtensionObjectLine.Validate("Extension Code", Rec."Code");
        C4BCExtensionObjectLine.Validate("Object Type", ObjectType);
        C4BCExtensionObjectLine.Validate("Object ID", ObjectID);
        C4BCExtensionObjectLine.Validate(ID, FieldOrValueID);
        C4BCExtensionObjectLine.Validate("Created By", CreatedBy);
        C4BCExtensionObjectLine.Insert(true);
    end;
}