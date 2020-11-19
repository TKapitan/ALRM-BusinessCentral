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
    ODataKeyFields = ID;
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
                part(lines; "C4BC Extension Subform")
                {
                    ApplicationArea = All;
                    EntityName = 'line';
                    EntitySetName = 'lines';
                    SubPageLink = "Extension Code" = field(Code);
                }
            }
        }
    }

    [ServiceEnabled]
    /// <summary> 
    /// Create new line for specifies object type with specified name.
    /// </summary>
    /// <param name="ObjectType">Enum "C4BC Object Type", Specifies type of the object that should be registered.</param>
    /// <param name="ObjectName">Text[100], Specifies object name.</param>
    /// <param name="CreatedBy">Text[50], Specifies identification of user who required object registration.</param>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure CreateLine(ObjectType: Enum "C4BC Object Type"; ObjectName: Text[100]; CreatedBy: Text[50]): Integer
    var
        C4BCExtensionLine: Record "C4BC Extension Line";
    begin
        C4BCExtensionLine.Init();
        C4BCExtensionLine."Extension Code" := Rec.Code;
        C4BCExtensionLine.Validate("Object Type", ObjectType);
        C4BCExtensionLine.Validate("Object Name", ObjectName);
        C4BCExtensionLine.Validate("Created By", CreatedBy);
        C4BCExtensionLine.Insert(true);
        exit(C4BCExtensionLine."Object ID");
    end;
}