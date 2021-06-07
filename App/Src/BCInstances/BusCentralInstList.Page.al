/// <summary>
/// Page C4BC Bus. Central Inst. List (ID 74179007).
/// </summary>
page 74179007 "C4BC Bus. Central Inst. List"
{
    Caption = 'Business Central Instances';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "C4BC Business Central Instance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies code of the business central instance.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies description of the business central instance.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Usage)
            {
                Caption = 'Usage';
                ToolTip = 'Allows to view and edit usage for selected business central instance.';
                Enabled = (Rec."Code" <> '');
                Image = LinkWithExisting;
                RunObject = page "C4BC Extension Usage List";
                RunPageLink = "Business Central Instance Code" = field(Code);
                ApplicationArea = All;
            }
        }
    }
}
