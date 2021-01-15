/// <summary>
/// Table C4BC Business Central Instance (ID 80005).
/// </summary>
table 80005 "C4BC Business Central Instance"
{
    Caption = 'Business Central Instance';
    LookupPageId = "C4BC Bus. Central Inst. List";
    DrillDownPageId = "C4BC Bus. Central Inst. List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        C4BCExtensionUsage: Record "C4BC Extension Usage";

        ExtensionUsageExistsErr: Label 'Record can not be deleted due to the existing %1.', Comment = '%1 - Name of the table with linked records';
    begin
        C4BCExtensionUsage.SetRange("Business Central Instance Code", Rec.Code);
        if not C4BCExtensionUsage.IsEmpty() then
            Error(ExtensionUsageExistsErr, C4BCExtensionUsage.TableCaption());
    end;
}
