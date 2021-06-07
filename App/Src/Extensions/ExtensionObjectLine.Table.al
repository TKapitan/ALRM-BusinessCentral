/// <summary>
/// Table ART Extension Object Line (ID 74179006).
/// </summary>
table 74179006 "ART Extension Object Line"
{
    Caption = 'Extension Object Lines';

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            DataClassification = SystemMetadata;
            TableRelation = "ART Extension Header".Code where(Code = field("Extension Code"));
        }
        field(3; "Object Type"; Enum "ART Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = SystemMetadata;
            Editable = false;
            BlankZero = true;
            TableRelation = "ART Extension Object"."Object ID" where("Extension Code" = field("Extension Code"), "Object Type" = field("Object Type"));
        }
        field(5; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(6; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(7; "Created By"; Text[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(100; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("ART Extension Header"."Assignable Range Code" where("Code" = field("Extension Code")));
        }
        field(101; "Bus. Central Instance Filter"; Code[20])
        {
            Caption = 'Business Central Instance Filter';
            FieldClass = FlowFilter;
        }
        field(102; "Bus. Central Instance Linked"; Boolean)
        {
            Caption = 'Bus. Central Instance Linked';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("ART Extension Usage" where("Extension Code" = field("Extension Code"), "Business Central Instance Code" = field("Bus. Central Instance Filter")));
        }
    }

    keys
    {
        key(PK; "Extension Code", "Object Type", "Object ID", "ID")
        {
            Clustered = true;
        }
        key(Fields; "Object Type", "ID") { }
    }

    trigger OnInsert()
    begin
        if ID = 0 then
            ID := GetNewFieldLineID();

        if GuiAllowed then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    /// <summary> 
    /// Return new field ID for a field
    /// </summary>
    /// <returns>Return variable "Integer", new ID.</returns>
    procedure GetNewFieldLineID(): Integer
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
    begin
        Rec.CalcFields("Assignable Range Code");
        Rec.TestField("Assignable Range Code");

        ARTExtensionHeader.Get(Rec."Extension Code");
        ARTAssignableRangeHeader.Get("Assignable Range Code");
        exit(ARTAssignableRangeHeader.GetNewFieldID(Rec."Object Type", ARTExtensionHeader.GetUsageOfExtension()));
    end;

}