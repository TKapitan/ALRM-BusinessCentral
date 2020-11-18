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
}