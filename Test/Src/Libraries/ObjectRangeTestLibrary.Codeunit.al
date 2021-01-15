/// <summary>
/// Codeunit C4BC Object Range Test Library (ID 79003).
/// </summary>
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
    /// Code for #1 business central instance
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCBusinessCentralInstance_Code_01(): Code[20]
    begin
        exit('KEPTY.CZ');
    end;

    /// <summary> 
    /// Code for #2 business central instance
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure C4BCBusinessCentralInstance_Code_02(): Code[20]
    begin
        exit('KEPTYCZ.CZ');
    end;

    /// <summary>
    /// Initialize no series for assignable ranges and extension tests.
    /// </summary>
    procedure InitializeNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Init();
        NoSeries.Code := 'ALRM-EXT';
        NoSeries."Default Nos." := true;
        if NoSeries.Insert(true) then;

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Starting No." := 'EXT001';
        if NoSeriesLine.Insert(true) then;
    end;

    /// <summary> 
    /// Initialize records for assignable range tests
    /// </summary>
    procedure InitializeAssignableRanges()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCAssignableRangeHeader.DeleteAll();
        C4BCAssignableRangeLine.DeleteAll();
        C4BCExtensionHeader.DeleteAll();
        C4BCExtensionObject.DeleteAll();

        InitializeNoSeries();

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_01();
        C4BCAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Object Range From" := 30000;
        C4BCAssignableRangeHeader."Default Object Range To" := 39000;
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
        C4BCAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := true;
        C4BCAssignableRangeHeader."Default Object Range From" := 40000;
        C4BCAssignableRangeHeader."Default Object Range To" := 49000;
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
        C4BCAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Object Range From" := 60000;
        C4BCAssignableRangeHeader."Default Object Range To" := 69000;
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
        C4BCAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Object Range From" := 65000;
        C4BCAssignableRangeHeader."Default Object Range To" := 66000;
        C4BCAssignableRangeHeader."Object Name Template" := '';
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeLine.Init();
        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_05();
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::"Enum Extension";
        C4BCAssignableRangeLine."Object Range From" := 110000;
        C4BCAssignableRangeLine."Object Range To" := 110010;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeHeader.Init();
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_06();
        C4BCAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        C4BCAssignableRangeHeader."Ranges per BC Instance" := false;
        C4BCAssignableRangeHeader."Default Object Range From" := 66000;
        C4BCAssignableRangeHeader."Default Object Range To" := 67000;
        C4BCAssignableRangeHeader."Object Name Template" := '';
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);
    end;


    /// <summary> 
    /// Initializace records for assignable field range tests
    /// </summary>
    procedure InitializeAssignableFieldRanges()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_01());
        C4BCAssignableRangeHeader."Field Range From" := 200000;
        C4BCAssignableRangeHeader."Field Range To" := 250000;
        C4BCAssignableRangeHeader.Modify();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_03());
        C4BCAssignableRangeHeader."Field Range From" := 300000;
        C4BCAssignableRangeHeader."Field Range To" := 350000;
        C4BCAssignableRangeHeader.Modify();
        Clear(C4BCAssignableRangeHeader);
    end;

    /// <summary> 
    /// Initializace records for extension tests/// 
    /// </summary>
    procedure InitializeExtensions()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionHeader.DeleteAll();
        C4BCExtensionObject.DeleteAll();

        // First Extension Header
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.Insert();

        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::Table);
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::Table);
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::Report);
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"XML Port");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"XML Port");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"Table Extension");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);

        // Second Extension Header (same assignable range)
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.Insert();

        // Third Extension Header (same assignable range)
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.Insert();

        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"Table Extension");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);

        // Fifth Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_03());
        C4BCExtensionHeader.Insert();

        // Sixth Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_04());
        C4BCExtensionHeader.Insert();

        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"XML Port");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"XML Port");
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);

        // Seventh Extension Header
        Clear(C4BCExtensionHeader);
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCAssignableRangeHeader_Code_06());
        C4BCExtensionHeader.ID := CreateGuid();
        C4BCExtensionHeader.Insert();

        C4BCExtensionObject.Init();
        C4BCExtensionObject.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.Validate("Object Type", C4BCExtensionObject."Object Type"::"XML Port");
        C4BCExtensionObject."Object Name" := 'TKA Sales Header';
        C4BCExtensionObject.Insert();
        Clear(C4BCExtensionObject);
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
        C4BCBusinessCentralInstance.Code := C4BCBusinessCentralInstance_Code_01();
        C4BCBusinessCentralInstance.Insert();
        Clear(C4BCBusinessCentralInstance);

        C4BCBusinessCentralInstance.Init();
        C4BCBusinessCentralInstance.Code := C4BCBusinessCentralInstance_Code_02();
        C4BCBusinessCentralInstance.Insert();

        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindSet();

        C4BCExtensionUsage.Init();
        C4BCExtensionUsage."Business Central Instance Code" := C4BCBusinessCentralInstance_Code_01();
        C4BCExtensionUsage."Extension Code" := C4BCExtensionHeader.Code;
        C4BCExtensionUsage.Insert();
        Clear(C4BCExtensionUsage);

        C4BCExtensionHeader.Next(1);

        C4BCExtensionUsage.Init();
        C4BCExtensionUsage."Business Central Instance Code" := C4BCBusinessCentralInstance_Code_01();
        C4BCExtensionUsage."Extension Code" := C4BCExtensionHeader.Code;
        C4BCExtensionUsage.Insert();
    end;
}