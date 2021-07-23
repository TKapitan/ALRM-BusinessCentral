/// <summary>
/// Codeunit C4BC Standard Object (ID 80001) implements Interface C4BC IObject Type.
/// </summary>
codeunit 80001 "C4BC Standard Object" implements "C4BC IObject Type"
{
    ObsoleteState = Pending;
    ObsoleteTag = '2021/Q4';
    ObsoleteReason = 'Replaced by configuration in table 80008 "C4BC Object Type"; Will be removed in 2021/Q4.';

    /// <summary> 
    /// Specifies whether the objects are licensed or are free to use
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure IsLicensed(): Boolean
    begin
        exit(false);
    end;

    /// <summary> 
    /// Specifies whether the object type use ID for their identification
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure HasIDs(): Boolean
    begin
        exit(true);
    end;

    /// <summary>
    /// Specifies whether the newly created object extends already existing object.
    /// </summary>
    /// <returns>Return value of type "Boolean".</returns>
    procedure ExtendOtherObjects(): Boolean
    begin
        exit(false);
    end;
}