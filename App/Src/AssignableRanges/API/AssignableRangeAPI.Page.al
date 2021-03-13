/// <summary>
/// Page C4BC Assignable Range API (ID 80009).
/// </summary>
page 80009 "C4BC Assignable Range API"
{
    PageType = API;
    Caption = 'Assignable Range API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
    EntityName = 'assignableRange';
    EntitySetName = 'assignableRanges';
    SourceTable = "C4BC Assignable Range Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            field("code"; Rec.Code)
            {
                ApplicationArea = All;
            }
            field(default; Rec.Default)
            {
                ApplicationArea = All;
            }
        }
    }
}