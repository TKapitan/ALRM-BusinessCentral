/// <summary>
/// Page C4BC Extension Object API v1.1 (ID 80014).
/// </summary>
page 80014 "C4BC Extension Object API v1.1"
{
    PageType = API;
    Caption = 'Extension Object API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.1';
    EntityName = 'extensionObject';
    EntitySetName = 'extensionObjects';
    SourceTable = "C4BC Extension Object";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId) { }
                field(rangeCode; Rec."Assignable Range Code") { }
                field("code"; Rec."Extension Code") { }
                field(systemCreatedAt; Rec.SystemCreatedAt) { }
                field(systemCreatedBy; Rec.SystemCreatedBy) { }
                field(systemModifiedAt; Rec.SystemModifiedAt) { }
                field(systemModifiedBy; Rec.SystemModifiedBy) { }
            }
        }
    }
}