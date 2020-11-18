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
        field(10; "Ranges per Customer"; Boolean)
        {
            Caption = 'Ranges per Customer';
            DataClassification = SystemMetadata;
        }
        field(11; Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = SystemMetadata;

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
        field(15; "Default Range From"; Integer)
        {
            Caption = 'Default Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;
        }
        field(16; "Default Range To"; Integer)
        {
            Caption = 'Default Range To';
            MinValue = 0;
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
        fieldgroup(DropDown; "Code", Description) { }
    }

    trigger OnDelete()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";

        CannotDeleteLinkExistsErr: Label '%1 can not be deleted due to existing related records in %2.', Comment = '%1 - Caption of table in which the record can not be deleted, %2 - Caption of table where the link exists.';
    begin
        C4BCExtensionHeader.SetRange("Assignable Range Code", Rec."Code");
        if not C4BCExtensionHeader.IsEmpty() then
            Error(CannotDeleteLinkExistsErr, Rec.TableCaption(), C4BCExtensionHeader.TableCaption());
    end;
}