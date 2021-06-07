/// <summary>
/// Page C4BC Extension Usage List (ID 74179008).
/// </summary>
page 74179008 "C4BC Extension Usage List"
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

    actions
    {
        area(Navigation)
        {
            action(Extension)
            {
                Caption = 'Extension';
                ToolTip = 'Allows to view and edit extension.';
                Enabled = (Rec."Extension Code" <> '');
                Image = ExtendedDataEntry;
                RunObject = page "C4BC Extension Card";
                RunPageLink = Code = field("Extension Code");
                ApplicationArea = All;
            }
        }
    }
}
