/// <summary>
/// Page C4BC Extension Object API (ID 80011).
/// </summary>
page 80011 "C4BC Extension Object API"
{
    PageType = API;
    Caption = 'Extension Object API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
    EntityName = 'extensionObject';
    EntitySetName = 'extensionObjects';
    SourceTable = "C4BC Extension Object";
    DelayedInsert = true;

    ObsoleteState = Pending;
    ObsoleteReason = 'Replaced by v1.1; Will be removed in 2021/Q3.';
    ObsoleteTag = '2021/Q3';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(rangeCode; Rec."Assignable Range Code")
                {
                    ApplicationArea = All;
                }
                field("code"; Rec."Extension Code")
                {
                    ApplicationArea = All;
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
                part(extensionObjectLines; "C4BC Extension Object L. API")
                {
                    ApplicationArea = All;
                    EntityName = 'extensionObjectLine';
                    EntitySetName = 'extensionObjectLines';
                    SubPageLink = "Extension Code" = field("Extension Code"), "Object Type" = field("Object Type"), "Object ID" = field("Object ID");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.0");
    end;
}