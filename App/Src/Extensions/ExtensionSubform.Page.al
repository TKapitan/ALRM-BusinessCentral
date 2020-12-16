page 80004 "C4BC Extension Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;
    SourceTable = "C4BC Extension Object";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    QuickEntry = true;
                    ToolTip = 'Object Type';

                    trigger OnValidate()
                    begin
                        UpdateHideValueForObjectID();
                    end;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    HideValue = HideValueForObjectID;
                    ToolTip = 'Object ID';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    QuickEntry = true;
                    ToolTip = 'Object Name';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Created By';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Object Lines")
            {
                Caption = 'Object Lines';
                ToolTip = 'Opens a list of the lines associated with selected object, it is only possible to assign lines to objects of type Table Extension, Enum Extension';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = ObjectFieldsActionEnabled;
                ApplicationArea = All;
                Image = AllLines;
                RunObject = page "C4BC Extension Object Lines";
                RunPageLink = "Extension Code" = field("Extension Code"), "Object ID" = field("Object ID"), "Object Type" = field("Object Type");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        UpdateHideValueForObjectID();
        if Rec."Object Type" in [Rec."Object Type"::"Table Extension", Rec."Object Type"::"Enum Extension"] then
            ObjectFieldsActionEnabled := true;
    end;

    var
        ObjectFieldsActionEnabled: Boolean;
        HideValueForObjectID: Boolean;

    local procedure UpdateHideValueForObjectID()
    var
        C4BCALRMManagement: Codeunit "C4BC ALRM Management";
    begin
        HideValueForObjectID := false;
        if not C4BCALRMManagement.UseObjectTypeIDs(Rec."Object Type", false) then
            HideValueForObjectID := true;
    end;
}