
function upperCaseFirstWord(str:String):String
{ 
    var strCap:String = str.charAt(0).toUpperCase() + str.substr(1 , str.length);
    for(var i:Number = 0; i < strCap.length; i++)
    {
        if(strCap.charAt(i) == " ") strCap.charAt(i+1).toUpperCase();
    }
    return strCap;
}    



































/*
    Uppercases the words between spaces.
*/
function upperCaseFirstWord(str:String):String
{ 
    var stringArray:Array = str.split(" ");
    for(var i:Number = 0; i < stringArray.length; i++)
    {
        stringArray[i] = stringArray[i].charAt(0).toUpperCase() + stringArray[i].substr(1, stringArray[i].length);
    }
    return stringArray.join(" ");
} 





























function upperCaseFirstWord(str:String):String
{
    //                                          [0,      1      ]
    var stringArray:Array = str.split(" "); // [“steel”, “sworD”] [“steel s”, “orD”] length: 2
    var finalString:String;
    for(var i:Number = 0; i < stringArray.length; i++)
    {
        var prefix:String = stringArray[i].charAt(0).toUpperCase(); // returns "S"
        var suffix:String = stringArray[i].substr(1, stringArray[i].length); // returns "teel"
        stringArray[i] = prefix + suffix;
    }
    finalString = stringArray.join(" ");
    return finalString;
}    
upperCaseFirstWord("jlfsakd as;dljfkv vosdia"); //Jlfsak...
upperCaseFirstWord("home cake"); //Home Cak...
upperCaseFirstWord("home cake lel"); //Home Cake Lel

/*
            Jlfsakd As;dljfkv Vosdia
            Home Cake
            Home Cake Lel
*/