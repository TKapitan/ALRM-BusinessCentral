/// <summary>
/// Table C4BC Extension Object Line (ID 80006).
/// </summary>
table 80006 "C4BC Extension Object Line"
{
    Caption = 'Extension Object Lines';

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Extension Header".Code where(Code = field("Extension Code"));
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
            Editable = false;
            BlankZero = true;
            TableRelation = "C4BC Extension Object"."Object ID" where("Extension Code" = field("Extension Code"), "Object Type" = field("Object Type"));
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
            CalcFormula = lookup("C4BC Extension Header"."Assignable Range Code" where("Code" = field("Extension Code")));
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
            CalcFormula = exist("C4BC Extension Usage" where("Extension Code" = field("Extension Code"), "Business Central Instance Code" = field("Bus. Central Instance Filter")));
        }
        field(103; "Alternate Assign. Range Code"; Code[20])
        {
            Caption = 'Alternate Assignable Range Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("C4BC Extension Header"."Alternate Assign. Range Code" where("Code" = field("Extension Code")));
        }
        field(104; "Alternate Object ID"; Integer)
        {
            Caption = 'AlternateObject ID';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("C4BC Extension Object"."Alternate Object ID" where("Extension Code" = field("Extension Code"), "Object Type" = field("Object Type"), "Object ID" = field("Object ID")));
        }
        field(150; "Alternate ID"; Integer)
        {
            Caption = 'Alternate ID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Extension Code", "Object Type", "Object ID", "ID")
        {
            Clustered = true;
        }
        key(Fields; "Object Type", "ID") { }
        key(AlternateFields; "Object Type", "Alternate ID") { }
    }

    trigger OnInsert()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
    begin
        Rec.CalcFields("Assignable Range Code", "Alternate Assign. Range Code");
        Rec.TestField("Assignable Range Code");
        if ID = 0 then
            ID := GetNewFieldLineID(Rec."Assignable Range Code", false);
        if ("Alternate ID" = 0) and (Rec."Alternate Assign. Range Code" <> '') then
            "Alternate ID" := GetNewFieldLineID(Rec."Alternate Assign. Range Code", true);

        C4BCExtensionHeader.Get(Rec."Extension Code");
        "Extension ID" := C4BCExtensionHeader.ID;
        if GuiAllowed then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    /// <summary> 
    /// Return new field ID for a field
    /// </summary>
    /// <param name="AssignableRangeCode">Code[20], Specifies code of assignable range from which the ID should be generated.</param>
    /// <param name="Alternate">Boolean, Specifies whether the ID is from alternate range or normal one.</param>
    /// <returns>Return variable "Integer", new ID.</returns>
    procedure GetNewFieldLineID(AssignableRangeCode: Code[20]; Alternate: Boolean): Integer
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        if Alternate then begin
            C4BCExtensionObjectLine.SetRange("Extension Code", Rec."Extension Code");
            C4BCExtensionObjectLine.SetRange("Object Type", Rec."Object Type");
            C4BCExtensionObjectLine.SetFilter("Object ID", '<>%1', Rec."Object ID");
            C4BCExtensionObjectLine.SetRange(ID, Rec.ID);
            C4BCExtensionObjectLine.SetFilter("Alternate ID", '<>0');
            if C4BCExtensionObjectLine.FindFirst() then
                exit(C4BCExtensionObjectLine."Alternate ID");
        end;

        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCAssignableRangeHeader.Get(AssignableRangeCode);
        exit(C4BCAssignableRangeHeader.GetNewFieldID(Rec."Object Type", C4BCExtensionHeader.GetUsageOfExtension()));
    end;

}