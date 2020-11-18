table 80004 "C4BC Extension Usage"
{
    Caption = 'Extension Usage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            TableRelation = "C4BC Extension Header".Code;
            DataClassification = CustomerContent;
        }
        field(2; "Business Central Instance Code"; Code[20])
        {
            Caption = 'Extension Code';
            TableRelation = "C4BC Extension Usage"."Business Central Instance Code";
            DataClassification = CustomerContent;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Extension Code", "Business Central Instance Code", "Starting Date")
        {
            Clustered = true;
        }
    }
}