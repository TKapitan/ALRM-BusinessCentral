/// <summary>
/// Table ART ALRM Setup (ID 74179007).
/// </summary>
table 74179007 "ART ALRM Setup"
{
    Caption = 'ALRM Setup';
    DrillDownPageId = "ART ALRM Setup";
    LookupPageId = "ART ALRM Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(5; "Minimal API Version"; Enum "ART API Version")
        {
            Caption = 'Minimal API Version';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Check whether the specified API version is within allowed version.
    /// </summary>
    /// <param name="CalledAPIVersion">Enum "ART API Version", specifies used API version.</param>
    procedure CheckAPIVersion(CalledAPIVersion: Enum "ART API Version")
    var
        ErrorTextErr: Label 'It is neccessary to use minimal API version %1 but %2 was used.', Comment = '%1 - Minimal supported API Version, %2 - Used API Version';
    begin
        if Rec."Minimal API Version".AsInteger() > CalledAPIVersion.AsInteger() then
            Error(ErrorTextErr, Rec."Minimal API Version", CalledAPIVersion);
    end;
}