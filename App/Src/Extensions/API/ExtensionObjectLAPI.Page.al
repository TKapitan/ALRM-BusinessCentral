page 80012 "C4BC Extension Object L. API"
{
    PageType = API;
    Caption = 'Extension Object Lines API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
    EntityName = 'extensionObjectLine';
    EntitySetName = 'extensionObjectLines';
    SourceTable = "C4BC Extension Object Line";
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
                field("code"; Rec."Extension Code")
                {
                    ApplicationArea = All;
                }
                field(objectID; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field(objectType; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field(id; Rec.ID)
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
}