table 80001 "C4BC Assignable Range Header"
{
    Caption = 'Assignable Range Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code") { }
    }
}