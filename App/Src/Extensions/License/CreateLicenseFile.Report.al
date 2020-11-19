report 80000 "C4BC Create License File"
{
    Caption = 'Create License File';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("C4BC Extension Usage"; "C4BC Extension Usage")
        {
            trigger OnPreDataItem()
            begin
                "C4BC Extension Usage".SetRange("Business Central Instance Code", ForBCInstanceCode);
                "C4BC Extension Usage".SetFilter("Starting Date", '<=%1', ToDate);
                "C4BC Extension Usage".SetFilter("Ending Date", '>=%1|%2', ToDate, 0D);

                if not TempC4BCAssignableRangeLine.IsTemporary() then
                    Error('');
                TempC4BCAssignableRangeLine.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            var
                C4BCExtensionObject: Record "C4BC Extension Object";

                C4BCIObjectLicensing: Interface "C4BC IObject Licensing";
                CurrObjectID: Integer;
            begin
                C4BCExtensionObject.SetRange("Extension Code", "C4BC Extension Usage"."Extension Code");
                if C4BCExtensionObject.FindSet() then
                    repeat
                        CurrObjectID := C4BCExtensionObject."Object ID";
                        C4BCIObjectLicensing := C4BCExtensionObject."Object Type";
                        if C4BCIObjectLicensing.IsLicensed() and (CurrObjectID <> 0) then begin
                            Clear(TempC4BCAssignableRangeLine);

                            TempC4BCAssignableRangeLine.SetRange("Object Type", C4BCExtensionObject."Object Type");
                            TempC4BCAssignableRangeLine.SetRange("Object Range From", CurrObjectID + 1);
                            if TempC4BCAssignableRangeLine.FindFirst() then
                                // Add new object at the beginning of existing range
                                TempC4BCAssignableRangeLine.Rename('', C4BCExtensionObject."Object Type", CurrObjectID)
                            else begin
                                TempC4BCAssignableRangeLine.SetRange("Object Range From");
                                TempC4BCAssignableRangeLine.SetRange("Object Range To", CurrObjectID - 1);
                                if TempC4BCAssignableRangeLine.FindFirst() then begin
                                    // Add new object at the end of existing range
                                    TempC4BCAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempC4BCAssignableRangeLine.Modify(false);
                                end else begin
                                    // Create new range
                                    Clear(TempC4BCAssignableRangeLine);
                                    TempC4BCAssignableRangeLine.Init();
                                    TempC4BCAssignableRangeLine."Assignable Range Code" := '';
                                    TempC4BCAssignableRangeLine."Object Type" := C4BCExtensionObject."Object Type";
                                    TempC4BCAssignableRangeLine."Object Range From" := CurrObjectID;
                                    TempC4BCAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempC4BCAssignableRangeLine.Insert(false);
                                end;
                            end;
                        end;
                    until C4BCExtensionObject.Next() < 1;
            end;

            trigger OnPostDataItem()
            var
                ExportedText: TextBuilder;

                CSVHeaderTxt: Label 'ObjectType,FromObjectID,ToObjectID,Read,Insert,Modify,Delete,Execute,AvailableRange,Used,ObjectTypeRemaining,CompanyObjectPermissionID', Locked = true;
            begin
                Clear(TempC4BCAssignableRangeLine);
                if not TempC4BCAssignableRangeLine.FindSet() then
                    exit;

                ExportedText.AppendLine(CSVHeaderTxt);
                repeat
                    ExportedText.AppendLine(BuildLicenseLine(TempC4BCAssignableRangeLine));
                until TempC4BCAssignableRangeLine.Next() < 1;
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
                        TableRelation = "C4BC Business Central Instance".Code;
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
        TempC4BCAssignableRangeLine: Record "C4BC Assignable Range Line" temporary;
        ForBCInstanceCode: Code[20];
        ToDate: Date;

    /// <summary> 
    /// Create a file line with license details for specific range of used objects
    /// </summary>
    /// <param name="TempLineToExportC4BCAssignableRangeLine">PRecord "C4BC Assignable Range Line" temporary, specifies details of the current range.</param>
    /// <returns>Return variable "Text", details about current range in the requested format.</returns>
    local procedure BuildLicenseLine(TempLineToExportC4BCAssignableRangeLine: Record "C4BC Assignable Range Line" temporary): Text
    var
        BuildedLine: TextBuilder;

        SplitingCharTxt: Label ',';
        DirectPermissionTxt: Label 'Direct';
        NullTxt: Label '0';
    begin
        BuildedLine.Append(Format(TempLineToExportC4BCAssignableRangeLine."Object Type")); // TODO set right format that is required by Microsoft
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempLineToExportC4BCAssignableRangeLine."Object Range From"));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempLineToExportC4BCAssignableRangeLine."Object Range To"));
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
        BuildedLine.Append('0 - 0'); // TODO Available Range from Assignable Record
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempLineToExportC4BCAssignableRangeLine."Object Range To" - TempLineToExportC4BCAssignableRangeLine."Object Range From" + 1));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        exit(BuildedLine.ToText());
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
}