/// <summary>
/// Page C4BC Extension Object API v1.1 (ID 80014).
/// </summary>
page 79514 "C4BC Extension Object API v1.1"
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
                field(extensionID; Rec."Extension ID") { }
                field(rangeCode; Rec."Assignable Range Code") { }
                field(alternateRangeCode; Rec."Alternate Assign. Range Code") { }
                field(objectType; Rec."Object Type") { }
                field(objectID; Rec."Object ID") { }
                field(alternateObjectID; Rec."Alternate Object ID") { }
                field("code"; Rec."Extension Code") { }
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
}