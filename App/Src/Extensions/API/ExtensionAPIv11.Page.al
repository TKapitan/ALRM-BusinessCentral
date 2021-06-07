/// <summary>
/// Page ART Extension API v1.1 (ID 74179013).
/// </summary>
page 74179013 "ART Extension API v1.1"
{
    PageType = API;
    Caption = 'Extension API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.1';
    EntityName = 'extension';
    EntitySetName = 'extensions';
    SourceTable = "ART Extension Header";
    DelayedInsert = true;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(rangeCode; Rec."Assignable Range Code")
                {
                    ApplicationArea = All;
                }
                field("code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(id; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ARTALRMSetup: Record "ART ALRM Setup";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");
    end;

    [ServiceEnabled]
    /// <summary> 
    /// Create new object with specified name and type.
    /// </summary>
    /// <param name="ObjectType">Enum "ART Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="ExtendsObjectName">Text[100], Specifies name of object that the newly created object extends. Can be filled in for extension objects only.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateObject(ObjectType: Enum "ART Object Type"; ObjectName: Text[100]; ExtendsObjectName: Text[100]; CreatedBy: Text[50]): Integer
    var
        ARTALRMSetup: Record "ART ALRM Setup";
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");

        ARTExtensionObject.SetRange("Extension Code", Rec.Code);
        ARTExtensionObject.SetRange("Object Type", ObjectType);
        ARTExtensionObject.SetRange("Object Name", ObjectName);
        if ARTExtensionObject.FindFirst() then begin
            ARTExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
            ARTExtensionObject.Modify(true);
            exit(ARTExtensionObject."Object ID");
        end;

        ARTExtensionObject.Init();
        ARTExtensionObject."Extension Code" := Rec.Code;
        ARTExtensionObject.Validate("Object Type", ObjectType);
        ARTExtensionObject.Validate("Object Name", ObjectName);
        ARTExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
        ARTExtensionObject.Validate("Created By", CreatedBy);
        ARTExtensionObject.Insert(true);
        exit(ARTExtensionObject."Object ID");
    end;

    [ServiceEnabled]
    /// <summary> 
    /// Create new object with specified name and type.
    /// </summary>
    /// <param name="ObjectType">Enum "ART Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specify object name.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="ExtendsObjectName">Text[100], Specifies name of object that the newly created object extends. Can be filled in for extension objects only.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateObjectWithOwnID(ObjectType: Enum "ART Object Type"; ObjectID: Integer; ObjectName: Text[100]; ExtendsObjectName: Text[100]; CreatedBy: Text[50])
    var
        ARTALRMSetup: Record "ART ALRM Setup";
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");

        ARTExtensionObject.SetRange("Extension Code", Rec.Code);
        ARTExtensionObject.SetRange("Object Type", ObjectType);
        ARTExtensionObject.SetRange("Object ID", ObjectID);
        ARTExtensionObject.SetRange("Object Name", ObjectName);
        if ARTExtensionObject.FindFirst() then begin
            ARTExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
            ARTExtensionObject.Modify(true);
            exit;
        end;

        ARTExtensionObject.Init();
        ARTExtensionObject."Extension Code" := Rec.Code;
        ARTExtensionObject.Validate("Object Type", ObjectType);
        ARTExtensionObject.Validate("Object ID", ObjectID);
        ARTExtensionObject.Validate("Object Name", ObjectName);
        ARTExtensionObject.Validate("Extends Object Name", ExtendsObjectName);
        ARTExtensionObject.Validate("Created By", CreatedBy);
        ARTExtensionObject.Insert(true);
    end;

    [ServiceEnabled]
    /// <summary>
    /// Create new object field for tableextensions or object value for enumextensions.
    /// </summary>
    /// <param name="ObjectType">Enum "ART Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specifies Object ID</param>
    /// <param name="CreatedBy">Text[50], Specifies user who requested new ID.</param>
    /// <returns>Return variable "Integer", ID of the object line.</returns>
    procedure CreateObjectFieldOrValue(ObjectType: Enum "ART Object Type"; ObjectID: Integer; CreatedBy: Text[50]): Integer
    var
        ARTALRMSetup: Record "ART ALRM Setup";
        ARTExtensionObjectLine: Record "ART Extension Object Line";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");

        ARTExtensionObjectLine.Init();
        ARTExtensionObjectLine.Validate("Extension Code", Rec."Code");
        ARTExtensionObjectLine.Validate("Object Type", ObjectType);
        ARTExtensionObjectLine.Validate("Object ID", ObjectID);
        ARTExtensionObjectLine.Validate("Created By", CreatedBy);
        ARTExtensionObjectLine.Insert(true);
        exit(ARTExtensionObjectLine.ID);
    end;

    [ServiceEnabled]
    /// <summary>
    /// Create new object field for tableextensions or object value for enumextensions with existing ID.
    /// </summary>
    /// <param name="ObjectType">Enum "ART Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectID">Integer, Specifies Object ID</param>
    /// <param name="FieldOrValueID">Integer, Specifies object field or value ID</param>
    /// <param name="CreatedBy">Text[50], Specifies user who requested new ID.</param>
    procedure CreateObjectFieldOrValueWithOwnID(ObjectType: Enum "ART Object Type"; ObjectID: Integer; FieldOrValueID: Integer; CreatedBy: Text[50])
    var
        ARTALRMSetup: Record "ART ALRM Setup";
        ARTExtensionObjectLine: Record "ART Extension Object Line";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");

        ARTExtensionObjectLine.SetRange("Extension Code", Rec.Code);
        ARTExtensionObjectLine.SetRange("Object Type", ObjectType);
        ARTExtensionObjectLine.SetRange("Object ID", ObjectID);
        ARTExtensionObjectLine.SetRange(ID, FieldOrValueID);
        if not ARTExtensionObjectLine.IsEmpty() then
            exit;

        ARTExtensionObjectLine.Init();
        ARTExtensionObjectLine.Validate("Extension Code", Rec."Code");
        ARTExtensionObjectLine.Validate("Object Type", ObjectType);
        ARTExtensionObjectLine.Validate("Object ID", ObjectID);
        ARTExtensionObjectLine.Validate(ID, FieldOrValueID);
        ARTExtensionObjectLine.Validate("Created By", CreatedBy);
        ARTExtensionObjectLine.Insert(true);
    end;
}