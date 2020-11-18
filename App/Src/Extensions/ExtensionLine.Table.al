table 80003 "C4BC Extension Line"
{
    Caption = 'Extension Line';

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            DataClassification = SystemMetadata;
        }
        field(2; "Extension ID"; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Extension Header".ID;
        }
        field(3; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = SystemMetadata;
        }
        field(5; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
            DataClassification = SystemMetadata;
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
    }

    keys
    {
        key(PK; "Extension Code", "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}