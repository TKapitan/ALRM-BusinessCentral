codeunit 79002 "C4BC Extension Tests"
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
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        Clear(C4BCExtensionHeader);

        //[THEN] then
        C4BCExtensionHeader.Init();
        asserterror C4BCExtensionHeader.Validate("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_02());
        Assert.ExpectedError('No. Series must have a value');
    end;

    [Test]
    /// <summary> 
    /// Try to assign new object IDs on the newly created extension card as an user
    /// </summary>
    procedure TestAssigningNewObjectIDsOnTheNewlyCreatedExtensionCardAsUser()
    var
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
        C4BCExtensionCard: TestPage "C4BC Extension Card";
        TempInt: Integer;
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCExtensionCard.OpenNew();
        C4BCExtensionCard."Assignable Range Code".SetValue(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionCard.Subform."Object Type".SetValue("C4BC Object Type"::Table);
        Evaluate(TempInt, C4BCExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        C4BCExtensionCard.Subform.Next();
        C4BCExtensionCard.Subform."Object Type".SetValue("C4BC Object Type"::Table);
        Evaluate(TempInt, C4BCExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30001, StrSubstNo(BadNewIDErr, 30001, TempInt));
        C4BCExtensionCard.Subform.Next();
        C4BCExtensionCard.Subform."Object Type".SetValue("C4BC Object Type"::Report);
        Evaluate(TempInt, C4BCExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        C4BCExtensionCard.Subform.Next();
        C4BCExtensionCard.Subform."Object Type".SetValue("C4BC Object Type"::"XML Port");
        Evaluate(TempInt, C4BCExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 99000, StrSubstNo(BadNewIDErr, 99000, TempInt));
        C4BCExtensionCard.Subform.Next();
        C4BCExtensionCard.Subform."Object Type".SetValue("C4BC Object Type"::"XML Port");
        Evaluate(TempInt, C4BCExtensionCard.Subform."Object ID".Value());
        Assert.IsTrue(TempInt = 99001, StrSubstNo(BadNewIDErr, 99001, TempInt));
        C4BCExtensionCard.Close();
        Clear(C4BCExtensionCard);
    end;

    [Test]
    /// <summary> 
    /// Test object name structure based on the template.
    /// </summary>
    procedure TestObjectName()
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCExtensionObject.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionObject.FindFirst();

        //[THEN] then
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        asserterror C4BCExtensionObject.Validate("Object Name", 'C4BCMy Object');
        Assert.ExpectedError('Object name does not meet template rules defined in assignable range header.');
        asserterror C4BCExtensionObject.Validate("Object Name", 'My Object C4BC');
        Assert.ExpectedError('Object name does not meet template rules defined in assignable range header.');
        asserterror C4BCExtensionObject.Validate("Object Name", 'My Object');
        Assert.ExpectedError('Object name does not meet template rules defined in assignable range header.');
        asserterror C4BCExtensionObject.Validate("Object Name", ' C4BC My Object');
        Assert.ExpectedError('Object name does not meet template rules defined in assignable range header.');
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
    end;

    [Test]
    /// <summary> 
    /// Test object name when no template is defined.
    /// </summary>
    procedure TestObjectNameWithoutTemplate()
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        // No Template is set
        C4BCExtensionObject.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionObject.FindFirst();

        //[THEN] then
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        C4BCExtensionObject.Validate("Object Name", 'C4BCMy Object');
        C4BCExtensionObject.Validate("Object Name", 'My Object C4BC');
        C4BCExtensionObject.Validate("Object Name", 'My Object');
        C4BCExtensionObject.Validate("Object Name", ' C4BC My Object');
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
    end;

    [Test]
    /// <summary> 
    /// Test extension objects with empty names
    /// </summary>
    procedure TestEmptyObjectName()
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCExtensionObject.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::Table);
        C4BCExtensionObject.FindFirst();

        //[THEN] then
        C4BCExtensionObject.Validate("Object Name", 'C4BC XYZ MY Object');
        asserterror C4BCExtensionObject.Validate("Object Name", '');
        Assert.ExpectedError('must have value');
    end;

    [Test]
    /// <summary> 
    /// Test how the duplicity name control works
    /// </summary>
    procedure TestObjectNameDuplicityInTheSameExtension()
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCExtensionObject.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::Table);
        C4BCExtensionObject.FindFirst();

        //[THEN] then
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        C4BCExtensionObject.Modify();

        //[WHEN] when
        C4BCExtensionObject.Next(1);

        //[THEN] then
        asserterror C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        Assert.ExpectedError('Object name with the same object type cannot be duplicit.');
    end;

    [Test]
    /// <summary> 
    /// Test delete extension, whether all related records are deleted.
    /// </summary>
    procedure TestDeleteExtension()
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindFirst();

        //[THEN] then
        C4BCExtensionHeader.Delete(true);
        C4BCExtensionObject.SetRange("Extension Code", C4BCExtensionHeader.Code);
        Assert.RecordIsEmpty(C4BCExtensionObject);

    end;

    [Test]
    /// <summary> 
    /// Test how the duplicity of extension ID is resolved
    /// </summary>
    procedure TestExtensionIDDuplicity()
    var
        C4BCExtensionHeader, HelperC4BCExtensionHeader : Record "C4BC Extension Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_06());
        C4BCExtensionHeader.FindFirst();
        HelperC4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_04());
        C4BCExtensionHeader.FindFirst();

        //[THEN] then
        asserterror HelperC4BCExtensionHeader.Validate(ID, C4BCExtensionHeader.ID);
        Assert.ExpectedError('already exists');
        HelperC4BCExtensionHeader.Validate(ID, CreateGuid());
    end;

    [Test]
    /// <summary> 
    /// Test how the ID is validated when new extension is created.
    /// </summary>
    procedure TestCreateExtensionID()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCExtensionHeader.Init();
        C4BCExtensionHeader.Validate("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        asserterror C4BCExtensionHeader.Insert(true);
        Assert.ExpectedError('must have a value');
        C4BCExtensionHeader.Validate(ID, CreateGuid());
        C4BCExtensionHeader.Insert(true);
        Clear(C4BCExtensionHeader);
    end;

    [Test]
    /// <summary> 
    /// Try to assign new object IDs on the newly created extension card as an user
    /// </summary>
    procedure TestAssigningNewFieldIDs()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeAssignableFieldRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindFirst();
        C4BCExtensionObject.SetRange("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::Table);
        C4BCExtensionObject.FindFirst();

        //[THEN] then
        C4BCExtensionObjectLine.Init();
        C4BCExtensionObjectLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObjectLine.Validate("Object Type", C4BCExtensionObject."Object Type");
        C4BCExtensionObjectLine.Validate("Object ID", C4BCExtensionObject."Object ID");
        Assert.IsTrue(C4BCExtensionObjectLine.ID = 200000, StrSubstNo(BadNewIDErr, 200000, C4BCExtensionObjectLine.ID));
        C4BCExtensionObjectLine.Insert(true);
        Clear(C4BCExtensionObjectLine);

        C4BCExtensionObjectLine.Init();
        C4BCExtensionObjectLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObjectLine.Validate("Object Type", C4BCExtensionObject."Object Type");
        C4BCExtensionObjectLine.Validate("Object ID", C4BCExtensionObject."Object ID");
        Assert.IsTrue(C4BCExtensionObjectLine.ID = 200001, StrSubstNo(BadNewIDErr, 200001, C4BCExtensionObjectLine.ID));
        C4BCExtensionObjectLine.Insert(true);
        Clear(C4BCExtensionObjectLine);

        C4BCExtensionObjectLine.Init();
        C4BCExtensionObjectLine.Validate("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObjectLine.Validate("Object Type", C4BCExtensionObject."Object Type");
        C4BCExtensionObjectLine.Validate("Object ID", C4BCExtensionObject."Object ID");
        Assert.IsTrue(C4BCExtensionObjectLine.ID = 200002, StrSubstNo(BadNewIDErr, 200002, C4BCExtensionObjectLine.ID));
        C4BCExtensionObjectLine.Insert(true);
    end;
}