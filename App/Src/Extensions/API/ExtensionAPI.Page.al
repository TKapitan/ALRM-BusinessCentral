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
                    SubPageLink = "Extension ID" = field(ID);
                }
            }
        }
    }

    [ServiceEnabled]
    procedure CreateLine(ObjectType: Enum "C4BC Object Type"; ObjectID: Integer; ObjectName: Text[100]; CreatedBy: Text[50])
    var
        ExtensionLine: Record "C4BC Extension Line";
    begin
        if not ExtensionLine.Get(Rec.Code, ObjectType, ObjectID) then begin
            ExtensionLine.Init();
            ExtensionLine."Extension Code" := Rec.Code;
            ExtensionLine.Validate("Object Type", ObjectType);
            ExtensionLine.Validate("Object ID", ExtensionLine.GetNewObjectID());
            ExtensionLine.Validate("Object Name", ObjectName);
            ExtensionLine.Validate("Created By", CreatedBy);
            ExtensionLine.Insert(true);
        end;
    end;
}