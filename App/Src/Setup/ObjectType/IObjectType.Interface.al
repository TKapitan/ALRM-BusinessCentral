/// <summary>
/// Interface "ART IObject Type."
/// </summary>
interface "ART IObject Type"
{
    /// <summary> 
    /// Specifies whether the objects are licensed or are free to use
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure IsLicensed(): Boolean;

    /// <summary> 
    /// Specifies whether the object type use ID for their identification
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure HasIDs(): Boolean;

    /// <summary>
    /// Specifies whether the newly created object extends already existing object.
    /// </summary>
    /// <returns>Return value of type "Boolean".</returns>
    procedure ExtendOtherObjects(): Boolean;
}