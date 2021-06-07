/// <summary>
/// Report ART Create License File (ID 74179000).
/// </summary>
report 74179000 "ART Create License File"
{
    Caption = 'Create License Object Range CSV file';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("ART Extension Usage"; "ART Extension Usage")
        {
            trigger OnPreDataItem()
            begin
                "ART Extension Usage".SetRange("Business Central Instance Code", ForBCInstanceCode);
                "ART Extension Usage".SetFilter("Starting Date", '<=%1', ToDate);
                "ART Extension Usage".SetFilter("Ending Date", '>=%1|%2', ToDate, 0D);

                if not TempARTAssignableRangeLine.IsTemporary() then
                    Error('');
                TempARTAssignableRangeLine.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            var
                ARTExtensionObject: Record "ART Extension Object";

                ARTIObjectLicensing: Interface "ART IObject Type";
                CurrObjectID: Integer;
            begin
                ARTExtensionObject.SetAutoCalcFields("Assignable Range Code");
                ARTExtensionObject.SetRange("Extension Code", "ART Extension Usage"."Extension Code");
                if ARTExtensionObject.FindSet() then
                    repeat
                        CurrObjectID := ARTExtensionObject."Object ID";
                        ARTIObjectLicensing := ARTExtensionObject."Object Type";
                        if ARTIObjectLicensing.IsLicensed() then begin
                            Clear(TempARTAssignableRangeLine);

                            TempARTAssignableRangeLine.SetRange("Assignable Range Code", ARTExtensionObject."Assignable Range Code");
                            TempARTAssignableRangeLine.SetRange("Object Type", ARTExtensionObject."Object Type");
                            TempARTAssignableRangeLine.SetRange("Object Range From", CurrObjectID + 1);
                            if TempARTAssignableRangeLine.FindFirst() then
                                // Add new object at the beginning of existing range
                                TempARTAssignableRangeLine.Rename(ARTExtensionObject."Assignable Range Code", ARTExtensionObject."Object Type", CurrObjectID)
                            else begin
                                TempARTAssignableRangeLine.SetRange("Object Range From");
                                TempARTAssignableRangeLine.SetRange("Object Range To", CurrObjectID - 1);
                                if TempARTAssignableRangeLine.FindFirst() then begin
                                    // Add new object at the end of existing range
                                    TempARTAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempARTAssignableRangeLine.Modify(false);
                                end else begin
                                    // Create new range
                                    Clear(TempARTAssignableRangeLine);
                                    TempARTAssignableRangeLine.Init();
                                    TempARTAssignableRangeLine."Assignable Range Code" := ARTExtensionObject."Assignable Range Code";
                                    TempARTAssignableRangeLine."Object Type" := ARTExtensionObject."Object Type";
                                    TempARTAssignableRangeLine."Object Range From" := CurrObjectID;
                                    TempARTAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempARTAssignableRangeLine.Insert(false);
                                end;
                            end;
                        end;
                    until ARTExtensionObject.Next() < 1;
            end;

            trigger OnPostDataItem()
            var
                ExportedText: TextBuilder;

                CSVHeaderTxt: Label 'ObjectType,FromObjectID,ToObjectID,Read,Insert,Modify,Delete,Execute,AvailableRange,Used,ObjectTypeRemaining,CompanyObjectPermissionID', Locked = true;
            begin
                Clear(TempARTAssignableRangeLine);
                if not TempARTAssignableRangeLine.FindSet() then
                    exit;

                ExportedText.AppendLine(CSVHeaderTxt);
                repeat
                    ExportedText.AppendLine(BuildLicenseLine(TempARTAssignableRangeLine));
                until TempARTAssignableRangeLine.Next() < 1;
                ExportLicenseFile(ExportedText);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'General';
                    field(ForBCInstanceCodeField; ForBCInstanceCode)
                    {
                        Caption = 'For Business Central Instance';
                        ToolTip = 'Specifies code of the Business Central instance for which we want to export the license.';
                        TableRelation = "ART Business Central Instance".Code;
                        ApplicationArea = All;
                    }
                    field(ToDateField; ToDate)
                    {
                        Caption = 'To Date';
                        ToolTip = 'Specifies to which date we want to create list of used objects.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        ToDate := WorkDate();
    end;

    var
        TempARTAssignableRangeLine: Record "ART Assignable Range Line" temporary;
        ForBCInstanceCode: Code[20];
        ToDate: Date;

    /// <summary> 
    /// Create a file line with license details for specific range of used objects
    /// </summary>
    /// <param name="TempExpARTAssignableRangeLine">PRecord "ART Assignable Range Line" temporary, specifies details of the current range.</param>
    /// <returns>Return variable "Text", details about current range in the requested format.</returns>
    local procedure BuildLicenseLine(TempExpARTAssignableRangeLine: Record "ART Assignable Range Line" temporary): Text
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";

        BuildedLine: TextBuilder;
        FirstRangeID, LastRangeID : Integer;

        SplitingCharTxt: Label ',', Locked = true;
        DirectPermissionTxt: Label 'Direct', Locked = true;
        NullTxt: Label '0', Locked = true;
    begin
        BuildedLine.Append(Format(GetObjectTypeFormattedForLicenseGenerator(TempExpARTAssignableRangeLine."Object Type")));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpARTAssignableRangeLine."Object Range From"));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpARTAssignableRangeLine."Object Range To"));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);

        ARTAssignableRangeHeader.Get(TempExpARTAssignableRangeLine."Assignable Range Code");
        FirstRangeID := ARTAssignableRangeHeader.GetVeryFirstObjectIDFromRangeBasedOnObjectID(TempExpARTAssignableRangeLine."Object Type", TempExpARTAssignableRangeLine."Object Range From");
        LastRangeID := ARTAssignableRangeHeader.GetVeryLastObjectIDFromRangeBasedOnObjectID(TempExpARTAssignableRangeLine."Object Type", TempExpARTAssignableRangeLine."Object Range To");

        BuildedLine.Append(Format(FirstRangeID) + ' - ' + Format(LastRangeID));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpARTAssignableRangeLine."Object Range To" - TempExpARTAssignableRangeLine."Object Range From" + 1));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        exit(BuildedLine.ToText());
    end;

    /// <summary> 
    /// Description for GetObjectTypeFormattedForLicenseGenerator.
    /// </summary>
    /// <param name="OriginalARTObjectType">Parameter of type Enum "ART Object Type".</param>
    /// <returns>Return variable "Text".</returns>
    local procedure GetObjectTypeFormattedForLicenseGenerator(OriginalARTObjectType: Enum "ART Object Type"): Text
    var
        IsHandled: Boolean;
        TempText: Text;
    begin
        OnGetObjectTypeFormattedForLicenseGenerator(IsHandled, OriginalARTObjectType, TempText);
        if IsHandled then
            exit(TempText);

        case OriginalARTObjectType of
            OriginalARTObjectType::Table:
                exit('TableData');
            OriginalARTObjectType::"XML Port":
                exit('XMLPort');
            else
                exit(Format(OriginalARTObjectType));
        end;
    end;

    /// <summary> 
    /// Create and download file that contains license details
    /// </summary>
    /// <param name="ExportedText">TextBuilder, contains text that should be exported as a context of the downloaded file.</param>
    local procedure ExportLicenseFile(var ExportedText: TextBuilder)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";

        OutStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(ExportedText.ToText());
        FileManagement.BLOBExportWithEncoding(TempBlob, 'ObjectPermissionExport.csv', true, TextEncoding::UTF8);
    end;

    [IntegrationEvent(false, false)]
    /// <summary> 
    /// Integration Event that is called when the object type enum is translated for license generator
    /// </summary>
    /// <param name="IsHandled">Boolean, if true, the value of ReturnAsObjectType parameter is returned and process ends.</param>
    /// <param name="OriginalARTObjectType">Enum "ART Object Type", specifies which object type should be translated.</param>
    /// <param name="ReturnAsObjectType">Text, return value (how the object type should be called in license generator).</param>
    local procedure OnGetObjectTypeFormattedForLicenseGenerator(IsHandled: Boolean; OriginalARTObjectType: Enum "ART Object Type"; var ReturnAsObjectType: Text)
    begin
    end;
}