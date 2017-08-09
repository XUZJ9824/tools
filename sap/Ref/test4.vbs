lowDate = "26.07.2015" Rem: start date for effort report


tmpDate = InputBox("Input Start Date", "SAP Effort Report", lowDate)
if  IsDate( tmpDate ) then
    lowDate = tmpDate
    MsgBox "Good"
else 
    MsgBox "Invalid Date " & tmpDate & ", we use default : " & lowDate
end if
    
    
    
    lowDate = "07.26.2015" Rem: start date for effort report
    tmpDate = InputBox("Input Start Date", "SAP Effort Report", lowDate)
    if  IsDate( tmpDate ) then
        lowDate = tmpDate
        MsgBox "Good"
    else 
        MsgBox "Invalid Date " & tmpDate & ", we use default : " & lowDate
    end if
    
    lowDate = "2015.07.26" Rem: start date for effort report
    tmpDate = InputBox("Input Start Date", "SAP Effort Report", lowDate)
    if  IsDate( tmpDate ) then
        lowDate = tmpDate
        MsgBox "Good"
    else 
        MsgBox "Invalid Date " & tmpDate & ", we use default : " & lowDate
    end if
    
    lowDate = "2015/07/26" Rem: start date for effort report
    tmpDate = InputBox("Input Start Date", "SAP Effort Report", lowDate)
    if  IsDate( tmpDate ) then
        lowDate = tmpDate
        MsgBox "Good"
    else 
        MsgBox "Invalid Date " & tmpDate & ", we use default : " & lowDate
    end if