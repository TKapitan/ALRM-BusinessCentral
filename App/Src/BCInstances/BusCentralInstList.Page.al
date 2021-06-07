/// <summary>
/// Page ART Bus. Central Inst. List (ID 74179007).
/// </summary>
page 74179007 "ART Bus. Central Inst. List"
{
    Caption = 'Business Central Instances';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "ART Business Central Instance";
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
                RunObject = page "ART Extension Usage List";
                RunPageLink = "Business Central Instance Code" = field(Code);
                ApplicationArea = All;
            }
        }
    }
}
