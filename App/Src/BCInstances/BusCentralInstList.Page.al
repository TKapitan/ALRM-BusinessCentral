page 80007 "C4BC Bus. Central Inst. List"
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
}
