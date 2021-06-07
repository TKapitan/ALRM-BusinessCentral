/// <summary>
/// Table ART Business Central Instance (ID 74179005).
/// </summary>
table 74179005 "ART Business Central Instance"
{
    Caption = 'Business Central Instance';
    LookupPageId = "ART Bus. Central Inst. List";
    DrillDownPageId = "ART Bus. Central Inst. List";
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
        ARTExtensionUsage: Record "ART Extension Usage";

        ExtensionUsageExistsErr: Label 'Record can not be deleted due to the existing %1.', Comment = '%1 - Name of the table with linked records';
    begin
        ARTExtensionUsage.SetRange("Business Central Instance Code", Rec.Code);
        if not ARTExtensionUsage.IsEmpty() then
            Error(ExtensionUsageExistsErr, ARTExtensionUsage.TableCaption());
    end;
}
