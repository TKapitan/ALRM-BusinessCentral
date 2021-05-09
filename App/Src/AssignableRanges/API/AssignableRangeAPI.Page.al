/// <summary>
/// Page C4BC Assignable Range API (ID 80009).
/// </summary>
page 80009 "C4BC Assignable Range API"
{
    PageType = API;
    Caption = 'Assignable Range API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0', 'v1.1';
    EntityName = 'assignableRange';
    EntitySetName = 'assignableRanges';
    SourceTable = "C4BC Assignable Range Header";
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
        C4BCALRMSetup: Record "C4BC ALRM Setup";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");
    end;
}