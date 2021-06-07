/// <summary>
/// Page ART Extension Object API (ID 74179011).
/// </summary>
page 74179011 "ART Extension Object API"
{
    PageType = API;
    Caption = 'Extension Object API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.0';
    EntityName = 'extensionObject';
    EntitySetName = 'extensionObjects';
    SourceTable = "ART Extension Object";
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
                part(extensionObjectLines; "ART Extension Object L. API")
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
        ARTALRMSetup: Record "ART ALRM Setup";
    begin
        ARTALRMSetup.FindFirst();
        ARTALRMSetup.CheckAPIVersion(ARTALRMSetup."Minimal API Version"::"v1.0");
    end;
}