page 80000 "C4BC Extension List"
{
    Caption = 'Extension List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "C4BC Extension Card";
    SourceTable = "C4BC Extension Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
        }
    }
}