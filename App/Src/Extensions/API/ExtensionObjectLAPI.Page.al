/// <summary>
/// Page ART Extension Object L. API (ID 74179012).
/// </summary>
page 74179012 "ART Extension Object L. API"
{
    PageType = API;
    Caption = 'Extension Object Lines API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
    EntityName = 'extensionObjectLine';
    EntitySetName = 'extensionObjectLines';
    SourceTable = "ART Extension Object Line";
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
                field("code"; Rec."Extension Code")
                {
                    ApplicationArea = All;
                }
                field(objectID; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field(objectType; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field(id; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(name; Rec.Name)
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
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ARTALRMSetup: Record "ART ALRM Setup";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.0");
    end;
}