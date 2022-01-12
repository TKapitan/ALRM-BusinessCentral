/// <summary>
/// Table C4BC Object Type Configuration (ID 80008).
/// </summary>
table 80008 "C4BC Object Type Configuration"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Is Licensed"; Boolean)
        {
            Caption = 'Is Licensed';
            DataClassification = SystemMetadata;
        }
        field(20; "Has ID"; Boolean)
        {
            Caption = 'Has ID';
            DataClassification = SystemMetadata;
        }
        field(21; "Extends Other Objects"; Boolean)
        {
            Caption = 'Extends Other Objects';
            DataClassification = SystemMetadata;
        }

        field(30; "Max Name Length"; Integer)
        {
            Caption = 'Max Name Length';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Object Type")
        {
            Clustered = true;
        }
    }
}