codeunit 79002 "ART Extension Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        BadNewIDErr: Label 'Bad new ID. Expected %1, Received %2.', Locked = true;

    [Test]
    /// <summary> 
    /// Try to create a new extension card as an user
    /// </summary>
    procedure TestCreatingNewExtensionAsUser()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        Clear(ARTExtensionHeader);

        ARTExtensionHeader.Init();
        asserterror ARTExtensionHeader.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_02());
        Assert.ExpectedError('must have a value');
    end;

    [Test]
    /// <summary> 
    /// Try to assign new object IDs on the newly created extension card as an user
    /// </summary>
    procedure TestAssigningNewObjectIDsOnTheNewlyCreatedExtensionCardAsUser()
    var
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        ARTExtensionCard: TestPage "ART Extension Card";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTExtensionCard.OpenNew();
        ARTExtensionCard."Assignable Range Code".SetValue(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Table);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC1');
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Table);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC2');
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30001, StrSubstNo(BadNewIDErr, 30001, TempInt));
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Report);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC3');
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::"XML Port");
        ARTExtensionCard.Subform."Object Name".SetValue('ABC4');
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 99000, StrSubstNo(BadNewIDErr, 99000, TempInt));
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::"XML Port");
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 99001, StrSubstNo(BadNewIDErr, 99001, TempInt));
        ARTExtensionCard.Close();
        Clear(ARTExtensionCard);
    end;

    [Test]
    /// <summary> 
    /// Try to assign new object IDs on the newly created extension card as an user
    /// </summary>
    procedure TestAssigningNewObjectIDsForObjectTypeWithoutIDsOnTheNewlyCreatedExtensionCardAsUser()
    var
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        ARTExtensionCard: TestPage "ART Extension Card";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTExtensionCard.OpenNew();
        ARTExtensionCard."Assignable Range Code".SetValue(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Table);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC1');
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform.Previous();
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        ARTExtensionCard.Subform.Next();

        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Interface);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC2');
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform.Previous();
        Assert.IsTrue(ARTExtensionCard.Subform."Object ID".Value() = '', StrSubstNo(BadNewIDErr, '', ARTExtensionCard.Subform."Object ID".Value()));
        ARTExtensionCard.Subform.Next();

        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Interface);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC3');
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform.Previous();
        Assert.IsTrue(ARTExtensionCard.Subform."Object ID".Value() = '', StrSubstNo(BadNewIDErr, '', ARTExtensionCard.Subform."Object ID".Value()));
        ARTExtensionCard.Subform.Next();

        ARTExtensionCard.Subform."Object Type".SetValue("ART Object Type"::Table);
        ARTExtensionCard.Subform."Object Name".SetValue('ABC4');
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Subform.Previous();
        Evaluate(TempInt, ARTExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30001, StrSubstNo(BadNewIDErr, 30001, TempInt));
        ARTExtensionCard.Subform.Next();
        ARTExtensionCard.Close();
        Clear(ARTExtensionCard);
    end;


    [Test]
    /// <summary> 
    /// Test object name structure based on the template.
    /// </summary>
    procedure TestObjectName()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetObjectNameTemplate();
        Commit();

        ARTExtensionObject.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionObject.FindFirst();

        //[THEN] then
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
        asserterror ARTExtensionObject.Validate("Object Name", 'ARTMy Object');
        Assert.ExpectedError('does not meet template rules');
        asserterror ARTExtensionObject.Validate("Object Name", 'My Object ART');
        Assert.ExpectedError('does not meet template rules');
        asserterror ARTExtensionObject.Validate("Object Name", 'My Object');
        Assert.ExpectedError('does not meet template rules');
        asserterror ARTExtensionObject.Validate("Object Name", ' ART My Object');
        Assert.ExpectedError('does not meet template rules');
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
    end;


    [Test]
    /// <summary> 
    /// Test object name when no template is defined.
    /// </summary>
    procedure TestObjectNameWithoutTemplate()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        // No Template is set
        Commit();

        ARTExtensionObject.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionObject.FindFirst();

        //[THEN] then
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
        ARTExtensionObject.Validate("Object Name", 'ARTMy Object');
        ARTExtensionObject.Validate("Object Name", 'My Object ART');
        ARTExtensionObject.Validate("Object Name", 'My Object');
        ARTExtensionObject.Validate("Object Name", ' ART My Object');
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
    end;


    [Test]
    /// <summary> 
    /// Test extension objects with empty names
    /// </summary>
    procedure TestEmptyObjectName()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetObjectNameTemplate();
        Commit();

        ARTExtensionObject.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::Table);
        ARTExtensionObject.FindFirst();

        //[THEN] then
        ARTExtensionObject.Validate("Object Name", 'ART XYZ MY Object');
        asserterror ARTExtensionObject.Validate("Object Name", '');
        Assert.ExpectedError('must have a value');
    end;


    [Test]
    /// <summary> 
    /// Test how the duplicity name control works
    /// </summary>
    procedure TestObjectNameDuplicityInTheSameExtension()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetObjectNameTemplate();
        ARTExtensionObject.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::Table);
        ARTExtensionObject.FindFirst();

        //[THEN] then
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
        ARTExtensionObject.Modify();

        //[WHEN] when
        ARTExtensionObject.Next(1);

        //[THEN] then
        asserterror ARTExtensionObject.Validate("Object Name", 'ART My Object');
        Assert.ExpectedError('is already in use.');
    end;


    [Test]
    /// <summary> 
    /// Test delete extension, whether all related records are deleted.
    /// </summary>
    procedure TestDeleteExtension()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTExtensionHeader: Record "ART Extension Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[WHEN] when
        ARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.FindFirst();

        //[THEN] then
        ARTExtensionHeader.Delete(true);
        ARTExtensionObject.SetRange("Extension Code", ARTExtensionHeader.Code);
        Assert.RecordIsEmpty(ARTExtensionObject);

    end;


    [Test]
    /// <summary> 
    /// Test how the duplicity of extension ID is resolved
    /// </summary>
    procedure TestExtensionIDDuplicity()
    var
        ARTExtensionHeader, HelperARTExtensionHeader : Record "ART Extension Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[WHEN] when
        ARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_06());
        ARTExtensionHeader.FindFirst();
        HelperARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_04());
        ARTExtensionHeader.FindFirst();

        //[THEN] then
        asserterror HelperARTExtensionHeader.Validate(ID, ARTExtensionHeader.ID);
        Assert.ExpectedError('already exists');
        HelperARTExtensionHeader.Validate(ID, CreateGuid());
    end;


    [Test]
    /// <summary> 
    /// Test how the ID is validated when new extension is created.
    /// </summary>
    procedure TestCreateExtensionID()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTExtensionHeader.Init();
        ARTExtensionHeader.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.Validate(ID, CreateGuid());
        ARTExtensionHeader.Insert(true);
        Clear(ARTExtensionHeader);
    end;


    [Test]
    /// <summary> 
    /// Try to assign new object IDs on the newly created extension card as an user
    /// </summary>
    procedure TestAssigningNewFieldIDs()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTExtensionObject: Record "ART Extension Object";
        ARTExtensionObjectLine: Record "ART Extension Object Line";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeAssignableFieldRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[WHEN] when
        ARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.FindFirst();
        ARTExtensionObject.SetRange("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::Table);
        ARTExtensionObject.FindFirst();

        //[THEN] then
        ARTExtensionObjectLine.Init();
        ARTExtensionObjectLine.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObjectLine.Validate("Object Type", ARTExtensionObject."Object Type");
        ARTExtensionObjectLine.Validate("Object ID", ARTExtensionObject."Object ID");
        ARTExtensionObjectLine.Insert(true);
        Assert.IsTrue(ARTExtensionObjectLine.ID = 200000, StrSubstNo(BadNewIDErr, 200000, ARTExtensionObjectLine.ID));
        Clear(ARTExtensionObjectLine);

        ARTExtensionObjectLine.Init();
        ARTExtensionObjectLine.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObjectLine.Validate("Object Type", ARTExtensionObject."Object Type");
        ARTExtensionObjectLine.Validate("Object ID", ARTExtensionObject."Object ID");
        ARTExtensionObjectLine.Insert(true);
        Assert.IsTrue(ARTExtensionObjectLine.ID = 200001, StrSubstNo(BadNewIDErr, 200001, ARTExtensionObjectLine.ID));
        Clear(ARTExtensionObjectLine);

        ARTExtensionObjectLine.Init();
        ARTExtensionObjectLine.Validate("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObjectLine.Validate("Object Type", ARTExtensionObject."Object Type");
        ARTExtensionObjectLine.Validate("Object ID", ARTExtensionObject."Object ID");
        ARTExtensionObjectLine.Insert(true);
        Assert.IsTrue(ARTExtensionObjectLine.ID = 200002, StrSubstNo(BadNewIDErr, 200002, ARTExtensionObjectLine.ID));
    end;
}