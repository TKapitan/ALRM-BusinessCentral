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
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
        C4BCExtensionCard: TestPage "C4BC Extension Card";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCExtensionCard.OpenNew();
        C4BCExtensionCard."Assignable Range Code".SetValue(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        Clear(C4BCExtensionCard);

        //[THEN] then
        C4BCExtensionCard.OpenNew();
        asserterror C4BCExtensionCard."Assignable Range Code".SetValue(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_02());
        Assert.ExpectedError('No. Series must have a value');
        C4BCExtensionCard.Close();
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
        C4BCExtensionLine: Record "C4BC Extension Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCExtensionLine.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionLine.FindFirst();

        //[THEN] then
        C4BCExtensionLine.Validate("Object Name", 'C4BC My Object');
        asserterror C4BCExtensionLine.Validate("Object Name", 'C4BCMy Object');
        Assert.ExpectedError('not meet object name template rules');
        asserterror C4BCExtensionLine.Validate("Object Name", 'My Object C4BC');
        Assert.ExpectedError('not meet object name template rules');
        asserterror C4BCExtensionLine.Validate("Object Name", 'My Object');
        Assert.ExpectedError('not meet object name template rules');
        asserterror C4BCExtensionLine.Validate("Object Name", ' C4BC My Object');
        Assert.ExpectedError('not meet object name template rules');
        C4BCExtensionLine.Validate("Object Name", 'C4BC My Object');
    end;

    [Test]
    /// <summary> 
    /// Test how the duplicity name control works
    /// </summary>
    procedure TestObjectNameDuplicityInTheSameExtension()
    var
        C4BCExtensionLine: Record "C4BC Extension Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCExtensionLine.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionLine.SetRange("Object Type", C4BCExtensionLine."Object Type"::Table);
        C4BCExtensionLine.FindFirst();

        //[THEN] then
        C4BCExtensionLine.Validate("Object Name", 'C4BC My Object');

        //[WHEN] when
        C4BCExtensionLine.Next(1);

        //[THEN] then
        asserterror C4BCExtensionLine.Validate("Object Name", 'C4BC My Object');
        Assert.ExpectedError('with the same name');
    end;

    [Test]
    /// <summary> 
    /// Test delete extension, whether all related records are deleted.
    /// </summary>
    procedure TestDeleteExtension()
    var
        C4BCExtensionLine: Record "C4BC Extension Line";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionUsage: Record "C4BC Extension Usage";
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
        C4BCExtensionLine.SetRange("Extension Code", C4BCExtensionHeader.Code);
        Assert.RecordIsEmpty(C4BCExtensionLine);

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetExtensionUsage();

        //[THEN] then
        C4BCExtensionHeader.Delete(true);
        C4BCExtensionUsage.SetRange("Extension Code", C4BCExtensionHeader.Code);
        Assert.RecordIsEmpty(C4BCExtensionUsage);
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
        Assert.ExpectedError('must not be empty'); // ID
        C4BCExtensionHeader.Validate(ID, CreateGuid());
        C4BCExtensionHeader.Insert(true);
        Clear(C4BCExtensionHeader);
    end;
}