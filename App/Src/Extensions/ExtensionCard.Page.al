page 80005 "C4BC Extension Card"
{
    Caption = 'Extension Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "C4BC Extension Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the extension';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the extension';
                }
                field("Assignable Range Code"; Rec."Assignable Range Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Defines type of the id range used for this extension';
                }
            }
            part("Subform"; "C4BC Extension Subform")
            {
                Caption = 'Objects';
                ApplicationArea = All;
                SubPageLink = "Extension ID" = field(ID);
            }
        }
    }
}