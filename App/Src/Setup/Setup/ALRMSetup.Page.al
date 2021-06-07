/// <summary>
/// Page C4BC ALRM Setup (ID 74179016).
/// </summary>
page 74179016 "C4BC ALRM Setup"
{
    Caption = 'ALRM Setup';
    PageType = Card;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "C4BC ALRM Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Minimal API Version"; Rec."Minimal API Version")
                {
                    ToolTip = 'Specifies minimal version of API that can be called from external system. If a lower version of API is called, an error is returned instead of response.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}