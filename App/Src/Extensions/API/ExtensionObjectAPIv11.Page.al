/// <summary>
/// Page ART Extension Object API v1.1 (ID 74179014).
/// </summary>
page 74179014 "ART Extension Object API v1.1"
{
    PageType = API;
    Caption = 'Extension Object API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.1';
    EntityName = 'extensionObject';
    EntitySetName = 'extensionObjects';
    SourceTable = "ART Extension Object";
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

    trigger OnAfterGetCurrRecord()
    var
        ARTALRMSetup: Record "ART ALRM Setup";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.1");
    end;
}