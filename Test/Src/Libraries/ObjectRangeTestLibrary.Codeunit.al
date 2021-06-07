/// <summary>
/// Codeunit ART Object Range Test Library (ID 79003).
/// </summary>
codeunit 79003 "ART Object Range Test Library"
{
    /// <summary> 
    /// Code for #1 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_01(): Code[20]
    begin
        exit('RANGE1');
    end;

    /// <summary> 
    /// Code for #2 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_02(): Code[20]
    begin
        exit('RANGE2');
    end;

    /// <summary> 
    /// Code for #3 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_03(): Code[20]
    begin
        exit('RANGE3');
    end;

    /// <summary> 
    /// Code for #4 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_04(): Code[20]
    begin
        exit('RANGE4');
    end;

    /// <summary> 
    /// Code for #5 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_05(): Code[20]
    begin
        exit('RANGE5');
    end;

    /// <summary> 
    /// Code for #6 assignable range header
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTAssignableRangeHeader_Code_06(): Code[20]
    begin
        exit('RANGE6');
    end;

    /// <summary> 
    /// Code for #1 business central instance
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTBusinessCentralInstance_Code_01(): Code[20]
    begin
        exit('KEPTY.CZ');
    end;

    /// <summary> 
    /// Code for #2 business central instance
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    procedure ARTBusinessCentralInstance_Code_02(): Code[20]
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
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTExtensionHeader: Record "ART Extension Header";
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTAssignableRangeHeader.DeleteAll();
        ARTAssignableRangeLine.DeleteAll();
        ARTExtensionHeader.DeleteAll();
        ARTExtensionObject.DeleteAll();

        InitializeNoSeries();

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_01();
        ARTAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        ARTAssignableRangeHeader."Ranges per BC Instance" := false;
        ARTAssignableRangeHeader."Default Object Range From" := 30000;
        ARTAssignableRangeHeader."Default Object Range To" := 39000;
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine."Assignable Range Code" := ARTAssignableRangeHeader_Code_01();
        ARTAssignableRangeLine."Object Type" := ARTAssignableRangeLine."Object Type"::"XML Port";
        ARTAssignableRangeLine."Object Range From" := 99000;
        ARTAssignableRangeLine."Object Range To" := 99999;
        ARTAssignableRangeLine.Insert();
        Clear(ARTAssignableRangeLine);

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_02();
        // ARTAssignableRangeHeader."No. Series" DO NOT SPECIFY
        ARTAssignableRangeHeader."Ranges per BC Instance" := false;
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_03();
        ARTAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        ARTAssignableRangeHeader."Ranges per BC Instance" := true;
        ARTAssignableRangeHeader."Default Object Range From" := 40000;
        ARTAssignableRangeHeader."Default Object Range To" := 49000;
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine."Assignable Range Code" := ARTAssignableRangeHeader_Code_03();
        ARTAssignableRangeLine."Object Type" := ARTAssignableRangeLine."Object Type"::"Page Extension";
        ARTAssignableRangeLine."Object Range From" := 10000;
        ARTAssignableRangeLine."Object Range To" := 10010;
        ARTAssignableRangeLine.Insert();
        Clear(ARTAssignableRangeLine);

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_04();
        ARTAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        ARTAssignableRangeHeader."Ranges per BC Instance" := false;
        ARTAssignableRangeHeader."Default Object Range From" := 60000;
        ARTAssignableRangeHeader."Default Object Range To" := 69000;
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine."Assignable Range Code" := ARTAssignableRangeHeader_Code_04();
        ARTAssignableRangeLine."Object Type" := ARTAssignableRangeLine."Object Type"::"XML Port";
        ARTAssignableRangeLine."Object Range From" := 75000;
        ARTAssignableRangeLine."Object Range To" := 75020;
        ARTAssignableRangeLine.Insert();
        Clear(ARTAssignableRangeLine);

        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine."Assignable Range Code" := ARTAssignableRangeHeader_Code_04();
        ARTAssignableRangeLine."Object Type" := ARTAssignableRangeLine."Object Type"::Enum;
        ARTAssignableRangeLine."Object Range From" := 100000;
        ARTAssignableRangeLine."Object Range To" := 100010;
        ARTAssignableRangeLine.Insert();
        Clear(ARTAssignableRangeLine);

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_05();
        ARTAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        ARTAssignableRangeHeader."Ranges per BC Instance" := false;
        ARTAssignableRangeHeader."Default Object Range From" := 65000;
        ARTAssignableRangeHeader."Default Object Range To" := 66000;
        ARTAssignableRangeHeader."Object Name Template" := '';
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine."Assignable Range Code" := ARTAssignableRangeHeader_Code_05();
        ARTAssignableRangeLine."Object Type" := ARTAssignableRangeLine."Object Type"::"Enum Extension";
        ARTAssignableRangeLine."Object Range From" := 110000;
        ARTAssignableRangeLine."Object Range To" := 110010;
        ARTAssignableRangeLine.Insert();
        Clear(ARTAssignableRangeLine);

        ARTAssignableRangeHeader.Init();
        ARTAssignableRangeHeader.Code := ARTAssignableRangeHeader_Code_06();
        ARTAssignableRangeHeader."No. Series for Extensions" := 'ALRM-EXT';
        ARTAssignableRangeHeader."Ranges per BC Instance" := false;
        ARTAssignableRangeHeader."Default Object Range From" := 66000;
        ARTAssignableRangeHeader."Default Object Range To" := 67000;
        ARTAssignableRangeHeader."Object Name Template" := '';
        ARTAssignableRangeHeader.Insert();
        Clear(ARTAssignableRangeHeader);
    end;


    /// <summary> 
    /// Initializace records for assignable field range tests
    /// </summary>
    procedure InitializeAssignableFieldRanges()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
    begin
        ARTAssignableRangeHeader.Get(ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader."Field Range From" := 200000;
        ARTAssignableRangeHeader."Field Range To" := 250000;
        ARTAssignableRangeHeader.Modify();
        Clear(ARTAssignableRangeHeader);

        ARTAssignableRangeHeader.Get(ARTAssignableRangeHeader_Code_03());
        ARTAssignableRangeHeader."Field Range From" := 300000;
        ARTAssignableRangeHeader."Field Range To" := 350000;
        ARTAssignableRangeHeader.Modify();
        Clear(ARTAssignableRangeHeader);
    end;

    /// <summary> 
    /// Initializace records for extension tests/// 
    /// </summary>
    procedure InitializeExtensions()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTExtensionHeader.DeleteAll();
        ARTExtensionObject.DeleteAll();

        // First Extension Header
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.Insert();

        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::Table);
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::Table);
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::Report);
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"XML Port");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"XML Port");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"Table Extension");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);

        // Second Extension Header (same assignable range)
        Clear(ARTExtensionHeader);
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.Insert();

        // Third Extension Header (same assignable range)
        Clear(ARTExtensionHeader);
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.Insert();

        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"Table Extension");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);

        // Fifth Extension Header
        Clear(ARTExtensionHeader);
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_03());
        ARTExtensionHeader.Insert();

        // Sixth Extension Header
        Clear(ARTExtensionHeader);
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_04());
        ARTExtensionHeader.Insert();

        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"XML Port");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"XML Port");
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);

        // Seventh Extension Header
        Clear(ARTExtensionHeader);
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTAssignableRangeHeader_Code_06());
        ARTExtensionHeader.ID := CreateGuid();
        ARTExtensionHeader.Insert();

        ARTExtensionObject.Init();
        ARTExtensionObject.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.Validate("Object Type", ARTExtensionObject."Object Type"::"XML Port");
        ARTExtensionObject."Object Name" := 'TKA Sales Header';
        ARTExtensionObject.Insert();
        Clear(ARTExtensionObject);
    end;

    /// <summary> 
    /// Set object name template for some headers for test scenarious
    /// </summary>
    procedure SetObjectNameTemplate()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
    begin
        ARTAssignableRangeHeader.Get(ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader."Object Name Template" := 'ART *';
        ARTAssignableRangeHeader.Modify();
    end;

    /// <summary> 
    /// Set usage of some extensions for test scenarious
    /// </summary>
    procedure SetExtensionUsage()
    var
        ARTBusinessCentralInstance: Record "ART Business Central Instance";
        ARTExtensionHeader: Record "ART Extension Header";
        ARTExtensionUsage: Record "ART Extension Usage";
    begin
        ARTBusinessCentralInstance.DeleteAll();
        ARTExtensionUsage.DeleteAll();

        ARTBusinessCentralInstance.Init();
        ARTBusinessCentralInstance.Code := ARTBusinessCentralInstance_Code_01();
        ARTBusinessCentralInstance.Insert();
        Clear(ARTBusinessCentralInstance);

        ARTBusinessCentralInstance.Init();
        ARTBusinessCentralInstance.Code := ARTBusinessCentralInstance_Code_02();
        ARTBusinessCentralInstance.Insert();

        ARTExtensionHeader.SetRange("Assignable Range Code", ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.FindSet();

        ARTExtensionUsage.Init();
        ARTExtensionUsage."Business Central Instance Code" := ARTBusinessCentralInstance_Code_01();
        ARTExtensionUsage."Extension Code" := ARTExtensionHeader.Code;
        ARTExtensionUsage.Insert();
        Clear(ARTExtensionUsage);

        ARTExtensionHeader.Next(1);

        ARTExtensionUsage.Init();
        ARTExtensionUsage."Business Central Instance Code" := ARTBusinessCentralInstance_Code_01();
        ARTExtensionUsage."Extension Code" := ARTExtensionHeader.Code;
        ARTExtensionUsage.Insert();
    end;
}