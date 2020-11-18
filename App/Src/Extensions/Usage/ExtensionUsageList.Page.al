page 80008 "C4BC Extension Usage List"
{
    Caption = 'Extension Usage List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "C4BC Extension Usage";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Extension Code"; Rec."Extension Code")
                {
                    ToolTip = 'Specifies code of the extension to which this record is related.';
                    ApplicationArea = All;
                }
                field("Business Central Instance Code"; Rec."Business Central Instance Code")
                {
                    ToolTip = 'Specifies instance of Business Central on which the extension is installed.';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies date from which the extension is installed on the instance.';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies date to which the extension was installed on the instance.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
