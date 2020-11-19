codeunit 79003 "C4BC Object Range Test Library"
{
    /// <summary> 
    /// Code for #1 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_01(): Code[20]
    begin
        exit('RANGE1');
    end;

    /// <summary> 
    /// Code for #2 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_02(): Code[20]
    begin
        exit('RANGE2');
    end;

    /// <summary> 
    /// Code for #3 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_03(): Code[20]
    begin
        exit('RANGE3');
    end;

    /// <summary> 
    /// Code for #4 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_04(): Code[20]
    begin
        exit('RANGE4');
    end;

    /// <summary> 
    /// Code for #5 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_05(): Code[20]
    begin
        exit('RANGE5');
    end;

    /// <summary> 
    /// Code for #6 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCAssignableRangeHeader_Code_06(): Code[20]
    begin
        exit('RANGE6');
    end;

    /// <summary> 
    /// Initializace records for assignable range tests
    /// </summary>
    procedure InitializeAssignableRanges()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionLine: Record "C4BC Extension Line";
    begin
        C4BCAssignableRangeHeader.DeleteAll();
        C4BCAssignableRangeLine.DeleteAll();
        C4BCExtensionHeader.DeleteAll();
        C4BCExtensionLine.DeleteAll();

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_01();
        C4BCAssignableRangeHeader."No. Series" := 'CUST';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Range From" := 30000;
        C4BCAssignableRangeHeader."Default Range To" := 39000;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeLine.Init();
        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_01();
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::"XML Port";
        C4BCAssignableRangeLine."Object Range From" := 99000;
        C4BCAssignableRangeLine."Object Range To" := 99999;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_02();
        // C4BCAssignableRangeHeader."No. Series" DO NOT SPECIFY
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_03();
        C4BCAssignableRangeHeader."No. Series" := 'CUST';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := true;
        C4BCAssignableRangeHeader."Default Range From" := 40000;
        C4BCAssignableRangeHeader."Default Range To" := 49000;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeLine.Init();
        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_03();
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::"Page Extension";
        C4BCAssignableRangeLine."Object Range From" := 10000;
        C4BCAssignableRangeLine."Object Range To" := 10010;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_04();
        C4BCAssignableRangeHeader."No. Series" := 'CUST';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Range From" := 60000;
        C4BCAssignableRangeHeader."Default Range To" := 69000;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeLine.Init();
        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_04();
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::"XML Port";
        C4BCAssignableRangeLine."Object Range From" := 75000;
        C4BCAssignableRangeLine."Object Range To" := 75020;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeLine.Init();
        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_04();
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::Enum;
        C4BCAssignableRangeLine."Object Range From" := 100000;
        C4BCAssignableRangeLine."Object Range To" := 100010;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_05();
        C4BCAssignableRangeHeader."No. Series" := 'CUST';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Range From" := 65000;
        C4BCAssignableRangeHeader."Default Range To" := 66000;
        C4BCAssignableRangeHeader."Object Name Template" := '';
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_06();
        C4BCAssignableRangeHeader."No. Series" := 'CUST';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Range From" := 66000;
        C4BCAssignableRangeHeader."Default Range To" := 67000;
        C4BCAssignableRangeHeader."Object Name Template" := '';
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);
    end;

    /// <summary> 
    /// Initializace records for extension tests/// 
    /// </summary>
    procedure InitializeExtensions()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionLine: Record "C4BC Extension Line";
    begin
        C4BCExtensionHeader.DeleteAll();
        C4BCExtensionLine.DeleteAll();

        // First Extension Header
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.Insert();

        // First Extension Lines
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::Table);
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::Table);
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::Report);
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"XML Port");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"XML Port");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"Table Extension");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);

        // Second Extension Header (same assignable range)
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.Insert();

        // Second Extension Lines
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"Table Extension");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);

        // Third Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_03());
        C4BCExtensionHeader.Insert();

        // Fourth Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_04());
        C4BCExtensionHeader.Insert();

        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"XML Port");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"XML Port");
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);

        // Fifth Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_06());
        C4BCExtensionHeader.Insert();

        C4BCExtensionLine.Init();
        C4BCExtensionLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionLine.Validate("Object Type", C4BCExtensionLine."Object Type"::"XML Port");
        C4BCExtensionLine."Object Name" := 'TKA Sales Header';
        C4BCExtensionLine.Insert();
        Clear(C4BCExtensionLine);
    end;

    /// <summary> 
    /// Set object name template for some headers for test scenarious
    /// </summary>
    procedure SetObjectNameTemplate()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_01());
        C4BCAssignableRangeHeader."Object Name Template" := 'C4BC *';
        C4BCAssignableRangeHeader.Modify();
    end;

    /// <summary> 
    /// Set usage of some extensions for test scenarious
    /// </summary>
    procedure SetExtensionUsage()
    var
        C4BCBusinessCentralInstance: Record "C4BC Business Central Instance";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionUsage: Record "C4BC Extension Usage";
    begin
        C4BCBusinessCentralInstance.DeleteAll();
        C4BCExtensionUsage.DeleteAll();

        C4BCBusinessCentralInstance.Init();
        C4BCBusinessCentralInstance.Code := 'KEPTY.CZ';
        C4BCBusinessCentralInstance.Insert();

        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindSet();

        C4BCExtensionUsage.Init();
        C4BCExtensionUsage."Business Central Instance Code" := 'KEPTY.CZ';
        C4BCExtensionUsage."Extension Code" := C4BCExtensionHeader.Code;
        C4BCExtensionUsage.Insert();
        Clear(C4BCExtensionUsage);

        C4BCExtensionHeader.Next(1);

        C4BCExtensionUsage.Init();
        C4BCExtensionUsage."Business Central Instance Code" := 'KEPTY.CZ';
        C4BCExtensionUsage."Extension Code" := C4BCExtensionHeader.Code;
        C4BCExtensionUsage.Insert();
    end;
}