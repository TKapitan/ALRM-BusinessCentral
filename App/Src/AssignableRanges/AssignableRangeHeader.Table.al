table 80001 "C4BC Assignable Range Header"
{
    Caption = 'Assignable Range Header';
    LookupPageId = "C4BC Assignable Range List";
    DrillDownPageId = "C4BC Assignable Range List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";

                CannotHaveMoreDefaultRangesErr: Label 'There is already existing default assignable range.';
            begin
                if Rec.Default and not xRec.Default then begin
                    AssignableRangeHeader.SetFilter(Code, '<>%1', Rec.Code);
                    AssignableRangeHeader.SetRange(Default, true);
                    if not AssignableRangeHeader.IsEmpty() then
                        Error(CannotHaveMoreDefaultRangesErr);
                end;
            end;
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
        fieldgroup(DropDown; "Code", Description) { }
    }

    // TODO Ondelete/Onmodify Check whether it's used somewhere
}