Class extends Entity

local Function _computeAge() : Object
	
	Case of 
		: (This:C1470.dateOfBirth=Null:C1517)
			return Null:C1517
			
		: (This:C1470.dateOfBirth=!00-00-00!)
			return Null:C1517
			
		Else 
			
			var $currentDate; $dateOfBirth : Date
			$currentDate:=Current date:C33
			$dateOfBirth:=This:C1470.dateOfBirth
			
			var $years; $months; $days : Integer
			
			$birthYear:=Year of:C25($dateOfBirth)
			$birthMonth:=Month of:C24($dateOfBirth)
			$birthDay:=Day of:C23($dateOfBirth)
			
			$currentYear:=Year of:C25($currentDate)
			$currentMonth:=Month of:C24($currentDate)
			$currentDay:=Day of:C23($currentDate)
			
			$thisBirthDay:=Add to date:C393(!00-00-00!; $currentYear; $birthMonth; $birthDay)
			
			//get years and months
			$years:=$currentYear-$birthYear
			$months:=$currentMonth-$birthMonth
			
			Case of 
				: (Month of:C24($dateOfBirth)=2) & (Month of:C24($thisBirthDay)=3) & ($currentDate=$thisBirthDay)
					//today=birthday this year=mar 1, birthday is feb 29
					$months:=0
					$days:=0
				: (Month of:C24($dateOfBirth)=2) & (Month of:C24($thisBirthDay)=3) & ($currentDate>$thisBirthDay) & ($currentMonth=3)
					//birthday this year is in the past, birthday is feb 29, current year is not leap
					$months:=0
					$days:=$currentDay-1
				: (Month of:C24($dateOfBirth)=2) & (Month of:C24($thisBirthDay)=3) & ($currentMonth=1)
					//birthday this year is in the future, birthday is feb 29, current year is not leap, count days from previous month=dec
					$years:=$years-1
					$months:=$months+12
					$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear-1; 12; $birthDay)
				: (Month of:C24($dateOfBirth)=2) & (Month of:C24($thisBirthDay)=3)
					//birthday this year is in the past, birthday is feb 29, current year is not leap, count days from previous month
					$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
				: ($currentDate<$thisBirthDay) & ($birthDay>$currentDay) & ($currentMonth=1)
					//birthday this year is in the future, count days from previous month=dec
					$years:=$years-1
					$months:=$months+11
					$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear-1; 12; $birthDay)
				: ($currentDate<$thisBirthDay) & ($birthDay>$currentDay)
					//birthday this year is in the future, count days from previous month
					$years:=$years-1
					$months:=$months+11
					$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
				: ($currentDate<$thisBirthDay)
					//birthday this year is in the future, count days from current month
					$years:=$years-1
					$months:=$months+12
					$days:=$currentDay-$birthDay
				: ($currentDate=$thisBirthDay)
					//today=birthday 
					$months:=0
					$days:=0
				: ($birthDay>$currentDay) & ($currentMonth=1)
					//birthday this year is in the past, count days from previous month=dec
					$months:=$months-1
					$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
				: ($birthDay>$currentDay)
					//birthday this year is in the past, count days from previous month
					$months:=$months-1
					$lastDayOfPreviousMonth:=Day of:C23(Add to date:C393(!00-00-00!; $currentYear; $currentMonth; 1)-1)
					If ($lastDayOfPreviousMonth>$birthDay)
						$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
					Else 
						$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $lastDayOfPreviousMonth)
					End if 
				Else 
					//birthday this year is in the past, count days from current month
					$days:=$currentDay-$birthDay
			End case 
			
	End case 
	
	return {years: $years; months: $months; days: $days}
	
Function get age() : Integer
	
	var $age : Object
	$age:=This:C1470._computeAge()
	
	return $age#Null:C1517 ? $age.years : Null:C1517
	
Function get yearOfBirth() : Integer
	
	return This:C1470.dateOfBirth ? Year of:C25(This:C1470.dateOfBirth) : Null:C1517
	
Function query age($event : Object) : Object
	
	var $from; $to; $today : Date
	$today:=Current date:C33
	var $query : Text
	
	Case of 
		: ($event.operator="==")
			
			$query:="dateOfBirth > :1 and dateOfBirth < :2"
			
		: ($event.operator="===")
			
			$query:="dateOfBirth == :2"
			
		: ($event.operator="!=")
			
			$query:="not(dateOfBirth > :1 and dateOfBirth < :2)"
			
		: ($event.operator="!==")
			
			$query:="not(dateOfBirth == :2)"
			
		: ($event.operator=">=")
			
			$query:="dateOfBirth < :2"
			
		: ($event.operator="<=")
			
			$query:="dateOfBirth >= :1"
			
		: ($event.operator=">")
			
			$query:="dateOfBirth < :2"
			$event.value+=1
			
		: ($event.operator="<")
			
			$query:="dateOfBirth >= :1"
			$event.value-=1
			
		Else 
			return 
	End case 
	
	var $parameters : Collection
	
	Case of 
		: ($event.value=Null:C1517) && (($event.operator="==") || ($event.operator="==="))
			
			$query:="dateOfBirth == null"
			
		: ($event.value=Null:C1517) && (($event.operator="!=") || ($event.operator="!=="))
			
			$query:="dateOfBirth != null"
			
		Else 
			$from:=Add to date:C393($today; -$event.value-1; 0; 0)
			$to:=Add to date:C393($today; -$event.value; 0; 0)
			$parameters:=[$from; $to]
	End case 
	
	return {query: $query; parameters: $parameters}
	
Function query yearOfBirth($event : Object) : Object
	
	var $from; $to; $today : Date
	$today:=Current date:C33
	var $query : Text
	
	Case of 
		: ($event.operator="==") || ($event.operator="===")
			
			$query:="dateOfBirth >= :1 and dateOfBirth <= :2"
			
		: ($event.operator="!=") || ($event.operator="!==")
			
			$query:="not(dateOfBirth >= :1 and dateOfBirth <= :2)"
			
		: ($event.operator=">=")
			
			$query:="dateOfBirth >= :1"
			
		: ($event.operator="<=")
			
			$query:="dateOfBirth <= :2"
			
		: ($event.operator=">")
			
			$query:="dateOfBirth > :2"
			
		: ($event.operator="<")
			
			$query:="dateOfBirth < :1"
			
		Else 
			return 
	End case 
	
	$from:=Add to date:C393(!00-00-00!; $event.value; 1; 1)
	$to:=Add to date:C393(!00-00-00!; $event.value; 12; 31)
	
	var $parameters : Collection
	$parameters:=[$from; $to]
	
	return {query: $query; parameters: $parameters}
	
Function orderBy age($event : Object) : Text
	
	return ($event.operator="desc") ? "dateOfBirth asc" : "dateOfBirth desc"
	
Function orderBy yearOfBirth($event : Object) : Text
	
	return ($event.operator="desc") ? "dateOfBirth desc" : "dateOfBirth asc"