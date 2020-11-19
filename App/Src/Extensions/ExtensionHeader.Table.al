table 80000 "C4BC Extension Header"
{
    Caption = 'Extension Header';
    LookupPageId = "C4BC Extension List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(2; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(3; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Assignable Range Header".Code;
            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";
                NoSerisManagement: Codeunit NoSeriesManagement;
            begin
                if (Rec.Code = '') and (Rec."Assignable Range Code" <> '') then begin
                    AssignableRangeHeader.Get(Rec."Assignable Range Code");
                    AssignableRangeHeader.TestField("No. Series");
                    Rec.Code := NoSerisManagement.GetNextNo3(AssignableRangeHeader."No. Series", Today, true, true);
                end;
            end;
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            FieldClass = FlowField;
            CalcFormula = lookup("C4BC Assignable Range Header"."No. Series" where(Code = field("Assignable Range Code")));
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        Rec.TestField("Assignable Range Code");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if LinesExist() then
            Error(DeleteHeaderWithExistingLinesErr);
    end;

    trigger OnRename()
    begin

    end;

    local procedure LinesExist(): Boolean
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.SetRange("Extension Code", Rec.Code);
        if not C4BCExtensionObject.IsEmpty then
            exit(true);
    end;

    var
        DeleteHeaderWithExistingLinesErr: Label 'Extension header cannot be deleted due to the existing lines.';

}