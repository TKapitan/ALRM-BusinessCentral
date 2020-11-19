page 80006 "C4BC Extension API"
{
    PageType = API;
    Caption = 'Extension API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
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
                part("Extension Objects"; "C4BC Extension Object API")
                {
                    ApplicationArea = All;
                    EntityName = 'extensionObject';
                    EntitySetName = 'extensionObjects';
                    SubPageLink = "Extension Code" = field(Code);
                }
            }
        }
    }

    [ServiceEnabled]
    /// <summary> 
    /// Create new object with specified name and type.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateObject(ObjectType: Enum "C4BC Object Type"; ObjectName: Text[100]; CreatedBy: Text[50]): Integer
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.Init();
        C4BCExtensionObject."Extension Code" := Rec.Code;
        C4BCExtensionObject.Validate("Object Type", ObjectType);
        C4BCExtensionObject.Validate("Object Name", ObjectName);
        C4BCExtensionObject.Validate("Created By", CreatedBy);
        C4BCExtensionObject.Insert(true);
        exit(C4BCExtensionObject."Object ID");
    end;
}