table 80004 "C4BC Extension Usage"
{
    Caption = 'Extension Usage';
    LookupPageId = "C4BC Extension Usage List";
    DrillDownPageId = "C4BC Extension Usage List";
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
            Caption = 'Business Central Instance Code';
            TableRelation = "C4BC Business Central Instance"."Code";
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