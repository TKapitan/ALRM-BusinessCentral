/// <summary>
/// Page ART Assignable Range API (ID 74179009).
/// </summary>
page 74179009 "ART Assignable Range API"
{
    PageType = API;
    Caption = 'Assignable Range API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0', 'v1.1';
    EntityName = 'assignableRange';
    EntitySetName = 'assignableRanges';
    SourceTable = "ART Assignable Range Header";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field("code"; Rec.Code) { }
            field(description; Rec.Description) { }
            field(defaultObjectRangeFrom; Rec."Default Object Range From") { }
            field(defaultObjectRangeTo; Rec."Default Object Range To") { }
            field(objectNameTemplate; Rec."Object Name Template") { }
            field(default; Rec.Default) { }
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